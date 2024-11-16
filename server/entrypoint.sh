#!/bin/sh

set -e
set -u
set -x

# Bring up the eth0 network interface if it's not already up
ip link set eth0 up

# Remove any existing IP addresses from eth0 to avoid conflicts
ip addr flush dev eth0

# Request IP address from router
dhclient eth0

ip -4 addr show eth0

# Keep the container running to avoid exit
sleep infinity
