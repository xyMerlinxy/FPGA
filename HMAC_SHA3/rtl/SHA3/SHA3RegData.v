// The SHA3RegData module implements the state register for the algorithm coprocessor.
// The SHA3RegData module provides the following functions:
// - Initialization of the coprocessor state to default values;
// - Storing the next state in the coprocessor state register;
// - Providing data at the output bus.

// The regData register is updated as follows:
// - regData is assigned its initial value when the coprocessor is restored to its default state;
// - regData is loaded with the result of the final algorithm step;
// - Message data is absorbed into regData by performing a bitwise XOR (symmetric difference) operation.

module SHA3RegData #(
  parameter IN_DATA_SIZE = 576
)(
  input  wire          inClk,      // Clock signal input; active on the rising edge
  input  wire          inExtRst,   // External state register reset input; active high
  input  wire          inIntRst,   // Internal state register reset input; active high
  input  wire          inExtWr,    // External write enable (from inExtData bus); active high
  input  wire [IN_DATA_SIZE - 1:0] inExtData,  // Message data bus input
  input  wire          inIntWr,    // Internal write enable (from inIntData bus); active high
  input  wire [1599:0] inIntData,  // Next state data bus input
  output wire [1599:0] outIntData  // Output data bus for next state calculation
);

reg [1599:0] regData = 1600'h0;

always @ (posedge(inClk))
begin
  if ((inExtRst == 1'b1)  || (inIntRst == 1'b1))
    regData <= 1600'h0;
  else if (inExtWr == 1'b1)
    regData[IN_DATA_SIZE-1:0] <= regData[IN_DATA_SIZE-1:0]^inExtData;
  else if (inIntWr == 1'b1)
    regData <= inIntData;
end

assign outIntData = regData;

endmodule
