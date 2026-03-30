class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)
    
    int pass_count = 0;
    int fail_count = 0;

    uvm_analysis_imp #(adder_item, adder_scoreboard) item_collected_export;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(adder_item item);
        bit [1:0] expected = item.a + item.b + item.cin;
        
        if ({item.cout, item.sum} === expected) begin
            pass_count++;
            `uvm_info("SCBD", $sformatf("PASS: %0d+%0d+%0d = %0d (C:%0d)", 
                      item.a, item.b, item.cin, item.sum, item.cout), UVM_LOW)
        end else begin
            fail_count++;
            `uvm_error("SCBD", $sformatf("FAIL: In: a=%0d b=%0d cin=%0d | Exp: %0b, Got: %0b", 
                       item.a, item.b, item.cin, expected, {item.cout, item.sum}))
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCBD_REP", "---------------------------------------", UVM_LOW)
        `uvm_info("SCBD_REP", $sformatf("  TOTAL TRANSACTIONS: %0d", pass_count + fail_count), UVM_LOW)
        `uvm_info("SCBD_REP", $sformatf("  PASSED:             %0d", pass_count), UVM_LOW)
        `uvm_info("SCBD_REP", $sformatf("  FAILED:             %0d", fail_count), UVM_LOW)
        `uvm_info("SCBD_REP", "---------------------------------------", UVM_LOW)
        
        if (fail_count > 0)
            `uvm_error("SCBD_REP", "#### TEST FAILED ####")
        else
            `uvm_info("SCBD_REP", "#### TEST PASSED ####", UVM_LOW)
    endfunction

endclass