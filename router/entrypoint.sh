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

# Clear existing NAT iptables
iptables -t nat -F

# Masquerade LAN traffic going to WAN
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Clear existing iptables
iptables -t filter -F

# Set default policy to DROP
iptables -t filter -P INPUT DROP

# Log packets
iptables -t filter -A INPUT -j NFLOG --nflog-group 1 --nflog-prefix "[INPUT]"

# Accept packets
iptables -t filter -A INPUT -j ACCEPT

# Set default policy to DROP
iptables -t filter -P FORWARD DROP

# Log packets
iptables -t filter -A FORWARD -i eth0 -j NFLOG --nflog-group 1 --nflog-prefix "[FORWARD]"

# Accept packets from LAN to WAN
iptables -t filter -A FORWARD -i eth0 -j ACCEPT

# Accept packets from WAN to LAN with stabilished connections
iptables -t filter -A FORWARD -i eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Set default policy to ACCEPT
iptables -t filter -P INPUT ACCEPT

# Set the NFLOG rule to log packets to group 1
iptables -t filter -A OUTPUT -j NFLOG --nflog-group 1 --nflog-prefix "[OUTPUT]"

# Start dnsmasq
dnsmasq -C /etc/dnsmasq.conf

# Keep the container running to avoid exit
exec ulogd -c /etc/ulogd.conf -v
