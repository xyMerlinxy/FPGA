// The SHA3 module implements a SHA3 algorithm coprocessor.
// The module provides the following functions:
// - Resetting the coprocessor to its initial state;
// - Loading message data block(s) for hashing;
// - Reading the message digest;
// - System busy status signaling.

// Operational Procedure:
// - Assert the inRst signal high for at least one clock cycle;
// - For each data block except the last one:
//   - Wait for the outBusy signal to go low;
//   - Assert the data to be hashed on the inDataData input and set the inDataWr input high for one clock cycle;
// - Wait for the outBusy signal to go low;
// - Assert the final data block on the inDataData input, set the inDataWr input high, and set the inEnd input high for one clock cycle;
// - Wait for the outBusy signal to go low;
// - Read the resulting digest from the outDataData bus.


module SHA3 #(
  parameter HASH_SIZE = 512
)(
  inClk,       // Clock signal input; active on the rising edge
  inRst,       // Coprocessor reset input; active high
  inDataWr,    // Data write enable for hashing; active high
  inDataData,  // input bus for data to be hashed
  inEnd,       // End-of-message signal; triggers the final hash computation
  outDataData, // output bus for the message digest
  outBusy      // System busy status output; active high
);

localparam IN_DATA_SIZE = 1600 - 2 * HASH_SIZE;

// in/output
input wire inClk;
input wire inRst;
input wire inDataWr;
input wire inEnd;
output wire outBusy;
output wire [HASH_SIZE- 1:0] outDataData;
input wire [IN_DATA_SIZE - 1:0] inDataData;


wire          wireControlOutRegDataInExtWr;
wire          wireControlOutRegDataInIntWr;
wire [1599:0] wireRegDataDataInInt;
wire [1599:0] wireRegDataDataOut;

wire          wireControlOutRegOutDataInWr;
wire [4:0]    wireControlOutRoundCnt;

wire          wireControlOutRstRegData;
wire          wireControlOutRstRegOutData;

SHA3Control instSha3Control(
  .inClk(inClk),
  .inExtRst(inRst),
  .inEnd(inEnd),
  .inExtDataWr(inDataWr),
  .outBusy(outBusy),
  .outRegDataInIntWr(wireControlOutRegDataInIntWr),
  .outRegDataInExtWr(wireControlOutRegDataInExtWr),
  .outRegOutDataWr(wireControlOutRegOutDataInWr),
  .outRoundCnt(wireControlOutRoundCnt),
  .outRegDataRst(wireControlOutRstRegData)
);

SHA3RegData #(
  .IN_DATA_SIZE(IN_DATA_SIZE)
) instSha3RegData(
    .inClk(inClk),
    .inIntRst(wireControlOutRstRegData),
    .inExtRst(inRst),
    .inExtWr(wireControlOutRegDataInExtWr),
    .inExtData(inDataData),
    .inIntWr(wireControlOutRegDataInIntWr),
    .inIntData(wireRegDataDataInInt),
    .outIntData(wireRegDataDataOut));

SHA3RegOutData #(
  .HASH_SIZE(HASH_SIZE)
) instSha3RegOutData(
  .inClk(inClk),
  .inRst(inRst),
  .inWr(wireControlOutRegOutDataInWr),
  .inData(wireRegDataDataInInt),
  .outData(outDataData)
);

SHA3Rnd instSha3Rnd(
  .inState(wireRegDataDataOut),
  .inRoundCnt(wireControlOutRoundCnt),
  .outState(wireRegDataDataInInt)
);

endmodule