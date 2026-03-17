# Counter Comparison — Binary vs LFSR

Comparison of two counter implementations in VHDL-93: a standard binary counter (addition-based) and an LFSR-based counter. Both modules share an identical interface and are benchmarked across sizes 8, 16, 32, and 64 bits.

## Description

This project implements and compares two approaches to building a trigger-generating counter:

- **Binary counter** — classic up-counter using addition (`+1`). Carries propagate through all bits in the worst case, which limits maximum frequency for wide registers.
- **LFSR counter** — counter based on a Linear Feedback Shift Register. The feedback is computed via XOR of selected taps (primitive polynomial), producing a maximal-length sequence of `2^g_size - 1` states before triggering. Because there are no carry chains, the critical path is shorter and Fmax scales better with register width.

Both counters assert `o_trigger` once per full sequence cycle.

## Generics

| Generic   | Type                            | Default             | Description                         |
| --------- | ------------------------------- | ------------------- | ----------------------------------- |
| `g_size`  | `integer`                       | `8`                 | Register width in bits (2 to 64)    |
| `g_state` | `std_logic_vector(63 downto 0)` | x"0000000000000001" | State which `o_trigger` is asserted |

## Ports

| Port        | Direction | Type        | Description                        |
| ----------- | --------- | ----------- | ---------------------------------- |
| `i_clk`     | `in`      | `std_logic` | Clock                              |
| `i_rst_n`   | `in`      | `std_logic` | Active-low asynchronous reset      |
| `o_trigger` | `out`     | `std_logic` | Pulses high when state git g_state |

## Usage Example

```vhdl
-- Binary counter
binary_cnt : entity work.binary_counter
    generic map (
        g_size => 8,
        g_state => x"0000000000000001"
    )
    port map (
        i_clk     => clk,
        i_rst_n   => rst_n,
        o_trigger => trigger_bin
    );

-- LFSR counter
lfsr_cnt : entity work.lfsr_counter
    generic map (
        g_size  => 8,
        g_state => x"0000000000000001"
    )
    port map (
        i_clk     => clk,
        i_rst_n   => rst_n,
        o_trigger => trigger_lfsr
    );
```

## Resource Utilization

Synthesized for Cyclone V (5CEBA4F23C7) with Quartus Prime(i_rst_n and o_trigger assign to Virtual Pin).

### Binary Counter

| g_size | ALMs | Registers | Fmax [MHz] |
| ------ | ---- | --------- | ---------- |
| 8      | 8    | 10        | 490.68     |
| 16     | 14   | 18        | 406.34     |
| 32     | 25   | 34        | 349.90     |
| 64     | 48   | 66        | 307.31     |

### LFSR Counter

| g_size | ALMs | Registers | Fmax [MHz] |
| ------ | ---- | --------- | ---------- |
| 8      | 7    | 10        | 607.53     |
| 16     | 13   | 18        | 464.9      |
| 32     | 24   | 34        | 413.91     |
| 64     | 46   | 66        | 347.34     |

## Running Tests

Tests use [VUnit](https://vunit.github.io) framework with GHDL simulator.

### Requirements

- Python 3.x
- GHDL
- VUnit (`pip install vunit-hdl`)

### Run all tests

```bash
set VUNIT_SIMULATOR=ghdl
python run.py
```

### Run specific test

```bash
python run.py lib_counter_tb.counter_tb.size_8.test_basic
```

### Run with GUI

```bash
python run.py -g lib_counter_tb.counter_tb.size_8.test_basic
```

### Run in parallel

```bash
python run.py -p 4
```

## Scripts
`scripts/generate_lfsr_counter_inst.py`
A Python script that generates a VHDL instantiation of the `lfsr_counter` module for a given number of steps.
Usage:
```
python generate_lfsr_counter_inst.py <number>
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
│   ├── binary_counter.vhd
│   └── lfsr_counter.vhd
├── sdc/
│   ├── binary_counter.sdc
│   └── lfsr_counter.sdc
├── scripts/
│   └── quartus_create_project.tcl
└── tests/
    ├── test_utility_pkg.vhd
    ├── binary_counter_tb.vhd
    └── binary_counter_tb.json
    ├── lfsr_counter_tb.vhd
    └── lfsr_counter_tb.json
```
