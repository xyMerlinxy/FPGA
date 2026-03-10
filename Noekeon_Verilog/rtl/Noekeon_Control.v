// This module serves as the top-level controller for the sub-modules within the Noekeon core.
// It is implemented as a Finite State Machine (FSM).

// During key loading, set 'inMode' to select the operational mode: 0 - direct or 1 - indirect.
// During data loading, set 'inDecipher' to select the process: 0 - encryption, 1 - decryption.

module NoekeonControl(
  input wire        inClk,
  input wire        inReset,
  input wire        inMode,      // 0 - directed key, 1 - indirect key
  input wire        inDecipher,    // 0 - decryption, 1 - encryption
  input wire        inDataWr,
  input wire        inKeyWr,
  output wire        outBusy,

  // Key register management
  output wire        outKeyWrCipher, // Loading key from DataOutReg
  output wire        outKeyWrExt,    // Loading key from an external source
  output wire        outResetKey,    // reset key register
  
  // Data register management
  output wire        outDataWrKey,  // Loading data from the key register
  output wire        outDataWrExt,  // Loading data from an external source
  output wire       outDataWrInt,   // Loading data from the round function module
  
  output wire  [4:0]    outRoundCounter,  // round counter
  
  output wire        outRegOutDataWr,  // Loading data to output register from the round function module

  output wire        outIntDecipher

);

// States:
// 0 - Idle (Waiting)
// 1 - Encryption
// 2 - Final round of key encryption
// 3 - Final round of message encryption
// 4 - Decryption
// 5 - Final round of decryption

reg  [4:0]    regRoundCnt; 
reg  [2:0]    regState = 3'd0;
reg        regMode = 1'd0;
reg        regDecipher = 1'd0;

always @(posedge(inClk) or posedge(inReset)) begin
  if(inReset == 1'b1) begin
    regRoundCnt = 5'b0; 
    regState = 3'd0;
    regMode = 1'd0;
    regDecipher = 1'd0;
  end else begin
    case(regState)
      3'd0 :  begin
              // indirect key
              if((inKeyWr == 1'b1) & (inMode == 1'b1)) begin
                regState = 3'd1;
                regRoundCnt = 5'b0;
                regDecipher = 1'b0;
                regMode = 1'b1;
              end else begin
                if(inDataWr == 1'b1) begin
                  regMode = 1'b0;
                  // encrypt
                  if(inDecipher == 1'b0) begin
                    regState = 3'd1;
                    regDecipher = 1'b0;
                    regRoundCnt = 5'b0;
                  // decrypt
                  end else begin
                    regState = 3'd4;
                    regDecipher = 1'b1;
                    regRoundCnt = 5'd16;
                  end
                end
              end
            end
            
      3'd1 :  begin
              if(regRoundCnt < 5'd15) begin
                regRoundCnt = regRoundCnt + 5'd1;
              end else begin
                if(regMode == 1'b1) begin
                  regState = 3'd2;
                  regRoundCnt = regRoundCnt + 5'd1;
                end else begin
                  regState = 3'd3;
                  regRoundCnt = regRoundCnt + 5'd1;
                end
                
              end
            end
      3'd2 :  begin
              regState = 3'd0;
            end
      3'd3 :  begin
              regState = 3'd0;
            end
      3'd4 :  begin
              if(regRoundCnt > 5'd1) begin
                regRoundCnt = regRoundCnt - 5'd1;
              end else begin
                regState = 3'd5;
                regRoundCnt = regRoundCnt - 5'd1;
              end
            end
      3'd5 :  begin
              regState = 3'd0;
            end
    endcase
  end
end

assign outRoundCounter = regRoundCnt;

assign outKeyWrExt = ((regState == 3'd0) & (inKeyWr==1'b1) & (inMode==1'b0)) ? 1'b1 : 1'b0;

assign outDataWrKey = ((regState == 3'd0) & (inKeyWr==1'b1) & (inMode==1'b1)) ? 1'b1 : 1'b0;

assign outKeyWrCipher = (regState == 3'd2) ? 1'b1 : 1'b0;

assign outRegOutDataWr = ((regState == 3'd3) | (regState == 3'd5)) ? 1'b1 : 1'b0;

assign outDataWrInt = ((regState == 3'd1) | (regState == 3'd4)) ? 1'b1 : 1'b0;

assign outIntDecipher = regDecipher;

assign outDataWrExt = ((regState == 3'd0) & (inDataWr==1'b1)) ? 1'b1 : 1'b0;

assign outBusy = (regState == 3'd0) ? 1'b0 : 1'b1;

assign outResetKey = ((inReset == 1'b1) | ((regState == 3'd0) & (inKeyWr == 1'b1) & (inMode == 1'b1))) ? 1'b1 : 1'b0;

endmodule
