class fp_add_test extends uvm_env;
    `uvm_component_utils(fp_add_test)

    fp_add_env env;
    common_config cfg;

    function new(string name = "fp_add_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction




    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(common_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("TEST", "Do not find common config!")
        end

        env = fp_add_env::type_id::create("env", this);

    endfunction

    virtual task run_phase(uvm_phase phase);
        fp_add_directed_seq seq;
        seq = fp_add_directed_seq::type_id::create("seq");
        
        phase.raise_objection(this);
        seq.start(env.agent.sequencer);
        #1;
        phase.drop_objection(this);
    endtask
endclass