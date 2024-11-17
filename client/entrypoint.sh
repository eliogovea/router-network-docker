#!/bin/sh

set -e
set -u
set -x

# Bring up the eth0 network interface if it's not already up
ip link set eth0 up

# Remove any existing IP addresses from eth0 to avoid conflicts
ip addr flush dev eth0

# Clear existing iptables
iptables -F

# Set default policy to DROP
iptables -t filter -P INPUT DROP

# Set the NFQUEUE rule to send packets to queue 0
iptables -t filter -A INPUT -j NFQUEUE --queue-num 0

# Set default policy to DROP
iptables -t filter -P FORWARD DROP

# Set the NFQUEUE rule to send packets to queue 0
iptables -t filter -A FORWARD -j NFQUEUE --queue-num 0

# Set default policy to DROP
iptables -t filter -P OUTPUT DROP

# Set the NFQUEUE rule to send packets to queue 0
iptables -t filter -A OUTPUT -j NFQUEUE --queue-num 0

# Request IP address from router
dhclient eth0

# Show IP address
ip -4 addr show eth0

# Keep the container running to avoid exit
exec python3 /opt/packet_inspector.py
