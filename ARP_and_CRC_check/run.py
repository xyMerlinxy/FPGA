import sys
from vunit import VUnitCLI, VUnit
from vunit.ui.testbench import TestBench
from pathlib import Path


def addConfiguration(testBench: TestBench, genericNameList: list[str], genericValueList: list[list[float]]):
  if(len(genericNameList) != len(genericValueList)):
    raise Exception("Lists genericNameList[",len(genericNameList),"] and genericValueList[",len(genericValueList),"] must have same length")

  # generate configDictionaries
  configDictionaries: list[dict[str, float]] = []
  listIndex = [0]*len(genericNameList)
  do = True
  while do:
    d = {}
    for i, data in enumerate(zip(genericNameList,genericValueList)):
      name, values = data
      d[name] = values[listIndex[i]]
    configDictionaries.append(d)
    # go to next index
    for i in range(len(listIndex)):
      if(listIndex[i]==len(genericValueList[i])-1):
        listIndex[i] = 0
        if(i==len(genericValueList)-1):
          do = False
          break
      else:
        listIndex[i] += 1
        break

  lenMaxConfigNumber = len(str(len(configDictionaries)))

  for i, config in enumerate(configDictionaries):
    name = "Config"+(str(i).rjust(lenMaxConfigNumber,"0"))
    print(testBench.name+" New configuration: "+name+str(config))
    testBench.add_config(name ,config)

isModelSimOpen = "-g" in sys.argv
if isUseGenerateConfiguration:="-gc" in sys.argv:
  sys.argv.remove("-gc")

sys.argv.append('--no-color')

cli = VUnitCLI()
cli.parser.add_argument('--wave', action="store_true", default=False)
args = cli.parse_args()

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_args(args=args, compile_builtins=False)
vu.add_vhdl_builtins()
wave = args.wave
vu.add_osvvm()
vu.add_verification_components()

RTL_PATH = Path(__file__).parent / "rtl"
TESTS_PATH = Path(__file__).parent / "tests"
CURRENT_PATH = Path(__file__).parent.resolve()

# Define libraries
ARP_and_CRC_check = vu.add_library("ARP_and_CRC_check")
ARP_and_CRC_check.add_source_files(RTL_PATH / "*.v")

tb_ARP_and_CRC_check = vu.add_library("tb_ARP_and_CRC_check")
tb_ARP_and_CRC_check.add_source_files(TESTS_PATH / "*.vhd")




if isModelSimOpen:
  # Set simulation options(optimization)
  vu.set_sim_option('modelsim.vsim_flags', ["-voptargs=\"+acc\""])
#   if (CURRENT_PATH / 'scripts' / 'wave.do').exists():
#     vu.set_sim_option('modelsim.init_files.after_load', [str(CURRENT_PATH / 'scripts' / 'wave.do')])

# add more configuration for testbench
if(isUseGenerateConfiguration):
  testBenchName = "crc_checker_tb"
  genericName = ["asi_valid_high_probability",
                "aso_ready_high_probability"]
  genericValue = [[0.1, 0.5, 1.0],
                  [0.1, 0.5, 1.0]]
  testBench = tb_ARP_and_CRC_check.test_bench(testBenchName)
  addConfiguration(testBench, genericName, genericValue)

  testBenchName = "arp_service_tb"
  testBench = tb_ARP_and_CRC_check.test_bench(testBenchName)
  addConfiguration(testBench, genericName, genericValue)
  testBenchName = "udp_service_tb"
  testBench = tb_ARP_and_CRC_check.test_bench(testBenchName)
  addConfiguration(testBench, genericName, genericValue)


# Run VUnit
vu.main()
