import logging
import os

from netfilterqueue import NetfilterQueue
from scapy.all import IP


# Set up the logger once
logger = logging.getLogger()

# Function to configure the logger
def setup_logger():
    # Get the script name (without extension) for the log file
    script_name = os.path.splitext(os.path.basename(__file__))[0]
    log_file = f"/var/log/{script_name}.log"

    # Set logger level
    logger.setLevel(logging.INFO)  # Set to INFO level or change to DEBUG if needed

    # Create formatter
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

# Function to log packet details using Scapy (only summary)
def log_packet(pkt):
    # Log packet details
    raw_packet = pkt.get_payload()

    # Use Scapy to parse the raw packet
    scapy_pkt = IP(raw_packet)  # Assume the packet is IP-based

    # Log packet summary
    logger.info(f"Packet Summary: {scapy_pkt.summary()}")  # Print summary of the packet

    # Accept the packet (so it continues through the network stack)
    pkt.accept()

# Function to handle packets from NFQUEUE
def process_packets():
    nfqueue = NetfilterQueue()

    # Bind the callback function to handle packets
    nfqueue.bind(0, log_packet)

    # Start processing packets (this will block indefinitely)
    try:
        print("Starting packet processing...")
        nfqueue.run()
    except KeyboardInterrupt:
        print("Packet logging stopped.")
        nfqueue.unbind()

# Main function to start logging packets
def main():
    # Set up the logger once
    setup_logger()

    # Start processing packets
    process_packets()

if __name__ == "__main__":
    main()
