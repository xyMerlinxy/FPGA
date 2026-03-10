// The HMACSHA3Control module implements the control unit for the HMAC-SHA3 coprocessor.
// The HMACSHA3Control module manages the control signals for all internal components of the algorithm's coprocessor.

module HMACSHA3Control(
  input  wire      inClk,           // Clock input, active on the rising edge
  input  wire      inRst,           // Reset input for initial state restoration, active high
  input  wire      inDataWr,        // Data write enable for hashing, active high
  input  wire      inDataEnd,       // End-of-message signal, initiates final hash computation
  input  wire      inKeyWr,         // Key write enable, active high
  input  wire      inKeyEnd,        // End-of-key entry signal, initiates end of key
  input  wire      inShaBusy,       // SHA3 module busy status input
  output wire      outBusy,         // System busy status output, active high
  
  // SHA3 module control signals
  output wire      outHashDataEnd,  // End-of-data signal for the SHA3 core

  output reg [2:0] outSelectData,   // Mux select signal for data path routing
  output reg       outHashWr,       // SHA3 core write enable

  output wire      outEnableHash,   // Hash output valid signal (asserts outHashEnable and enables outHash bus)
  
  // Key register control signals
  output wire      outRegKeyExtWr,  // External key write enable (from inKeyData to RegKey), active high
  output wire      outRegKeyInIntWr // Internal key write enable (from wireHashOutData to RegKey), active high
);

// The HMACSHA3Control module is implemented as a Finite State Machine (FSM).
// The current state is stored in the regState register.
// Internal state definitions:
// - 0: Idle / Waiting for key entry via the inKeyWr signal;
// - 1: Receiving subsequent key data blocks;
// - 2: Storing the processed key from the SHA3 module output;
// - 3: Feeding IpadKey data into the SHA3 core;
// - 4: Receiving message data blocks;
// - 5: Feeding OpadKey data into the SHA3 core;
// - 6: Feeding the intermediate hash H((K_0 ^ ipad) || text) into the SHA3 core;
// - 7: Asserting the final HMAC digest on the output bus.

reg [2:0] regState = 3'd0;    // Register storing the current state of the Finite State Machine (FSM)
reg       regOutEnable = 1'd0; // Register storing the flag for asserting the HMAC digest on the output

always @(posedge(inClk))
begin
  if(inRst == 1'b1) begin
    regState = 3'd0;
    regOutEnable = 1'd0;
  end
  case (regState)
    3'd0: begin
     if (inKeyWr == 1'b1) begin
      if (inKeyEnd == 1'b0) begin
        regState <= 3'd1; // go to hash key
      end else begin
        regState <= 3'd3; // go to hash opadKey
      end
     end
    end
    3'd1: begin
      // last key data block, go to waiting for key hash
      if ((inKeyWr == 1'b1)&(inShaBusy == 1'b0)&(inKeyEnd == 1'b1)) begin
        regState <= 3'd2;
      end
    end
    3'd2: begin
      // Wait for the key hash to be computed, 
      // then store the resulting key.
      if(inShaBusy == 1'b0) begin
        regState <= 3'd3;
      end
    end
    3'd3: begin
      // put ipad to hash module
      if(inShaBusy == 1'b0) begin
        regState <= 3'd4;
      end
    end
    3'd4: begin
		  // message hash
      if(inDataWr == 1'b1) begin
        regOutEnable <=1'b0;
      end
      if ((inDataWr == 1'b1)&(inShaBusy == 1'b0)&(inDataEnd == 1'b1)) begin
        regState <= 3'd5;
      end
    end
    3'd5: begin
    // put opad to hash module
    if(inShaBusy == 1'b0) begin
        regState <= 3'd6;
      end
    end
    3'd6: begin
    // Feeding the intermediate hash back into the sponge for the second pass
    if(inShaBusy == 1'b0) begin
        regState <= 3'd7;
      end
    end
    3'd7: begin
    // loading hash to output register
    if(inShaBusy == 1'b0) begin
        regState <= 3'd3;
        regOutEnable <= 1'b1;
      end
    end
   endcase
end

assign outRegKeyExtWr = ((inKeyWr == 1'b1)&(inKeyEnd == 1'b1)&(regState == 3'd0)) ? 1'b1 : 1'b0;
assign outRegKeyInIntWr = ((regState == 3'd2)&(inShaBusy == 1'b0)) ? 1'b1 : 1'b0;

always @(*) begin
  case (regState)
    3'd0: outHashWr = ((inKeyWr == 1'b1)&(inKeyEnd == 1'b0))? 1'b1:1'b0;
    3'd1: outHashWr = ((inKeyWr == 1'b1)&(inShaBusy==1'b0)) ? 1'b1:1'b0;
    // 3'd2: outHashWr = 
    3'd3, 3'd5, 3'd6: outHashWr = ~inShaBusy;
    3'd4: outHashWr = ((inShaBusy == 1'b0)&(inDataWr == 1'b1))? 1'b1: 1'b0;
    // 3'd5: outHashWr = ~inShaBusy;
    // 3'd6: outHashWr = ~inShaBusy;
    // 3'd7: outHashWr =
    default: outHashWr = 1'b0;
  endcase
end

always @(*) begin
  case (regState)
    3'd0: outSelectData = 3'd1;
    3'd1: outSelectData = 3'd1;
    // 3'd2: outSelectData = 3'd2;
    3'd3: outSelectData = 3'd2;
    3'd4: outSelectData = 3'd0;
    3'd5: outSelectData = 3'd3;
    3'd6: outSelectData = 3'd4;
    // 3'd7: outSelectData =
    default: outSelectData = 3'd0;
  endcase
end

assign outBusy = (((regState == 3'd0)|(regState == 3'd1)|(regState == 3'd4))&
                    inShaBusy!=1'b1)? 1'b0: 1'b1;

assign outEnableHash = regOutEnable;

assign outHashDataEnd = (((inKeyWr == 1'b1)&(inShaBusy == 1'b0)&(inKeyEnd == 1'b1)&(regState == 3'd1))|  // end of key loading
                        ((inDataWr == 1'b1)&(inShaBusy == 1'b0)&(inDataEnd == 1'b1)&(regState == 3'd4))| // end of data loading
                        ((regState == 3'd6)&(inShaBusy == 1'b0))) ? 1'b1: 1'b0;  // at the end second pass

endmodule