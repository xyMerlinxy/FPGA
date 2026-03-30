package adder_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "adder_item.sv"
    
    typedef uvm_sequencer #(adder_item) adder_sequencer;

    `include "adder_driver.sv"
    `include "adder_monitor.sv"
    `include "adder_agent.sv"

endpackage : adder_agent_pkg