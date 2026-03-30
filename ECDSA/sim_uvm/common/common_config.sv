class common_config extends uvm_object;
    `uvm_object_utils(common_config)

    int           width = 192;
    logic [191:0] mod_p = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff;
    logic [191:0] value_a = 192'hfffffffffffffffffffffffffffffffefffffffffffffffc;

    function new(string name = "common_config");
        super.new(name);
    endfunction
endclass