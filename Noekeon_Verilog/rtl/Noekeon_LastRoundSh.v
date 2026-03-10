// This module implements the Noekeon algorithm's round function.
// It is a composition of the Theta transformation and a XOR operation with a round constant.

module NoekeonLastRoundSh(
  input wire  [127:0]  inData,
  input wire  [127:0]  inKey,
  input wire  [7:0]    inRoundConst,
  input wire        inDecipher,    // 0 - cipher, 1- decipher
  output wire  [127:0]  outData
);

wire  [127:0]  temp1;
wire  [127:0]  temp2;

assign temp1 = (inDecipher == 1'b1) ? inData: {inData[127:8],inData[7:0]^inRoundConst};
NoekeonTheta noekeon_theta(.inKey(inKey), .inData(temp1), .outData(temp2));
assign outData = (inDecipher == 1'b0) ? temp2: {temp2[127:8],temp2[7:0]^inRoundConst};

endmodule
