# Use a lightweight Alpine Linux base image
FROM alpine:latest

# Install necessary packages:
# - iproute2: for IP address and routing manipulation
# - iputils: for networking utilities like ping
RUN apk update && \
    apk add --no-cache dhclient iproute2 iputils

# Copy the entrypoint script from the host to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh
