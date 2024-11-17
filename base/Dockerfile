# Use the official Debian base image
FROM debian:bullseye

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    iptables \
    dnsmasq \
    libnfnetlink-dev \
    libnetfilter-queue-dev \
    python3 \
    python3-pip \
    && apt-get clean

RUN pip3 install NetfilterQueue scapy

# Copy files from the host to the container
COPY files/opt/packet_inspector.py /opt/packet_inspector.py
