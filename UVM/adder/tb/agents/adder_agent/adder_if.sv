interface adder_if;
    // Signal definition
    logic a;
    logic b;
    logic cin;
    logic sum;
    logic cout;

    // Modport for Driver
    modport drv_mp (
        output a, b, cin,
        input  sum, cout
    );

    // Modport for Monitor
    modport mon_mp (
        input a, b, cin, sum, cout
    );

endinterface : adder_if