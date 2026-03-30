class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)
    virtual adder_if.mon_mp vif;
    uvm_analysis_port #(adder_item) item_collected_port;

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Unable to find virtual interface vif in config_db!")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        adder_item item;
        forever begin
            #10;
            item = adder_item::type_id::create("item");
            
            item.a = vif.a;
            item.b = vif.b;
            item.cin = vif.cin;
            item.sum = vif.sum;
            item.cout = vif.cout;

            item_collected_port.write(item);
        end
    endtask
endclass