#!/bin/sh

set -e
set -u
set -x

# Bring up the eth0 network interface if it's not already up
ip link set eth0 up

# Remove any existing IP addresses from eth0 to avoid conflicts
ip addr flush dev eth0

# Set up IPv4 and IPv6 addresses for the server in the WAN network
# IPv4 address configuration
ip addr add 192.168.20.2/24 dev eth0

# Remove any default route that might already exist (prevents conflicts)
ip route del default || true
# Add a default IPv4 route via the router's IP in the WAN network
ip route add default via 192.168.20.1

# Keep the container running to avoid exit
sleep infinity
