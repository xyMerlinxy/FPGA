class adder_directed_seq extends uvm_sequence #(adder_item);
    `uvm_object_utils(adder_directed_seq)

    function new(string name = "adder_directed_seq");
        super.new(name);
    endfunction

    virtual task body();
        adder_item item;
        item = adder_item::type_id::create("item");

        `uvm_info("SEQ", "Start: Directed tests", UVM_LOW)

        for (int i = 0; i < 8; i++) begin
            start_item(item);
            item.a   = i[2];
            item.b   = i[1];
            item.cin = i[0];
            finish_item(item);
        end

        `uvm_info("SEQ", "End: Directed tests", UVM_LOW)
    endtask
endclass