# Network Docker Setup

Docker setup for testing network applications. It simulates client-server communication through a router, allowing experiments with network-related features in a controlled and self-contained setup.

## Containers
- **client**: Simulates a client device connected to the `LAN` network
- **router**: Simulates a router device connected to LAN and WAN networks
    - `IPv4` packet forwarding
    - `dnsmasq` for `DHCP` on `LAN` network
    - `dnsmasq` for `DNS` on `LAN` network
    - `iptables` rules to route traffic between `LAN` and `WAN` networks
    - `iptables` rules to intercept packets via `NFQUEUE`
    - user space application to monitor and inspect packets
- **server**: Simulates a server device connected to the `WAN` network

## Networks
- **lan**: Isolated internal network for `client`-`router` communication
- **wan**: Isolated internal network for `router`-`server` communication

## Build and Run

```bash
docker-compose up --build
```
