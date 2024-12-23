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
iptables -t filter -F

# Set default policy to ACCEPT
iptables -t filter -P INPUT ACCEPT

# Log packets
iptables -t filter -A INPUT -j NFLOG --nflog-group 1 --nflog-prefix "[INPUT]"

# Set default policy to ACCEPT
iptables -t filter -P FORWARD ACCEPT

# Log packets
iptables -t filter -A FORWARD -j NFLOG --nflog-group 1 --nflog-prefix "[FORWARD]"

# Set default policy to ACCEPT
iptables -t filter -P OUTPUT ACCEPT

# Log packets
iptables -t filter -A OUTPUT -j NFLOG --nflog-group 1 --nflog-prefix "[OUTPUT]"

# Keep the container running to avoid exit
exec ulogd -c /etc/ulogd.conf -v
