#!/bin/bash

set -e
set -u
set -x

# Bring up the eth0 network interface if it's not already up
ip link set eth0 up

# Remove any existing IP addresses from eth0 to avoid conflicts
ip addr flush dev eth0

# Set up IPv4 address for the server in the WAN network
ip addr add 192.168.20.2/24 dev eth0

# Clear existing iptables
iptables -F

# Set default policy to DROP
iptables -P INPUT DROP

# Set the NFQUEUE rule to send packets to queue 0
iptables -A INPUT -j NFQUEUE --queue-num 0

# Keep the container running to avoid exit
exec python3 /opt/packet_inspector.py
