class fp_add_scoreboard extends uvm_scoreboard;
    `uvm_component_param_utils(fp_add_scoreboard)
    
    common_config cfg;

    int pass_count = 0;
    int fail_count = 0;

    uvm_analysis_imp #(fp_add_item, fp_add_scoreboard) item_collected_export;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(common_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("SCBD", "Do not find common config!")
        end
    endfunction


    virtual function void write(fp_add_item item);
        logic [192:0] full_sum;
        logic [191:0] expected;

        full_sum = item.data_a + item.data_b;
        
        if (full_sum >= cfg.mod_p) begin
            expected = full_sum - cfg.mod_p;
        end else begin
            expected = full_sum[191:0];
        end

        if (item.result === expected) begin
            pass_count++;
            `uvm_info("SCBD", $sformatf("PASS: %h + %h (mod P) = %h", 
                      item.data_a, item.data_b, item.result), UVM_MEDIUM)
        end else begin
            fail_count++;
            `uvm_error("SCBD", $sformatf("FAIL: A=%h B=%h | Exp: %h, Got: %h", 
                       item.data_a, item.data_b, expected, item.result))
        end
    endfunction

    // End report
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCBD_REP", "\n---------------------------------------", UVM_LOW)
        `uvm_info("SCBD_REP", $sformatf("  TOTAL TRANSACTIONS: %0d", pass_count + fail_count), UVM_LOW)
        `uvm_info("SCBD_REP", $sformatf("  PASSED:             %0d", pass_count), UVM_LOW)
        `uvm_info("SCBD_REP", $sformatf("  FAILED:             %0d", fail_count), UVM_LOW)
        `uvm_info("SCBD_REP", "---------------------------------------\n", UVM_LOW)
        
        if (fail_count > 0)
            `uvm_error("SCBD_REP", "#### TEST FAILED ####")
        else
            `uvm_info("SCBD_REP", "#### TEST PASSED ####", UVM_LOW)
    endfunction

endclass