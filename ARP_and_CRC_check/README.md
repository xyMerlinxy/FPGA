# ARP_and_CRC_check

##  Target Hardware & Environment
- Development Board: Terasic DE2-115 (Cyclone IV E EP4CE115F29C7)
- PHY Interface: Marvell Alaska 88E1111 (Triple-Speed Ethernet)
- Interface Standard: Altera Avalon Streaming (Avalon-ST)
- Synthesis Tool: Altera Quartus

## Implementation
The system is composed of 13 specialized hardware modules, integrated within the top-level ARP_and_CRC_check entity. The architecture follows a modular approach to handle Ethernet traffic, protocol processing, and data integrity.

### Core Modules
- ARP_and_CRC_check (Top-Level Module): The main structural entity that interconnects all sub-modules. It manages the data flow between the PHY interfaces, FIFOs, and protocol services.

- phy_receiver: Interfaces with the Marvell Alaska 88E1111 (RX) and converts incoming signals into the Avalon Streaming interface format.

- phy_transmitter: Converts data from the Avalon Streaming interface back to the TX signals required by the Marvell Alaska 88E1111 PHY.

- arp_service: Handles ARP (Address Resolution Protocol) queries. It inspects the target IP field; if it matches the module's hardcoded parameter, it generates a standard Ethernet reply frame.

- udp_service: Processes incoming UDP packets to drive 7-segment displays, utilizing two instances of the bin27s module.

### Data Integrity & Transformation
- crc_checker: Validates the CRC field of incoming Ethernet frames. It uses a stream_delay_4 instance to offset the byte stream by 4 positions, allowing it to strip the CRC field. If a mismatch is detected, it triggers the aso_error signal to drop the frame.

- crc_inserter: Calculates the CRC32 checksum for outgoing frames and appends it to the end of the data stream.

- crc: A computational core that calculates the next state of the CRC register according to the Ethernet CRC32 standard.

- stream_delay_4: A utility module providing a 4-cycle delay to the data stream, specifically used for frame field manipulation.

- error_maker: A diagnostic tool that injects errors into specific bytes (defined by error_addr and error_value) when error_enable is active.

### Buffer & UI Modules
- dc_fifo (Dual-Clock FIFO): Manages Clock Domain Crossing (CDC) between the tx_clk, rx_clk, and the system clk.

- sc_fifo (Single-Clock FIFO): Operates in "Store and Forward" mode. It only begins transmission after a full frame is received and automatically drops frames flagged with errors.
### UI Modules
- bin27s: A hardware decoder that converts 4-bit binary values into 7-bit signals for driving 7-segment displays.

## Synthesis & Implementation Results
The project was successfully synthesized for the Cyclone IV E (EP4CE115F29C7) using Altera Quartus. The implementation met all timing requirements with zero errors and zero warnings.

### Testing
Automated testing and verification were performed with VUnit.

### Resource Utilization
- Logic (ALM/LE): 1001
- Registers: 550
- Memory Bits: 20992
### Timing Analysis
The design achieves the following maximum frequencies, satisfying all operational requirements for Ethernet transmission:
- tx_clk: 66 MHz (needed: 10 MHz)
- clk (System): 72 MHz (needed: 20 MHz)
- rx_clk: 151 MHz (needed: 10 MHz)