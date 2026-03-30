class fp_add_driver extends uvm_driver #(fp_add_item);
    `uvm_component_utils(fp_add_driver)

    virtual fp_add_inf.mp_drv vif;

    function new(string name = "fp_add_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Het interface from Config DB
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fp_add_inf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Unable to find virtual interface vif in config_db!")
        end
    endfunction

    
    virtual task run_phase(uvm_phase phase);
        // Signals initialization
        vif.drv_cb.i_data_wr <= 1'b0;
        vif.drv_cb.i_data_a  <= '0;
        vif.drv_cb.i_data_b  <= '0;

        // Wait for reset
        wait(vif.rst_n === 1'b1);

        forever begin
            seq_item_port.get_next_item(req);
            drive_item(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_item(fp_add_item item);
        @(vif.drv_cb);
        

        vif.drv_cb.i_data_a  <= item.data_a;
        vif.drv_cb.i_data_b  <= item.data_b;
        vif.drv_cb.i_data_wr <= 1'b1;

        @(vif.drv_cb);
        vif.drv_cb.i_data_wr <= 1'b0;
        vif.drv_cb.i_data_a  <= 'x; // overwrite input values
        vif.drv_cb.i_data_b  <= 'x;
        @(vif.drv_cb);
        
        while (vif.drv_cb.o_valid == 1'b0) begin
            @(vif.drv_cb);
        end;
    endtask

endclass