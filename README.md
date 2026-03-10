# FPGA Design Portfolio
This repository is a collection of my digital design projects implemented in HDL (Verilog/VHDL) and targeted for FPGA structures. It showcases various aspects of hardware design, from cryptographic accelerators to network protocol processing and data integrity verification.

## Projects in this Repository
### HMAC-SHA3
A high-performance hardware implementation of the HMAC-SHA-3 (Keyed-Hash Message Authentication Code) based on the Keccak-f[1600] permutation.

Key Features: Full support for SHA3-224 through SHA3-512, iterative architecture, and compliance with FIPS 202 and FIPS 198-1 standards.

Applications: Data authentication and integrity verification in secure communication systems.

Tools & Technologies:
Languages: Verilog
Simulation: QuestaSim
Synthesis: Intel Quartus Prime

### Noekeon
Hardware implementation of the Noekeon block cipher, a symmetric key algorithm known for its high efficiency in both hardware and software.

Key Features: Compact design optimized for FPGA resources, supporting both encryption and decryption modes.

Applications: Lightweight cryptography for embedded systems and secure data storage.


Tools & Technologies:
Languages: Verilog
Simulation: QuestaSim
Synthesis: Intel Quartus Prime

### ARP and CRC Check
A network-oriented module designed for Ethernet frame processing and error detection.

Key Features:

ARP (Address Resolution Protocol): Logic for handling/filtering ARP packets in hardware.

CRC Check: Real-time Cyclic Redundancy Check (CRC32) calculation and verification for incoming data streams.

Applications: Network interfaces, hardware firewalls, and industrial Ethernet controllers.

Tools & Technologies
Languages: Verilog, VHDL
Simulation: VUnit, QuestaSim
Synthesis: Intel Quartus Prime
