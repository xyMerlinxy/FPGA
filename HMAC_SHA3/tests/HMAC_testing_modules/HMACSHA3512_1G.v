// The HMACSHA3512_1G module implements a hardware test suite for the HMACSHA512 module on a development board.
// The HMACSHA3512_1G module generates control signals for the HMACSHA512 unit and verifies the correctness 
// of the computed digests. Based on the verification results, it drives the outResult and outBusy output signals.

module HMACSHA3512_1G(
    input  wire         inClk,      // Clock signal input; active on the rising edge
    input  wire         inRst,      // Test module reset input; active high
    output wire         outResult,  // Digest verification result output (Pass/Fail)
    output wire         outBusy     // System busy status output; active high
);

reg  [575:0] regData = 576'h004847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a0908070605040302;
reg  [575:0] regKey  = 576'h004847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a0908070605040302;

reg regChange = 1'd1;

reg regKeyWr = 1'd0;
reg regKeyEnd = 1'd0;
reg regDataWr = 1'd0;
reg regDataEnd = 1'd0;

reg  [23:0] regCounter = 24'b0;

wire         HmacOutBusy;
wire [511:0] outHash;
wire outHashEnable;

reg regEndWorking = 1'd0;

reg    regOutBusy = 1'd1;

HMACSHA3512 hmacSha3512(
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

wire [575:0] nextData;
wire [575:0] nextKey;

TestNextState512 testNextStateData(
   .inState(regData),
   .outState(nextData)
);
TestNextState512 testNextStateKey(
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
		 regKey <= 576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
		 regKeyEnd <= 1'd1;
		 regKeyWr <= 1'd1;
	  end
	  
      if ((regCounter >= 24'd3) & (regCounter <= 24'd14913083)) begin
         regData <= nextData;
		 regDataWr <= 1'd1;
      end

	  
      if (regCounter == 24'd14913084) begin
         regData <= 576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
		 regDataEnd <= 1'd1;
		 regDataWr <= 1'd1;
	  end
	  
      if (regCounter == 24'd14913085) begin
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
   
   if(outHash == 512'h07fc23432e8ac36148fc38dfc8e76fec5e5df7c3226148d649e5b7311b9fd58c8a4dea90140ded043ccbb4895d9e533ce9cc21005a8b654c728d19f687921b7b) begin
      regEndWorking <= 1'b1;
   end
end

assign outBusy = regOutBusy;
assign outCorrect = ((outHashEnable == 1'b1) & (regEndWorking==1'b1)) ? 1'b1 : 1'b0;

endmodule
