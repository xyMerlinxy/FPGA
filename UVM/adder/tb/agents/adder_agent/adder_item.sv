class adder_item extends uvm_sequence_item;
    `uvm_object_utils(adder_item)

    bit a, b, cin; // Input data
    bit sum, cout; // Output data

    function new(string name = "adder_item");
        super.new(name);
    endfunction
endclass