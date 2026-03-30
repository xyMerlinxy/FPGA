import uvm_pkg::*;
import common_pkg::*;
import fp_add_agent_pkg::*;
import env_pkg::*;
import seq_pkg::*;
import test_pkg::*;
`include "uvm_macros.svh"


module tb_fp_add;

    parameter [191:0] TB_MOD_P = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff;

    logic clk;
    logic rst_n;

    fp_add_inf intf(clk, rst_n);

    fp_add #(
        .MOD_P(TB_MOD_P)
    ) dut (
        .clk      (intf.clk),
        .rst_n    (intf.rst_n),
        .i_data_a (intf.i_data_a),
        .i_data_b (intf.i_data_b),
        .i_data_wr(intf.i_data_wr),
        .o_data   (intf.o_data),
        .o_valid  (intf.o_valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #40;
        rst_n = 1;
    end

    initial begin
        common_config cfg;
        cfg = common_config::type_id::create("cfg");
        cfg.mod_p = TB_MOD_P; 
        uvm_config_db#(common_config)::set(null, "*", "cfg", cfg);

        uvm_config_db#(virtual fp_add_inf)::set(null, "*", "vif", intf);
        run_test();
    end


endmodule