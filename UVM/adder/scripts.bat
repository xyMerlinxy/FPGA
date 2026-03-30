@REM compilation
vlog +incdir+$UVM_HOME/src +incdir+../tb/agents/adder_agent +incdir+../tb/sequences  +incdir+../tb/env +incdir+../tb/tests  ../rtl/full_adder.v ../tb/agents/adder_agent/adder_agent_pkg.sv ..\tb\agents\adder_agent\adder_if.sv ../tb/sequences/adder_seq_pkg.sv ../tb/env/adder_env_pkg.sv ../tb/tests/test_pkg.sv ../tb/top/tb_top.sv

@REM run tests
vsim -c -do "run -all; quit" tb_top +UVM_TESTNAME=base_test