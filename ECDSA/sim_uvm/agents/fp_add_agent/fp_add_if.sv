interface fp_add_inf #(
    parameter [191:0] MOD_P = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff
) (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic [191:0] i_data_a;
    logic [191:0] i_data_b;
    logic         i_data_wr;
    logic [191:0] o_data;
    logic         o_valid;

    // Clocking block for Driver
    clocking drv_cb @(posedge clk);
        default input #1ns output #1ns;
        output i_data_a;
        output i_data_b;
        output i_data_wr;
        input  o_data;
        input  o_valid;
    endclocking

    // Clocking block for Monitor
    clocking mon_cb @(posedge clk);
        default input #1ns;
        input i_data_a;
        input i_data_b;
        input i_data_wr;
        input o_data;
        input o_valid;
    endclocking

    
    modport mp_drv (clocking drv_cb, input clk, rst_n);
    modport mp_mon (clocking mon_cb, input clk, rst_n);

endinterface : fp_add_inf