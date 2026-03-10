// This module implements the Noekeon cipher.
// It serves as the top-level entity, integrating all other sub-modules of the project.

module Noekeon(
 input wire    inClk,
 input wire    inReset,
 input wire    inMode,   // 0 - direct key, 1 - indirect key
 input wire    inDecipher,  // 0 - cipher, 1 - decipher
 input wire    inDataWr,
 input wire [127:0] inDataData,
 input wire    inKeyWr,
 input wire [127:0] inKeyData,
 output wire    outBusy,
 output wire [127:0] outData
);

wire   controlOutKeyWrCipher; // Loading key from DataOutReg
wire   controlOutKeyWrExt;    // Loading key from an external source
wire   controlOutResetKey;    // reset key register

wire   controlOutDataWrKey;  // Loading data from the key register
wire   controlOutDataWrExt;  // Loading data from an external source
wire   controlOutDataWrInt;  // Loading data from the round function module

wire   controlOutRegOutDataWr; // Loading data to output register from the round function module


// key
wire    controlOutIntDecipher;
wire [127:0] keyBeforeTheta;
wire [127:0] keyAfterTheta;

wire [4:0]  controlOutRoundCounter;
wire [7:0]  roundConstant;

// Data
wire [127:0] regDataData;
wire [127:0] LastRoundData;
wire [127:0] RoundData;

// Control
NoekeonControl noekeon_Control(
 .inClk(inClk),
 .inReset(inReset),
 .inMode(inMode),
 .inDecipher(inDecipher),
 .inDataWr(inDataWr),
 .inKeyWr(inKeyWr),
 .outBusy(outBusy),
 .outKeyWrCipher(controlOutKeyWrCipher), 
 .outKeyWrExt(controlOutKeyWrExt),  
 .outDataWrKey(controlOutDataWrKey),
 .outDataWrExt(controlOutDataWrExt),
 .outDataWrInt(controlOutDataWrInt),
 .outRoundCounter(controlOutRoundCounter),
 .outRegOutDataWr(controlOutRegOutDataWr),
 .outIntDecipher(controlOutIntDecipher),
 .outResetKey(controlOutResetKey)
);

// KeyReg
NoekeonKeyReg noekeon_KeyReg(
  .inClk(inClk),
  .inReset(controlOutResetKey),
  .inKeyWrExt(controlOutKeyWrExt),
  .inKeyDataExt(inKeyData),
  .inKeyWrInt(controlOutKeyWrCipher),
  .inKeyDataInt(LastRoundData),
  .outKey(keyBeforeTheta)
);

// DataReg
NoekeonDataReg noekeon_DataReg(
  .inClk(inClk),
  .inReset(inReset),
  .inDataWrKey(controlOutDataWrKey),
  .inDataDataKey(inKeyData),
  .inDataWrExt(controlOutDataWrExt),
  .inDataDataExt(inDataData),
  .inDataWrInt(controlOutDataWrInt),
  .inDataDataInt(RoundData),
  .outData(regDataData)
);

// RoundSH
NoekeonRoundSh noekeon_RoundSh(
  .inData(regDataData),
  .inKey(keyAfterTheta),
  .inRoundConst(roundConstant),
  .inDecipher(controlOutIntDecipher),
  .outData(RoundData)
);

// LastRoundSh
NoekeonLastRoundSh noekeon_LastRoundSh(
  .inData(regDataData),
  .inKey(keyAfterTheta),
  .inRoundConst(roundConstant),
  .inDecipher(controlOutIntDecipher),
  .outData(LastRoundData)
);

// DataOutReg
NoekeonDataOutReg noekeon_DataOutReg(
 .inClk(inClk),
  .inReset(inReset),
  .inData(LastRoundData),
  .inWr(controlOutRegOutDataWr),
 .outData(outData)
);

// ConstantBox
NoekeonConstantBox noekeon_ConstantBox(
  .inRoundCnt(controlOutRoundCounter),
 .outRoundConst(roundConstant)
);

// KeyTheta
NoekeonKeyTheta noekeon_KeyTheta(
  .inKey(keyBeforeTheta),
  .inDecipher(controlOutIntDecipher),
  .outKey(keyAfterTheta)
);

endmodule
