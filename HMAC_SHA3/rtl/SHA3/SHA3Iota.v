// The SHA3Iota module implements the Iota transformation on the state array A.
// The SHA3Iota module asserts the outState output signal.

module SHA3Iota(
    input wire  [1599:0]  inState,    // Input data bus for state array A before the Iota operation
    input wire  [4:0]     inRoundCnt, // Input data bus for the round number
    output wire [1599:0]  outState    // Output data bus for state array A after the Iota operation
);


wire [63:0] RC;

SHA3Rc instSHA3Rc(
    .inRoundCnt(inRoundCnt),
    .outRC(RC)
);

assign outState[1599:64] = inState[1599:64];
assign outState[63:0] = inState[63:0]^RC;

endmodule 