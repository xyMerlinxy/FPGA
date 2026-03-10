module HMACSHA3512Tb;
// The HMACSHA3512Tb module implements a testbench for verifying the HMACSHA3 module using the Questa simulator.
// The HMACSHA3512Tb module generates control signals for the HMACSHA3 unit and verifies the correctness of the computed HMAC digests.

reg [7:0] TEST = 8'b0;
/////////////////////////////////////////

parameter inClkp = 10;
reg       regInClk  = 1'b0;

always
begin
    #(inClkp/2) regInClk = !regInClk;
end

////////////////////////////////////////
reg   regReset = 1'b0;

reg          regInDataWr   = 1'b0;
reg [ 575:0] regInDataData =  576'b0;
reg          regInDataEnd  = 1'b0;

reg          regInKeyWr    = 1'b0;
reg [ 575:0] regInKeyData  =  576'b0;
reg          regInKeyEnd   = 1'b0;

wire [511:0] outDataData;
wire         outHashEnable;
wire         outBusy;

HMACSHA3 #(
  .HASH_SIZE(512)
) hmacSha3(
    .inClk(regInClk),
    .inRst(regReset),
    .inDataData(regInDataData),
    .inDataWr(regInDataWr),
    .inDataEnd(regInDataEnd),
    .inKeyData(regInKeyData),
    .inKeyWr(regInKeyWr),
    .inKeyEnd(regInKeyEnd),
    .outHash(outDataData),
	.outHashEnable(outHashEnable),
    .outBusy(outBusy)
);

always
begin
   #(inClkp);
    /////// empty key and empty message
    /* regInKeyData =  576'h0;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  576'b0;
    
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  576'b0;

    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 512'h8390a489d0350964f422e2c33a486cb2f100bc44f94ebbd5e044901b) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    ///// checking whether encryption with the same key will work
    TEST = TEST + 1;
    regInDataData =  576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  576'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 512'h1dc122f62b664bb1514dc18e80a7baff2ffd2d9f636fc2dd10456f71) begin
        $display("TEST:%d OK HASH: %x",TEST,outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x",TEST, outDataData);
    end
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    //// checking whether encryption with the same key will work - version 2
    TEST = TEST + 1;
    regInDataData =  576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000062211;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  576'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 512'h6b8923457577b81a775eb1fe4b57cf13f1e63f3be21f88d7ed43b44b) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
    
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
   
    #(inClkp);
    wait(outBusy == 1'b0 && regInClk == 1'b0); */
    ///////////////// Size of key and message are smaller than size of block in HMAC algorithm
    regInKeyData =  576'h000000000000000000000000000000000000000000000000000000000000000000000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  576'b0;

    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    
    regInDataData =  576'h800000000000000000000000000000000000000000000000000000000000000000000000000000061f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  576'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 512'h3f798c153b17686aeb5602604ffe43f00a27dc6d6106641f76b775f389f37c71ee9f23f4aa2608cc2fdf0cdf7bb1ce11570bff8e030628d96c8fbd768c814715) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
    
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
    ///////////////// Size of key and message are equal to size of block in HMAC algorithm
    regInKeyData =  576'h47464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  576'b0;

    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  576'h47464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataData =  576'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);

    regInDataData =  576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  576'b0;
	
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 512'h18a0867136253e08ede3f09abc9b024451fa39c05001ca5d83b85524387cd49be37195cf79b51276b21b45128b185bd38498e5060ad0a7733dd72cf3767909df) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
   
   
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
    ///////////////// Size of key and message are bigger than size of block in HMAC algorithm
    regInKeyData =  576'h47464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyData =  576'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInKeyData =  576'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065f5e5d5c5b5a595857565554535251504f4e4d4c4b4a4948;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  576'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  576'h47464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataData =  576'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  576'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065f5e5d5c5b5a595857565554535251504f4e4d4c4b4a4948;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  576'b0;
	
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    
    if(outDataData == 512'h45bec6539f9ab8510a8c52cd93fa00c1c8a31891bd1651ad240a345fb5c490df447340e3b9778643b9a25dad76f01a8f873f41633b3938558e9fa895975bae3d) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
	wait(outBusy == 1'b0 && regInClk == 1'b0);
   $stop;
end

endmodule
