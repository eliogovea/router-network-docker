#!/bin/bash

set -e
set -u
set -x

# Bring up both eth0 (LAN) and eth1 (WAN) interfaces if they're not already up
ip link set eth0 up
ip link set eth1 up

# Remove any existing IP addresses from the interfaces to avoid conflicts
ip addr flush dev eth0
ip addr flush dev eth1

# Set up IPv4 addresses for both interfaces
# eth0 for LAN
ip addr add 192.168.10.1/24 dev eth0
# eth1 for WAN
ip addr add 192.168.20.1/24 dev eth1

# Enable IPv4 packet forwarding to allow routing
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set default policy to DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Clear existing NAT iptables
iptables -t nat -F

# Masquerade LAN traffic going to WAN
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Clear existing iptables
iptables -F

# Set the NFQUEUE rule to send packets to queue 0
iptables -A INPUT -i eth0 -j NFQUEUE --queue-num 0

# Set the NFQUEUE rule to send packets to queue 0
iptables -A FORWARD -i eth0 -j NFQUEUE --queue-num 0

# Set the NFQUEUE rule to send packets to queue 0
# for traffic from WAN to LAN with established connections
iptables -A FORWARD -i eth1 -m state --state RELATED,ESTABLISHED -j NFQUEUE --queue-num 0

# Start dnsmasq
dnsmasq -C /etc/dnsmasq.conf

# Keep the container running to avoid exit
exec python3 /opt/packet_inspector.py
