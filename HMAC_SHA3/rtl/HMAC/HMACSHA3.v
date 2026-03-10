// The HMACSHA3 module implements a coprocessor for the HMAC-SHA3 algorithm.
// The module provides the following functions:
// - Coprocessor reset to the initial state;
// - Key block(s) loading;
// - Message data block(s) loading for hashing;
// - Message digest (hash) readout;
// - System busy status signaling.

// Operational Procedure:
// - Assert the `inRst` signal high for at least one clock cycle;
// - For each key data block except the last one:
//   - Wait for the `outBusy` signal to go low;
//   - Assert the key data on the `inKeyData` input and set the `inKeyWr` input high for one clock cycle;
// - Wait for the `outBusy` signal to go low;
// - Assert the final key data block on the `inKeyData` input, and set both `inKeyWr` and `inKeyEnd` inputs high for one clock cycle;
// - For each message data block except the last one:
//   - Wait for the `outBusy` signal to go low;
//   - Assert the message data on the `inDataData` input and set the `inDataWr` input high for one clock cycle;
// - Wait for the `outBusy` signal to go low;
// - Assert the final message data block on the `inDataData` input, and set both `inDataWr` and `inDataEnd` inputs high for one clock cycle;
// - Wait for the `outHashEnable` signal to go high;
// - Read the resulting digest from the `outHash` bus.

// Once key entry begins, all data received on the key interface is treated as the key until the `inKeyEnd` signal is asserted high.
// If the key is larger than a single block size, its final block must be padded according to the SHA-3 specification.
// If the key is shorter than a single block size, the key must be shifted to the most significant bits (MSB).

module HMACSHA3 #(
  parameter HASH_SIZE = 512
)(
  inClk,         // signal input; active on the rising edge
  inRst,         // reset signal; active high. Restores the module to its initial state
  inDataData,    // input bus for message data blocks to be hashed
  inDataWr,      // data write enable; active high
  inDataEnd,     // end-of-message signal; triggers the final hash computation.
  inKeyData,     // input bus for HMAC key data blocks
  inKeyWr,       // key write enable; active high
  inKeyEnd,      // end-of-key signal; terminates key loading and initiates key processing
  outHash,       // output bus providing the final message digest (HMAC result)
  outHashEnable, // valid signal; indicates that the final hash is available on the outHash bus
  outBusy        // busy signal; active high. Indicates the coprocessor is currently processing.
);

localparam IN_DATA_SIZE = 1600 - 2 * HASH_SIZE;

input wire inClk, inRst, inDataWr, inDataEnd, inKeyWr, inKeyEnd;
output wire outHashEnable, outBusy;
output wire [HASH_SIZE - 1:0] outHash;

input  wire [IN_DATA_SIZE - 1:0] inDataData;
input  wire [IN_DATA_SIZE - 1:0] inKeyData;


wire [IN_DATA_SIZE - 1:0] wireKeyRegOutIpadKey;
wire [IN_DATA_SIZE - 1:0] wireKeyRegOutOpadKey;
wire [HASH_SIZE - 1:0]    wireHashOutData;
wire                      wireHashOutBusy;

//wire         wireControlOutEnableHash;
wire wireControlOutHashDataEnd;

wire wireControlOutKeyExtWr;
wire wireControlOutKeyIntWr;

wire [2:0] wireControlOutHashSelectData;
wire wireControlOutHashWr;


HMACSHA3Control hmacSha3Control(
  .inClk(inClk),
  .inRst(inRst),
  .inDataWr(inDataWr),
  .inDataEnd(inDataEnd),
  .inKeyWr(inKeyWr),
  .inKeyEnd(inKeyEnd),
  .inShaBusy(wireHashOutBusy),
  .outBusy(outBusy),
  // signals for hash module
  .outHashDataEnd(wireControlOutHashDataEnd),
  .outEnableHash(outHashEnable),
  .outSelectData(wireControlOutHashSelectData),
  .outHashWr(wireControlOutHashWr),
  // signals for key register
  .outRegKeyExtWr(wireControlOutKeyExtWr),
  .outRegKeyInIntWr(wireControlOutKeyIntWr)
);


HMACSHA3RegKey #(
  .HASH_SIZE(HASH_SIZE)
) hmacSha3KeyReg(
  .inClk(inClk),
  .inRst(inRst),
  .inExtWr(wireControlOutKeyExtWr),
  .inExtKey(inKeyData),
  .inIntWr(wireControlOutKeyIntWr),
  .inIntKey(wireHashOutData),
  .outIpadKey(wireKeyRegOutIpadKey), 
  .outOpadKey(wireKeyRegOutOpadKey)
);


HMACSHA3Hash #(
  .HASH_SIZE(HASH_SIZE)
) hmacSha3Hash(
  .inClk(inClk),
  .inRst(inRst),
  .inDataEnd(wireControlOutHashDataEnd),
  .inExtData(inDataData),
  .inKeyData(inKeyData),
  .inIpadData(wireKeyRegOutIpadKey),
  .inOpadData(wireKeyRegOutOpadKey),
  .inSelectData(wireControlOutHashSelectData),
  .inWr(wireControlOutHashWr),

  .outHashData(wireHashOutData),
  .outBusy(wireHashOutBusy)
);

HMACSHA3OutData #(
  .HASH_SIZE(HASH_SIZE)
) hmacSha3OutData(
  .inEnable(outHashEnable),
  .inOutData(wireHashOutData),
  .outOutData(outHash)
);


endmodule