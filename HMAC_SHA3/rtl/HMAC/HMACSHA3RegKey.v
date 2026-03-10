// The HMACSHA3RegKey module implements the key storage register.
// The HMACSHA3RegKey module provides the following functions:
// - Initialization of the key register to default values;
// - Storing a new key in the register;
// - Providing the key at the output in two forms: $Ipad \oplus K_0$ and $Opad \oplus K_0$.
//
// The regKey register is updated as follows:
// - regKey is assigned its initial value when the coprocessor is restored to its default state;
// - regKey is loaded with the current key value.

module HMACSHA3RegKey #(
  parameter HASH_SIZE = 512
)(
  inClk,      // Clock signal input; active on the rising edge
  inRst,      // Key register reset input; active high
  inExtWr,    // External key write enable (from inExtKey bus); active high
  inExtKey,   // External key data bus input
  inIntWr,    // Internal key write enable (from inIntKey bus); active high
  inIntKey,   // Internal key data bus input (from the hash module)
  outIpadKey, // Output bus providing the $Ipad \oplus K_0$ value
  outOpadKey  // Output bus providing the $Opad \oplus K_0$ value
);

localparam IN_DATA_SIZE = 1600 - 2 * HASH_SIZE;

input  wire                      inClk, inRst,  inExtWr, inIntWr;   
input  wire [HASH_SIZE - 1:0]    inIntKey;  
input  wire [IN_DATA_SIZE - 1:0] inExtKey;  
output wire [IN_DATA_SIZE - 1:0] outIpadKey;
output wire [IN_DATA_SIZE - 1:0] outOpadKey; 

reg [IN_DATA_SIZE - 1:0] regKey = 1'h0;

always @ (posedge(inClk))
begin
  if (inRst == 1'b1) begin
    regKey <= 1'h0;
  end
  if (inExtWr == 1'b1) begin
    regKey <= inExtKey;
  end
  if (inIntWr == 1'b1) begin
    regKey <= inIntKey;
  end
end

genvar i;
generate
  for (i = 0; i<IN_DATA_SIZE; i = i + 8 ) begin:o_pad_and_i_pad
// Output the $Ipad \oplus K_0$ value on the outIpadKey bus.
    assign outIpadKey[i+7:i] = regKey[i+7:i] ^ 8'h36;
    
    // Output the $Opad \oplus K_0$ value on the outOpadKey bus.
    assign outOpadKey[i+7:i] = regKey[i+7:i] ^ 8'h5c;
  end
endgenerate

endmodule
