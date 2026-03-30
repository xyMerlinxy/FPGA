import sys
from vunit import VUnit
from pathlib import Path
import json
import os


CONFIG_FILES = {}


def add_configs(tb, config_file):
    with open(config_file) as f:
        configs = json.load(f)

    for config in configs:
        generics = {k: v for k, v in config.items() if k not in ("name", "tests")}
        tests = config.get("tests", None)

        if tests:
            for test_name in tests:
                tb.test(test_name).add_config(name=config["name"], generics=generics)
        else:
            tb.add_config(name=config["name"], generics=generics)


argv = ["--output-path", "work/vunit"] + sys.argv[1:]

vu = VUnit.from_argv(argv=argv, compile_builtins=False)
vu.add_vhdl_builtins()
vu.add_verification_components()

CURRENT_PATH = Path(__file__).parent.resolve()
PROJECT_PATH = CURRENT_PATH / ".."

# rtl
ecdsa = vu.add_library("ecdsa")
ecdsa.add_source_files(PROJECT_PATH / "rtl" / "*.v")

# test bench
tb_ecdsa = vu.add_library("tb_ecdsa")
tb_ecdsa.add_source_files(PROJECT_PATH / "sim_vunit" / "*.vhd")


for tb_name, config_file in CONFIG_FILES.items():
    tb = tb_ecdsa.test_bench(tb_name)
    add_configs(tb, config_file)

if "-g" in sys.argv or "--gui" in sys.argv:
    vu.set_sim_option("modelsim.vsim_flags", ["-voptargs=+acc"])  # pyright: ignore[reportArgumentType]

    for tb in tb_ecdsa.get_test_benches():
        wave_file = f"scripts/wave/no_dsp/{tb.name}.do"
        print(wave_file)
        if os.path.exists(wave_file):
            tb.set_sim_option("modelsim.init_files.after_load", [wave_file])  # pyright: ignore[reportArgumentType]


vu.main()
