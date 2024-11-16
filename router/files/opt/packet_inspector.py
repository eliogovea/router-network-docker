import logging
import os

from netfilterqueue import NetfilterQueue
from scapy.all import IP

logger = logging.getLogger()

def setup_logger():
    script_name = os.path.splitext(os.path.basename(__file__))[0]
    log_file = f"/var/log/{script_name}.log"

    logger.setLevel(logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(message)s')

    # Create file handler that logs to the file
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)

    # Create stream handler that logs to stdout
    stream_handler = logging.StreamHandler()
    stream_handler.setLevel(logging.INFO)
    stream_handler.setFormatter(formatter)

    # Add both the file handler and stream handler to the logger
    logger.addHandler(file_handler)
    logger.addHandler(stream_handler)

def inspect_packet(pkt):
    packet_id = pkt.id
    packet_data = pkt.get_payload()
    packet_data_scapy = IP(packet_data)
    
    # TODO: inspect packet

    logger.info(f"Packet  {packet_id}: {packet_data_scapy.summary()}")    
    logger.info(f"Verdict {packet_id}: accept")

    # Accept the packet (so it continues through the network stack)
    pkt.accept()

# Function to handle packets from NFQUEUE
def process_packets():
    nfqueue = NetfilterQueue()

    # Bind the callback function to handle packets
    nfqueue.bind(0, inspect_packet)

    # Start processing packets (this will block indefinitely)
    try:
        print("Starting packet processing...")
        nfqueue.run()
    except KeyboardInterrupt:
        print("Packet logging stopped.")
        nfqueue.unbind()

def main():
    # Set up the logger
    setup_logger()

    # Start processing packets
    process_packets()

if __name__ == "__main__":
    main()
