// The SHA3RegOutData module implements the register for storing the calculated message digest.
// The SHA3RegOutData module provides the following functions:
// - Initialization of the output register to its default values;
// - Storing a new digest in the register;
// - Providing the stored data at the output.

// The regData register is updated as follows:
// - regData is assigned a value of 0 when the coprocessor is restored to its default state;
// - regData is loaded with the message digest.

module SHA3RegOutData #(
  parameter HASH_SIZE = 512
)(
  input   wire                   inClk,   // Clock signal input; active on the rising edge
  input   wire                   inRst,   // Output register reset input; active high
  input   wire                   inWr,    // Digest register write enable from the inData bus; active high
  input   wire [1599:0]          inData,  // Input bus for the hash/digest data (full state)
  output  wire [HASH_SIZE - 1:0] outData  // Output bus for the truncated message digest
);

reg [HASH_SIZE - 1:0] regData = 1'd0;

always @ (posedge(inClk))
begin
  if (inRst == 1'b1) begin
    regData <= 1'h0;
  end else if (inWr == 1'b1) begin
    regData <= inData[HASH_SIZE - 1:0];
  end
end

assign outData = regData;

endmodule
