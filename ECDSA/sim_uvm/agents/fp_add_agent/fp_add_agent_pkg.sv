package fp_add_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "fp_add_item.sv"
    
    typedef uvm_sequencer #(fp_add_item) fp_add_sequencer;

    `include "fp_add_driver.sv"
    `include "fp_add_monitor.sv"
    `include "fp_add_agent.sv"

endpackage : fp_add_agent_pkg