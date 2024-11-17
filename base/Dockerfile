FROM debian:bullseye

# Install necessary packages
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y \
        dnsmasq \
        iproute2 \
        iptables \
        iputils-ping \
        isc-dhcp-client \
        libnetfilter-queue-dev \
        libnfnetlink-dev \
        python3 \
        python3-pip \
        ulogd2 \
    && pip3 install \
        NetfilterQueue \
        scapy \
    && apt-get clean

# Copy files from the host to the container
COPY files/opt/packet_filter.py /opt/packet_filter.py
