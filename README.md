# Router Network Docker

Docker setup for testing network applications. It simulates client-server communication through a router, allowing experiments with network-related features in a controlled and self-contained setup.

## Containers
- **client**: Simulates a client device connected to the `LAN` network
- **router**: Simulates a router device connected to `LAN` and `WAN` networks
    - `IPv4` packet forwarding
    - `NAT` from `LAN` to `WAN`
    - `dnsmasq` for `DHCP` on `LAN`
    - `dnsmasq` for `DNS` on `LAN`
    - `iptables` rules log packets with `NFLOG`
    - `ulog2` configured to save packets data
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
3. Inspect client logs
    ```bash
    docker exec client cat /var/log/ulogd_syslogemu.log
    ```

    ```log
    Nov 17 16:23:06 a1d0aa95d943 [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.37 DST=192.168.20.2 LEN=84 TOS=00 PREC=0x00 TTL=64 ID=17013 DF PROTO=ICMP TYPE=8 CODE=0 ID=87 SEQ=1 UID=0 GID=0 MARK=0
    Nov 17 16:23:05 a1d0aa95d943 [INPUT] IN=eth0 OUT= MAC=02:42:ac:15:00:03:02:42:ac:15:00:02:08:00 SRC=192.168.20.2 DST=192.168.10.37 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=20719 PROTO=ICMP TYPE=0 CODE=0 ID=87 SEQ=1 MARK=0
    ```

4. Inspect router logs
    ```bash
    docker exec router cat /var/log/ulogd_syslogemu.log
    ```

    ```log
    Nov 17 16:23:05 e501aa9af8d5 [FORWARD] IN=eth0 OUT=eth1 MAC=02:42:ac:15:00:02:02:42:ac:15:00:03:08:00 SRC=192.168.10.37 DST=192.168.20.2 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=17013 DF PROTO=ICMP TYPE=8 CODE=0 ID=87 SEQ=1 MARK=0
    Nov 17 16:23:05 e501aa9af8d5 [FORWARD] IN=eth1 OUT=eth0 MAC=02:42:ac:14:00:03:02:42:ac:14:00:02:08:00 SRC=192.168.20.2 DST=192.168.10.37 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=20719 PROTO=ICMP TYPE=0 CODE=0 ID=87 SEQ=1 MARK=0
    ```

4. Inspect server logs
    ```bash
    docker exec server cat /var/log/ulogd_syslogemu.log
    ```

    ```log
    Nov 17 16:23:05 55063bbba17a [INPUT] IN=eth0 OUT= MAC=02:42:ac:14:00:02:02:42:ac:14:00:03:08:00 SRC=192.168.20.1 DST=192.168.20.2 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=17013 DF PROTO=ICMP TYPE=8 CODE=0 ID=87 SEQ=1 MARK=0
    Nov 17 16:23:06 55063bbba17a [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.20.2 DST=192.168.20.1 LEN=84 TOS=00 PREC=0x00 TTL=64 ID=20719 PROTO=ICMP TYPE=0 CODE=0 ID=87 SEQ=1 MARK=0
    ```
