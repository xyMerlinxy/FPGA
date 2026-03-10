// The HMACSHA3384_1G module implements a hardware test suite for the HMACSHA3384 module on a development board.
// The HMACSHA3384_1G module generates control signals for the HMACSHA3384 unit and verifies the correctness 
// of the computed digests. Based on the verification results, it drives the outResult and outBusy output signals.

module HMACSHA3384_1G(
    input  wire         inClk,      // Clock signal input; active on the rising edge
    input  wire         inRst,      // Test module reset input; active high
    output wire         outResult,  // Digest verification result output (Pass/Fail)
    output wire         outBusy     // System busy status output; active high
);

reg  [831:0] regData = 832'h006867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a0908070605040302;
reg  [831:0] regKey  = 832'h006867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a0908070605040302;

reg regChange = 1'd1;

reg regKeyWr = 1'd0;
reg regKeyEnd = 1'd0;
reg regDataWr = 1'd0;
reg regDataEnd = 1'd0;

reg  [23:0] regCounter = 24'b0;

wire         HmacOutBusy;
wire [383:0] outHash;
wire outHashEnable;

reg regEndWorking = 1'd0;

reg    regOutBusy = 1'd1;

HMACSHA3384 hmacSha3384(
    .inClk(inClk),
    .inRst(inRst),
    .inDataData(regData),
    .inDataWr(regDataWr),
    .inDataEnd(regDataEnd),
    .inKeyData(regKey),
    .inKeyWr(regKeyWr),
    .inKeyEnd(regKeyEnd),
    .outHash(outHash),
    .outHashEnable(outHashEnable),
    .outBusy(HmacOutBusy)
);

wire [831:0] nextData;
wire [831:0] nextKey;

TestNextState384 testNextStateData(
   .inState(regData),
   .outState(nextData)
);
TestNextState384 testNextStateKey(
   .inState(regKey),
   .outState(nextKey)
);

always @ (posedge(inClk))
begin
   if ((HmacOutBusy == 1'b0)&(regChange == 1'b0)) begin
      if ((regCounter >= 24'd0) & (regCounter <= 24'd1)) begin
         regKey <= nextKey;
		 regKeyWr <= 1'd1;
      end
	  if (regCounter == 24'd2) begin
		 regKey <= 832'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
		 regKeyEnd <= 1'd1;
		 regKeyWr <= 1'd1;
	  end
	  
      if ((regCounter >= 24'd3) & (regCounter <= 24'd10324443)) begin
         regData <= nextData;
		 regDataWr <= 1'd1;
      end

	  
      if (regCounter == 24'd10324444) begin
         regData <= 832'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
		 regDataEnd <= 1'd1;
		 regDataWr <= 1'd1;
	  end
	  
      if (regCounter == 24'd10324445) begin
            regOutBusy <= 1'b0;
      end
      // increment counter only when module write data to HMAC module
      if (regOutBusy == 1'b1) begin
         regCounter <= regCounter+24'd1;
      end
	  regChange <= 1'd1;
   end else begin
       	regKeyEnd <= 1'd0;
		regKeyWr <= 1'd0;
		regDataEnd <= 1'd0;
		regDataWr <= 1'd0;
		regChange <= 1'd0;
   end
   
   if(outHash == 384'hb0e1a3660c0b632e9f1ed6008c49cee89717a35d5a2d2773380eabe878960a4d29da1c12bb57db32a24cb726d6fdfd75) begin
      regEndWorking <= 1'b1;
   end
end

assign outBusy = regOutBusy;
assign outCorrect = ((outHashEnable == 1'b1) & (regEndWorking==1'b1)) ? 1'b1 : 1'b0;

endmodule
