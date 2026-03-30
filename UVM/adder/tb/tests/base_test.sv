class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    adder_env env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = adder_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        adder_directed_seq seq;
        seq = adder_directed_seq::type_id::create("seq");
        
        phase.raise_objection(this);
        seq.start(env.agent.sequencer);
        #1;
        phase.drop_objection(this);
    endtask
endclass