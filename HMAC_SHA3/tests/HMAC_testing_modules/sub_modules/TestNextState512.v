// The TestNextState512 module implements a logic unit that determines the next value of the input data sequence.
// The TestNextState512 module asserts the outState output signal.

module TestNextState512 (
    input  wire [575:0] inState, // Data bus input before calculating the next value
    output wire [575:0] outState // Data bus output after calculating the next value
);

assign outState[575:8] = inState[567:0];
assign outState[7:0] = inState[575:568]+3'd7;

endmodule
