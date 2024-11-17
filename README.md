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
    Nov 17 15:17:22 d57b3b914aff [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.31 DST=192.168.20.2 LEN=84 TOS=00 PREC=0x00 TTL=64 ID=6079 DF PROTO=ICMP TYPE=8 CODE=0 ID=82 SEQ=1 UID=0 GID=0 MARK=0
    Nov 17 15:17:21 d57b3b914aff [INPUT] IN=eth0 OUT= MAC=02:42:ac:14:00:02:02:42:ac:14:00:03:08:00 SRC=192.168.20.2 DST=192.168.10.31 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=17501 PROTO=ICMP TYPE=0 CODE=0 ID=82 SEQ=1 MARK=0
    ```

4. Inspect router logs
    ```bash
    docker exec router cat /var/log/ulogd_syslogemu.log
    ```

    ```log
    Nov 17 15:10:30 2b11ee656a3d [INPUT] IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:02:42:ac:14:00:02:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=10 PREC=0x00 TTL=128 ID=0 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0
    Nov 17 15:10:31 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.31 LEN=48 TOS=00 PREC=0x00 TTL=64 ID=10940 DF PROTO=ICMP TYPE=8 CODE=0 ID=41840 SEQ=0 UID=65534 GID=30 MARK=0
    Nov 17 15:10:43 2b11ee656a3d [INPUT] IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:02:42:ac:14:00:03:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=10 PREC=0x00 TTL=128 ID=0 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0
    Nov 17 15:10:44 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.32 LEN=48 TOS=00 PREC=0x00 TTL=64 ID=41942 DF PROTO=ICMP TYPE=8 CODE=0 ID=62348 SEQ=0 UID=65534 GID=30 MARK=0
    Nov 17 15:10:47 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.32 LEN=328 TOS=00 PREC=0xC0 TTL=64 ID=20446 PROTO=UDP SPT=67 DPT=68 LEN=308 UID=0 GID=0 MARK=0
    Nov 17 15:10:46 2b11ee656a3d [INPUT] IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:02:42:ac:14:00:03:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=10 PREC=0x00 TTL=128 ID=0 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0
    Nov 17 15:10:47 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.32 LEN=334 TOS=00 PREC=0xC0 TTL=64 ID=20447 PROTO=UDP SPT=67 DPT=68 LEN=314 UID=0 GID=0 MARK=0
    Nov 17 15:16:45 2b11ee656a3d [INPUT] IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:02:42:ac:14:00:02:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=10 PREC=0x00 TTL=128 ID=0 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0
    Nov 17 15:16:54 2b11ee656a3d [INPUT] IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:02:42:ac:14:00:02:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=10 PREC=0x00 TTL=128 ID=0 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0
    Nov 17 15:16:55 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.31 LEN=48 TOS=00 PREC=0x00 TTL=64 ID=58068 DF PROTO=ICMP TYPE=8 CODE=0 ID=18131 SEQ=0 UID=65534 GID=30 MARK=0
    Nov 17 15:16:58 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.31 LEN=328 TOS=00 PREC=0xC0 TTL=64 ID=47285 PROTO=UDP SPT=67 DPT=68 LEN=308 UID=0 GID=0 MARK=0
    Nov 17 15:16:57 2b11ee656a3d [INPUT] IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:02:42:ac:14:00:02:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=10 PREC=0x00 TTL=128 ID=0 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0
    Nov 17 15:16:58 2b11ee656a3d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.10.1 DST=192.168.10.31 LEN=334 TOS=00 PREC=0xC0 TTL=64 ID=47288 PROTO=UDP SPT=67 DPT=68 LEN=314 UID=0 GID=0 MARK=0
    Nov 17 15:17:21 2b11ee656a3d [FORWARD] IN=eth0 OUT=eth1 MAC=02:42:ac:14:00:03:02:42:ac:14:00:02:08:00 SRC=192.168.10.31 DST=192.168.20.2 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=6079 DF PROTO=ICMP TYPE=8 CODE=0 ID=82 SEQ=1 MARK=0
    ```

4. Inspect server logs
    ```bash
    docker exec server cat /var/log/ulogd_syslogemu.log
    ```

    ```log
    Nov 17 15:17:21 a24aade7c70d [INPUT] IN=eth0 OUT= MAC=02:42:ac:15:00:02:02:42:ac:15:00:03:08:00 SRC=192.168.20.1 DST=192.168.20.2 LEN=84 TOS=00 PREC=0x00 TTL=63 ID=6079 DF PROTO=ICMP TYPE=8 CODE=0 ID=82 SEQ=1 MARK=0
    Nov 17 15:17:22 a24aade7c70d [OUTPUT] IN= OUT=eth0 MAC= SRC=192.168.20.2 DST=192.168.20.1 LEN=84 TOS=00 PREC=0x00 TTL=64 ID=17501 PROTO=ICMP TYPE=0 CODE=0 ID=82 SEQ=1 MARK=0
    ```
