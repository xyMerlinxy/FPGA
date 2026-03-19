# FPGA Design Portfolio
This repository is a collection of my digital design projects implemented in HDL (Verilog/VHDL) and targeted for FPGA structures. It showcases various aspects of hardware design, from cryptographic accelerators to network protocol processing and data integrity verification.

## Projects in this Repository
### HMAC-SHA3
A high-performance hardware implementation of the HMAC-SHA-3 (Keyed-Hash Message Authentication Code) based on the Keccak-f[1600] permutation.

Key Features:
- Full support for SHA3-224 through SHA3-512, iterative architecture, and compliance with FIPS 202 and FIPS 198-1 standards.

Applications: Data authentication and integrity verification in secure communication systems.

Tools & Technologies:
- Languages: Verilog
- Simulation: QuestaSim
- Synthesis: Intel Quartus Prime

Read more: [HMAC-SHA3](HMAC_SHA3/README.md)

### Noekeon
Hardware implementation of the Noekeon block cipher, a symmetric key algorithm known for its high efficiency in both hardware and software.

Key Features:
- Compact design optimized for FPGA resources, supporting both encryption and decryption modes.

Applications: Lightweight cryptography for embedded systems and secure data storage.

Tools & Technologies:
- Languages: Verilog
- Simulation: QuestaSim
- Synthesis: Intel Quartus Prime
  
Read more: [Noekeon](Noekeon_Verilog/README.md)

### ARP and CRC Check
A network-oriented module designed for Ethernet frame processing and error detection.

Key Features:
- ARP (Address Resolution Protocol): Logic for handling/filtering ARP packets in hardware.
- CRC Check: Real-time Cyclic Redundancy Check (CRC32) calculation and verification for incoming data streams.

Applications: Network interfaces, hardware firewalls, and industrial Ethernet controllers.

Tools & Technologies:
- Languages: Verilog, VHDL
- Simulation: VUnit, QuestaSim
- Synthesis: Intel Quartus Prime
  
Read more: [Arp and CRC](ARP_and_CRC_check/README.md)

### LFSR — Linear Feedback Shift Register
A configurable pseudo-random number generator implemented in VHDL-93 using Galois topology.

Key Features:
- Configurable width: Supports register widths from 2 to 64 bits with customizable seed and feedback polynomial taps.
- Maximal-length sequence: Generates sequences of length `2^n - 1` for primitive polynomials.
- Automated testing: Test cases auto-generated in Python using `pylfsr`, covering multiple widths and sequence lengths.

Applications: noise generation and stream encryption.

Tools & Technologies:
- Languages: VHDL (VHDL-93)
- Simulation: VUnit, GHDL, QuestaSim
- Synthesis: Intel Quartus Prime (Cyclone V, DE0-CV)
  
Read more: [LFSR](lfsr/README.md)

### Counter Comparison — Binary vs LFSR
A side-by-side resource utilization and timing comparison of two counter architectures implemented in VHDL-93.

Key Features:
- Two implementations: Standard binary counter (ripple carry adder) vs. LFSR-based counter (XOR feedback).
- Configurable width: Both modules support widths of 8, 16, 32, and 64 bits via a shared generic interface.
- Unified interface: Identical port map across both modules — drop-in replaceable for benchmarking.
- Synthesis benchmarks: ALM usage, register count, and Fmax compared across all sizes on the same target device.

Applications: understanding area/timing trade-offs when replacing adder-based counters with LFSR counters in FPGA designs.

Tools & Technologies:
- Languages: VHDL (VHDL-93)
- Simulation: VUnit, GHDL
- Synthesis: Intel Quartus Prime (Cyclone V, DE0-CV)
  
Read more: [Counter](counter/README.md)