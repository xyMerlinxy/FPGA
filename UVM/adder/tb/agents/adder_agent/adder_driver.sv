class adder_driver extends uvm_driver #(adder_item);
    `uvm_component_utils(adder_driver)
    virtual adder_if.drv_mp vif;

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Unable to find virtual interface vif in config_db!")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            vif.a   <= req.a;
            vif.b   <= req.b;
            vif.cin <= req.cin;
            #10; 
            seq_item_port.item_done();
        end
    endtask
endclass