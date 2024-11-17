# Network Docker Setup

Docker setup for testing network applications. It simulates client-server communication through a router, allowing experiments with network-related features in a controlled and self-contained setup.

## Containers
- **client**: Simulates a client device connected to the `LAN` network
- **router**: Simulates a router device connected to `LAN` and `WAN` networks
    - `IPv4` packet forwarding
    - `dnsmasq` for `DHCP` on `LAN` network
    - `dnsmasq` for `DNS` on `LAN` network
    - `NAT` from `LAN` to `WAN`
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

## Examples

### Ping from client to server


1. Open one terminal and run
    ```bash
    docker compose up --build
    ```
2. Open one terminal and run
    ```bash
    docker exec client ping -c 1 192.168.20.2
    ```
3. Inspect the logs to understand the packets flow
    ```log
    client  | 2024-11-17 11:20:12,125 - [id=1] summary: IP / ICMP 192.168.10.31 > 192.168.20.2 echo-request 0 / Raw
    client  | 2024-11-17 11:20:12,126 - [id=1] src IP:  192.168.10.31
    client  | 2024-11-17 11:20:12,126 - [id=1] dst IP:  192.168.20.2
    client  | 2024-11-17 11:20:12,126 - [id=1] verdict: accept
    router  | 2024-11-17 11:20:12,127 - [id=3] summary: IP / ICMP 192.168.10.31 > 192.168.20.2 echo-request 0 / Raw
    router  | 2024-11-17 11:20:12,127 - [id=3] src IP:  192.168.10.31
    router  | 2024-11-17 11:20:12,127 - [id=3] dst IP:  192.168.20.2
    router  | 2024-11-17 11:20:12,127 - [id=3] verdict: accept
    server  | 2024-11-17 11:20:12,129 - [id=1] summary: IP / ICMP 192.168.20.1 > 192.168.20.2 echo-request 0 / Raw
    server  | 2024-11-17 11:20:12,129 - [id=1] src IP:  192.168.20.1
    server  | 2024-11-17 11:20:12,129 - [id=1] dst IP:  192.168.20.2
    server  | 2024-11-17 11:20:12,129 - [id=1] verdict: accept
    server  | 2024-11-17 11:20:12,130 - [id=2] summary: IP / ICMP 192.168.20.2 > 192.168.20.1 echo-reply 0 / Raw
    server  | 2024-11-17 11:20:12,130 - [id=2] src IP:  192.168.20.2
    server  | 2024-11-17 11:20:12,130 - [id=2] dst IP:  192.168.20.1
    server  | 2024-11-17 11:20:12,131 - [id=2] verdict: accept
    router  | 2024-11-17 11:20:12,132 - [id=4] summary: IP / ICMP 192.168.20.2 > 192.168.10.31 echo-reply 0 / Raw
    router  | 2024-11-17 11:20:12,132 - [id=4] src IP:  192.168.20.2
    router  | 2024-11-17 11:20:12,132 - [id=4] dst IP:  192.168.10.31
    router  | 2024-11-17 11:20:12,132 - [id=4] verdict: accept
    client  | 2024-11-17 11:20:12,133 - [id=2] summary: IP / ICMP 192.168.20.2 > 192.168.10.31 echo-reply 0 / Raw
    client  | 2024-11-17 11:20:12,133 - [id=2] src IP:  192.168.20.2
    client  | 2024-11-17 11:20:12,133 - [id=2] dst IP:  192.168.10.31
    client  | 2024-11-17 11:20:12,133 - [id=2] verdict: accept
    ```
