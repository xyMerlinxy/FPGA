// The HMACSHA3Hash module implements the communication interface between the HMACSHA3 module and the SHA3 core.
// Based on control signals, the HMACSHA3Hash module routes data from the appropriate input bus to the inDataData input of the SHA3 module. 
// Additionally, it applies the necessary padding to the hash value when it is being fed back into the inDataData input of the SHA3 core.

// The data provided to the SHA3 module's inDataData input is controlled as follows:
// - If inExtWr is high, data from the inExtData bus is routed to inDataData;
// - If inKeyWr is high, data from the inKeyData bus is routed to inDataData;
// - If inIpadWr is high, data from the inIpadData bus is routed to inDataData;
// - If inOpadWr is high, data from the inOpadData bus is routed to inDataData;
// - If inHashWr is high, the hash read from the SHA3 module's outDataData output is routed to inDataData,
//   concatenated with the '01' bits (as per SHA-3 specification) and the padding described in the designated section.

module HMACSHA3Hash #(
  parameter HASH_SIZE = 512
)(
  inClk,        // Clock signal input; active on the rising edge
  inRst,        // SHA3 module reset input; active high
  inDataEnd,    // End-of-message signal input
  inExtData,    // External message data bus input
  inKeyData,    // Key data bus input
  inIpadData,   // Input bus for the $Ipad \oplus K_0$ data
  inOpadData,   // Input bus for the $Opad \oplus K_0$ data

  inSelectData, // Data multiplexer select signal
  inWr,         // Write enable signal

  outHashData,  // Hash data bus output
  outBusy       // SHA3 module busy status output
);

localparam IN_DATA_SIZE = 1600 - 2 * HASH_SIZE;

input wire inClk;
input wire inRst;
input wire inDataEnd;
input wire inWr;

input  wire [IN_DATA_SIZE - 1:0] inExtData;
input  wire [IN_DATA_SIZE - 1:0] inKeyData;
input  wire [IN_DATA_SIZE - 1:0] inIpadData;
input  wire [IN_DATA_SIZE - 1:0] inOpadData;
input wire [2:0] inSelectData;
output wire [HASH_SIZE - 1:0]  outHashData;
output wire                    outBusy;

reg [IN_DATA_SIZE - 1:0] sha3DataData;


always @(*) begin
  case (inSelectData)
    3'd0 :sha3DataData = inExtData;
    3'd1 :sha3DataData = inKeyData;
    3'd2 :sha3DataData = inIpadData;
    3'd3 :sha3DataData = inOpadData;
    3'd4 : begin
      sha3DataData[IN_DATA_SIZE - 2:0] = {3'b110,outHashData};
      sha3DataData[IN_DATA_SIZE - 1] = 1'b1;
    end
    default :sha3DataData = 1'b0;
  endcase
end

SHA3 #(
  .HASH_SIZE(HASH_SIZE)
) sha3(
  .inClk(inClk),
  .inRst(inRst),
  .inDataWr(inWr),
  .inDataData(sha3DataData),
  .inEnd(inDataEnd),
  .outDataData(outHashData),
  .outBusy(outBusy)
);
endmodule