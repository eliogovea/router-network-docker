# Use a lightweight Alpine Linux base image
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache iproute2 iputils

# Copy the entrypoint script from the host to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the working directory to the root of the container
WORKDIR /

# Set the default entrypoint script to configure the network and iptables
ENTRYPOINT ["/entrypoint.sh"]