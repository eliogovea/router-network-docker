# Use a lightweight Alpine Linux base image
FROM alpine:latest

# Install necessary packages:
# - iproute2: for IP address and routing configuration
# - iptables: for setting up packet filtering and NAT rules
# - ip6tables: for handling IPv6 traffic rules
# - iputils: for basic networking tools like ping
RUN apk update && \
    apk add --no-cache iproute2 iptables ip6tables iputils

# Copy the entrypoint script from the host to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh
