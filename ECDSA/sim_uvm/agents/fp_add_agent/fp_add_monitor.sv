class fp_add_monitor extends uvm_monitor;
    `uvm_component_utils(fp_add_monitor)

    virtual fp_add_inf.mp_mon vif;

    uvm_analysis_port #(fp_add_item) item_collected_port;

    fp_add_item pending_queue[$];

    function new(string name = "fp_add_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fp_add_inf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Unable to find virtual interface vif in config_db!")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        bit last_o_valid = 0;

        forever begin
            @(vif.mon_cb);

            // collect all input data
            if (vif.mon_cb.i_data_wr === 1'b1) begin
                fp_add_item in_item;
                in_item = fp_add_item::type_id::create("in_item");
                in_item.data_a = vif.mon_cb.i_data_a;
                in_item.data_b = vif.mon_cb.i_data_b;
                
                pending_queue.push_back(in_item);
            end

            if (vif.mon_cb.o_valid === 1'b1 && last_o_valid === 1'b0) begin
                if (pending_queue.size() > 0) begin
                    fp_add_item out_item;
                    out_item = pending_queue.pop_front();
                    out_item.result = vif.mon_cb.o_data;
                    item_collected_port.write(out_item);
                end else begin
                    `uvm_error("MON", "Get o_valid, but queue is empty! (Unexpected valid)")
                end
            end
        last_o_valid = vif.mon_cb.o_valid;
        end
    endtask

endclass