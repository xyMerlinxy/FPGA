class fp_add_directed_seq extends uvm_sequence #(fp_add_item);
    `uvm_object_param_utils(fp_add_directed_seq)

    common_config cfg;

    function new(string name = "fp_add_directed_seq");
        super.new(name);
    endfunction

    virtual task body();
        fp_add_item item;

        if (!uvm_config_db#(common_config)::get(null, "", "cfg", cfg)) begin
            `uvm_fatal("SEQ", "Do not find common config!")
        end

        item = fp_add_item::type_id::create("item");

        `uvm_info("SEQ", "Start: Directed tests", UVM_LOW)

        start_item(item);
        item.data_a   = 192'h0;
        item.data_b   = 192'h0;
        finish_item(item);

        start_item(item);
        item.data_a   = 192'h1;
        item.data_b   = 192'h0;
        finish_item(item);

        start_item(item);
        item.data_a   = 192'h1;
        item.data_b   = 192'h1;
        finish_item(item);

        start_item(item);
        item.data_a   = cfg.mod_p-1'b1;
        item.data_b   = 192'h1;
        finish_item(item);

        start_item(item);
        item.data_a   = cfg.mod_p-1'b1;
        item.data_b   = cfg.mod_p-1'b1;
        finish_item(item);

        `uvm_info("SEQ", "End: Directed tests", UVM_LOW)
    endtask
endclass