// The TestNextState384 module implements a logic unit that determines the next value of the input data sequence.
// The TestNextState384 module asserts the outState output signal.

module TestNextState384 (
    input  wire [831:0] inState, // Data bus input before calculating the next value
    output wire [831:0] outState // Data bus output after calculating the next value
);

assign outState[831:8] = inState[823:0];
assign outState[7:0] = inState[831:824]+3'd7;

endmodule
