from vunit import VUnit
import sys
import json


CONFIG_FILES = {"lfsr_tb": "tests/lfsr_tb.json"}


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

lib_lfsr = vu.add_library("lib_lfsr")
lib_lfsr.add_source_files("rtl/*.vhd")
lib_lfsr_tb = vu.add_library("lib_lfsr_tb")
lib_lfsr_tb.add_source_files("tests/*.vhd")

for tb_name, config_file in CONFIG_FILES.items():
    tb = lib_lfsr_tb.test_bench(tb_name)
    add_configs(tb, config_file)


if "-g" in sys.argv or "--gui" in sys.argv:
    vu.set_sim_option("modelsim.vsim_flags", ["-voptargs=+acc"])  # pyright: ignore[reportArgumentType]

vu.main()
