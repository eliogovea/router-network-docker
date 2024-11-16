# Use the official Debian base image
FROM debian:bullseye

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages:
# - iproute2: For network configuration tools (e.g., ip command)
# - iputils-ping: For network testing (ping)
# - iptables: For managing firewall rules and routing
# - python3: For running the packet logger script
# - python3-pip: Python package installer
RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    iptables \
    libnfnetlink-dev \
    libnetfilter-queue-dev \
    python3 \
    python3-pip \
    && apt-get clean

# Install Python dependencies for NetfilterQueue and Scapy (used for packet handling)
RUN pip3 install NetfilterQueue scapy

# Copy the Python script for logging packets into the container
COPY packet_logger.py /packet_logger.py

# Copy the entrypoint script from the host to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the working directory to the root of the container
WORKDIR /

# Set the default entrypoint script to configure the network and iptables
ENTRYPOINT ["/entrypoint.sh"]
