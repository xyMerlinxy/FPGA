import os
from pathlib import Path
import pytest
from cocotb_test.simulator import run

import pathlib


CURRENT_PATH = Path(__file__).parent.resolve()
PROJECT_PATH = (CURRENT_PATH / "..").resolve()

RTL_DIR = PROJECT_PATH / "rtl"
TEST_DIR = PROJECT_PATH / "sim_cocotb" / "tb"
OUTPUT_DIR = (PROJECT_PATH / "work" / "cocotb").resolve()

tests_to_run = [f.stem for f in TEST_DIR.glob("test_*.py")]
rtl_files = [str(f) for f in RTL_DIR.iterdir() if f.suffix in [".v", ".sv", ".vhd"]]

TOP_LEVEL_MAP = {
    "test_fp_add": "fp_add",
    "test_fp_as": "fp_as",
}


@pytest.mark.parametrize("test_module", tests_to_run)
def test_everything(test_module):
    if test_module not in TOP_LEVEL_MAP:
        pytest.skip(f"No top-level defined for {test_module}")

    print(rtl_files)
    print(test_module)
    gui = os.getenv("GUI") == "1"
    # gui = True

    run(
        verilog_sources=[str(f) for f in rtl_files],
        toplevel=str(TOP_LEVEL_MAP[test_module]),
        module=str(test_module),
        simulator="questa",
        sim_build=str(OUTPUT_DIR),
        python_search=[str(TEST_DIR)],
        gui=bool(gui),
        sim_args=["-voptargs=+acc"] if gui else [],
    )
