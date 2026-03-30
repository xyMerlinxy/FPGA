import uvm_pkg::*;
import adder_agent_pkg::*;
import adder_env_pkg::*;
import adder_seq_pkg::*;
import test_pkg::*;

module tb_top;
    adder_if inf();
    full_adder dut (.a(inf.a), .b(inf.b), .cin(inf.cin), .sum(inf.sum), .cout(inf.cout));

    initial begin
        uvm_config_db#(virtual adder_if)::set(null, "*", "vif", inf);
        run_test("base_test");
    end

endmodule