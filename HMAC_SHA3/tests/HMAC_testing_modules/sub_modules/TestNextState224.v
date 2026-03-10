// The TestNextState224 module implements a logic unit that determines the next value of the input data sequence.
// The TestNextState224 module asserts the outState output signal.

module TestNextState224 (
    input  wire [1151:0] inState, // Data bus input before calculating the next value
    output wire [1151:0] outState // Data bus output after calculating the next value
);
	
assign outState[1151:8] = inState[1143:0];
assign outState[7:0] = inState[1151:1144]+3'd7;

endmodule
