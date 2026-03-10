# HMAC-SHA-3
Hardware Implementation (FPGA)This repository contains the hardware implementation of the HMAC-SHA-3 (Keyed-Hash Message Authentication Code) algorithm, based on the Keccak-f[1600] permutation.

## Project Overview
The project provides a complete, modular implementation of the SHA-3 hash family and the HMAC authentication mechanism in Verilog HDL. It is optimized for FPGA structures, focusing on a balance between resource utilization and processing speed.
Supported Variants
- SHA-3: SHA3-224, SHA3-256, SHA3-384, SHA3-512
- HMAC: Full support for the HMAC construction using the above SHA-3 functions
 
## Key Features

- Modular Keccak Core: High-performance implementation of the Keccak-f[1600] permutation including $\theta$, $\rho$, $\pi$, $\chi$, and $\iota$ transformations.
- Sponge Construction: Efficient implementation of the absorbing and squeezing phases.
- HMAC Engine: Hardware-accelerated HMAC logic that handles inner and outer padding (ipad/opad) and key management.
- Simulation-Ready: Includes a comprehensive testbench environment compatible with Questa/ModelSim.
- Hardware-Ready: Includes a comprehensive testbench to run on FPGA device

## Repository Structure
- /src - Verilog source files (Modules: SHA3Rnd, SHA3Iota, SHA3Theta, HMACSHA3, etc.)
- /tests - Hardware test vectors and verification modules.
- /scripts - Scripts for simulator to add waves to wave window