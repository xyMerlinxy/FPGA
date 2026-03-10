// The HMACSHA3224_1G module implements a hardware test suite for the HMACSHA3224 module on a development board.
// The HMACSHA3224_1G module generates control signals for the HMACSHA3224 unit and verifies the correctness 
// of the computed digests. Based on the verification results, it drives the outResult and outBusy output signals.

module HMACSHA3224_1G(
    input  wire         inClk,      // Clock signal input; active on the rising edge
    input  wire         inRst,      // Test module reset input; active high
    output wire         outResult,  // Digest verification result output (Pass/Fail)
    output wire         outBusy     // System busy status output; active high
);

reg  [1151:0] regData = 1152'h00908f8e8d8c8b8a898887868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a0908070605040302;
reg  [1151:0] regKey  = 1152'h00908f8e8d8c8b8a898887868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a0908070605040302;

reg regChange = 1'd1;

reg regKeyWr = 1'd0;
reg regKeyEnd = 1'd0;
reg regDataWr = 1'd0;
reg regDataEnd = 1'd0;

reg  [23:0] regCounter = 24'b0;

wire         HmacOutBusy;
wire [223:0] outHash;
wire outHashEnable;

reg regResult = 1'd0;

reg regOutBusy = 1'd1;

HMACSHA3224 hmacSha3224(
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

wire [1151:0] nextData;
wire [1151:0] nextKey;

TestNextState224 testNextStateData(
   .inState(regData),
   .outState(nextData)
);

TestNextState224 testNextStateKey(
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
		 regKey <= 1152'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
		 regKeyEnd <= 1'd1;
		 regKeyWr <= 1'd1;
	  end
	  
      if ((regCounter >= 24'd3) & (regCounter <= 24'd7456543)) begin
         regData <= nextData;
		 regDataWr <= 1'd1;
      end
	  
      if (regCounter == 24'd7456544) begin
         regData <= 1152'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
		   regDataEnd <= 1'd1;
		 regDataWr <= 1'd1;
	   end
	  
      if (regCounter == 24'd7456545) begin
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
   
   if(outHash == 224'h471e57cb4acfab1ed8bd01643a8bbaf1ca2f08eeda84284e185d6cca) begin
      regResult <= 1'b1;
   end
end

assign outBusy = regOutBusy;
assign outResult = (regResult==1'b1) ? 1'b1 : 1'b0;

endmodule