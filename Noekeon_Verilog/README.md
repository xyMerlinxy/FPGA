# Noekeon_Verilog
This repository contains a hardware implementation of the Noekeon block cipher, developed in Verilog. The module provides high-performance encryption and decryption capabilities, supporting both Direct and Indirect operating modes.

## Main Module (Top-level)
- Noekeon: The primary entity that binds all sub-modules of the project. It integrates the data path with the control unit to support encryption and decryption in both direct and indirect key modes.
## Control Unit
- Noekeon_Control: A Finite State Machine (FSM) based controller. It manages data and key loading, tracks round numbers (0–16 for encryption, 16–0 for decryption), and generates control signals for all other components.

## Memory and Registers
- Noekeon_DataReg: A memory module that stores the current internal data state. It supports data loading from three sources: the external data interface, the key interface, and the feedback from the round function.
- Noekeon_KeyReg: A register-based memory module dedicated to storing the encryption key. It allows key loading from an external source or from the result of a key encryption cycle (indirect mode).
- Noekeon_DataOutReg: An output buffer that stores the final data state after the last round operation is completed.
## Logic Transformations (Round Function)
- Noekeon_RoundSh: Implements the full Noekeon round function. It is a composition of the Theta, Gamma, Pi1, and Pi2 operations.
- Noekeon_LastRoundSh: Executes the simplified final round function as defined in the algorithm. It utilizes the Theta operation and handles XOR operations with round constants.
- Noekeon_Theta: A logic module performing the Theta linear transformation. It executes XOR operations between data bytes and the key.
- Noekeon_KeyTheta: A specialized logic module that applies the Theta transformation to the key specifically during decryption cycles to ensure the same key register can be used for both modes.
## Auxiliary Components
- Noekeon_Gamma: The non-linear layer that processes thirty-two 4-bit words in parallel. It leverages thirty-two individual S-box modules.
- Noekeon_GammaSbox: Implements the specific S-box substitution used within the Gamma operation through conditional assignments.
- Noekeon_Pi1 / Noekeon_Pi2: Logic modules that perform bit-level permutations (rotations). These are implemented via bit-string concatenation.
- Noekeon_ConstantBox: A combinational logic module responsible for generating the appropriate Round Constant based on the current round number.