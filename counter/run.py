import os

from vunit import VUnit
import sys
import json


CONFIG_FILES = {
    "binary_counter_tb": "tests/binary_counter_tb.json",
    "lfsr_counter_tb": "tests/lfsr_counter_tb.json",
}


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

# ip

# rtl
lib_counter = vu.add_library("lib_counter")
lib_counter.add_source_files("rtl/*.vhd")
# test bench
lib_counter_tb = vu.add_library("lib_counter_tb")
lib_counter_tb.add_source_files("tests/*.vhd")

for tb_name, config_file in CONFIG_FILES.items():
    tb = lib_counter_tb.test_bench(tb_name)
    add_configs(tb, config_file)

    if "-g" in sys.argv or "--gui" in sys.argv:
        # vu.set_sim_option("modelsim.vsim_flags", ["-voptargs=+acc"])  # pyright: ignore[reportArgumentType]

        wave_file = f"scripts/wave/{tb_name}.do"
        if os.path.exists(wave_file):
            vu.set_sim_option("modelsim.init_files.after_load", [wave_file])  # pyright: ignore[reportArgumentType]


vu.main()
