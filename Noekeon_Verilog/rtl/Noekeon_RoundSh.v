// This module implements the Noekeon algorithm's round function.
// It is a composition of Theta, Gamma, Pi1, and Pi2 operations, along with an XOR with a round constant.


module NoekeonRoundSh(
  input wire  [127:0]  inData,
  input wire  [127:0]  inKey,
  input wire  [7:0]    inRoundConst,
  input wire        inDecipher,      // 0 - cipher, 1 - decipher
  output wire  [127:0]  outData
);

wire  [127:0]  temp1;
wire  [127:0]  temp2;
wire  [127:0]  temp3;
wire  [127:0]  temp4;
wire  [127:0]  temp5;

assign temp1 = (inDecipher == 1'b1) ? inData: {inData[127:8],inData[7:0]^inRoundConst};
NoekeonTheta noekeon_theta(.inKey(inKey), .inData(temp1), .outData(temp2));
assign temp3 = (inDecipher == 1'b0) ? temp2: {temp2[127:8],temp2[7:0]^inRoundConst};
NoekeonPi1 noekeon_Pi1(.inData(temp3), .outData(temp4));
NoekeonGamma noekeon_gamma(.inData(temp4), .outData(temp5));
NoekeonPi2 noekeon_Pi2(.inData(temp5), .outData(outData));

endmodule
