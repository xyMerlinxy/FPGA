// This module performs the Theta operation on the key during decryption; otherwise, it remains idle (pass-through).
// This is a combinatorial module.

module NoekeonKeyTheta(
  input wire  [127:0]  inKey,
  input wire        inDecipher, // 0 - cipher, 1 - decipher
  output wire  [127:0]  outKey
);

wire  [127:0]  outTheta;

NoekeonTheta noekeon_Theta(
    .inData(inKey),
    .inKey(128'h0),
    .outData(outTheta)
);

assign outKey = (inDecipher == 1'b1) ? outTheta : inKey;

endmodule
