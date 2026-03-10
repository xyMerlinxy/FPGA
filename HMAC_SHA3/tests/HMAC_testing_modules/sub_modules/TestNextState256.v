// The TestNextState256 module implements a logic unit that determines the next value of the input data sequence.
// The TestNextState256 module asserts the outState output signal.

module TestNextState256 (
    input  wire [1087:0] inState, // Data bus input before calculating the next value
    output wire [1087:0] outState // Data bus output after calculating the next value
);

assign outState[1087:8] = inState[1079:0];
assign outState[7:0] = inState[1087:1080]+3'd7;

endmodule
