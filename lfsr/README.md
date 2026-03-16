# LFSR — Linear Feedback Shift Register

Galois LFSR implementation in VHDL-93.

## Description

Galois LFSR (Linear Feedback Shift Register) is a shift register where XOR gates are placed between stages based on the feedback polynomial. Compared to Fibonacci LFSR, Galois topology offers higher maximum operating frequency due to shorter critical path.

The module generates a pseudo-random sequence of length `2^g_size - 1` (maximal-length sequence) for primitive polynomials.

## Generics

| Generic  | Type                            | Default             | Description                      |
| -------- | ------------------------------- | ------------------- | -------------------------------- |
| `g_size` | `integer`                       | `8`                 | Register width in bits (2 to 64) |
| `g_seed` | `std_logic_vector(63 downto 0)` | x"FFFFFFFFFFFFFFFF" | Initial state of the register    |

## Ports

| Port      | Direction | Type                                  | Description                   |
| --------- | --------- | ------------------------------------- | ----------------------------- |
| `i_clk`   | `in`      | `std_logic`                           | Clock                         |
| `i_rst_n` | `in`      | `std_logic`                           | Active-low asynchronous reset |
| `o_data`  | `out`     | `std_logic`                           | Serial output (LSB of state)  |
| `o_state` | `out`     | `std_logic_vector(g_size-1 downto 0)` | Parallel state output         |

## Usage Example
```vhdl
lfsr_inst : entity work.lfsr
    generic map (
        g_size => 8,
        g_seed => x"0000000000000001"
    )
    port map (
        i_clk   => clk,
        i_rst_n => rst_n,
        o_data  => data,
        o_state => state
    );
```

## Resource Utilization

Synthesized for Cyclone V (5CEBA4F23C7) with Quartus Prime.

| g_size | ALMs | Registers | Fmax |
| ------ | ---- | --------- | ---- |
| 8      | 9    | 8         | 225  |
| 16     | 17   | 16        | 223  |
| 32     | 33   | 45        | 220  |
| 64     | 65   | 79        | 209  |

## Running Tests

Tests use [VUnit](https://vunit.github.io) framework with GHDL simulator.

### Requirements

- Python 3.x
- GHDL
- VUnit (`pip install vunit-hdl`)
- pylfsr (`pip install pylfsr`)

### Generate more test cases
```bash
python scripts/generate_tests.py
```

### Run all tests
```bash
set VUNIT_SIMULATOR=ghdl
python run.py
```

### Run specific test
```bash
python run.py lib_lfsr_tb.lfsr_tb.size_8_case_1.test_basic
```

### Run with GUI
```bash
python run.py -g lib_lfsr_tb.lfsr_tb.size_8_case_1.test_basic
```

### Run in parallel
```bash
python run.py -p 4
```

## Quartus Project

To create a Quartus project, navigate to `work/quartus` and run:
```bash
cd work/quartus
<quartus_sh path> -t ../../scripts/quartus_create_project.tcl
```

This will generate a Quartus project for Cyclone V (5CEBA4F23C7) with all RTL and SDC files added automatically.

## Project Structure
```
.
├── run.py
├── rtl/
│   └── lfsr.vhd
├── sdc/
│   └── lfsr.sdc
├── scripts/
│   └── generate_tests.py
│   └── quartus_create_project.tcl
└── tests/
    ├── pkg_utility.vhd
    ├── lfsr_tb.vhd
    ├── lfsr_tb.json
```
