class fp_add_item extends uvm_sequence_item;

    logic [191:0] data_a;
    logic [191:0] data_b;
    logic [191:0] result;

    `uvm_object_utils_begin(fp_add_item)
        `uvm_field_int(data_a, UVM_ALL_ON)
        `uvm_field_int(data_b, UVM_ALL_ON)
        `uvm_field_int(result, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fp_add_item");
        super.new(name);
    endfunction


endclass : fp_add_item