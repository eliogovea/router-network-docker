#!/bin/sh

set -x

# Enable IPv4 packet forwarding to allow routing
echo 1 > /proc/sys/net/ipv4/ip_forward

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

# Clear existing iptables and ip6tables rules to start fresh
iptables -F

# Set default policy to DROP all forwarded packets (security)
iptables -P FORWARD DROP

# Set the NFQUEUE rule to send packets to queue 0
iptables -A FORWARD -j NFQUEUE --queue-num 0

# Allow internal traffic within the same network
iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT  # LAN side traffic (IPv4)
iptables -A FORWARD -i eth1 -o eth1 -j ACCEPT  # WAN side traffic (IPv4)

# Allow routing between LAN and WAN
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT  # LAN to WAN routing (IPv4)
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT  # WAN to LAN routing (IPv4)

# Keep the container running to avoid exit
exec python3 /packet_logger.py
