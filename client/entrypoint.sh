#!/bin/sh

set -e
set -u
set -x

# Bring up the eth0 network interface if it's not already up
ip link set eth0 up

# Remove any existing IP addresses from eth0 to avoid conflicts
ip addr flush dev eth0

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

# Request IP address from router
dhclient eth0

# Show IP address
ip -4 addr show eth0

# Keep the container running to avoid exit
exec ulogd -c /etc/ulogd.conf -v
# exec python3 /opt/packet_inspector.py
