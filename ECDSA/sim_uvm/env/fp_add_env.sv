class fp_add_env extends uvm_env;
    
    `uvm_component_param_utils(fp_add_env)

    fp_add_agent      agent;
    fp_add_scoreboard scoreboard;

    function new(string name = "fp_add_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        agent = fp_add_agent::type_id::create("agent", this);
        scoreboard = fp_add_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
    endfunction

endclass : fp_add_env