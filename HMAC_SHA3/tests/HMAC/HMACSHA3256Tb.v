module HMACSHA3256Tb;
// The HMACSHA3256Tb module implements a testbench for verifying the HMACSHA3 module using the Questa simulator.
// The HMACSHA3256Tb module generates control signals for the HMACSHA3 unit and verifies the correctness of the computed HMAC digests.

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
reg [1087:0] regInDataData = 1088'b0;
reg          regInDataEnd  = 1'b0;
reg          regInKeyWr    = 1'b0;
reg [1087:0] regInKeyData  = 1088'b0;
reg          regInKeyEnd   = 1'b0;
wire [255:0] outDataData;
wire         outHashEnable;
wire         outBusy;

HMACSHA3 #(
  .HASH_SIZE(256)
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
    /* regInKeyData = 1088'h0;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData = 1088'b0;
    
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData = 1088'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData = 1088'b0;

    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 256'h8390a489d0350964f422e2c33a486cb2f100bc44f94ebbd5e044901b) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    ///// checking whether encryption with the same key will work
    TEST = TEST + 1;
    regInDataData = 1088'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData = 1088'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 256'h1dc122f62b664bb1514dc18e80a7baff2ffd2d9f636fc2dd10456f71) begin
        $display("TEST:%d OK HASH: %x",TEST,outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x",TEST, outDataData);
    end
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    //// checking whether encryption with the same key will work - version 2
    TEST = TEST + 1;
    regInDataData = 1088'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000062211;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData = 1088'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 256'h330676cfd146096af8abba36d6a3e8628246aeec9b98b892ce780aa39bece1cb) begin
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
    regInKeyData = 1088'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData = 1088'b0;

    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    
    regInDataData = 1088'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData = 1088'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 256'h330676cfd146096af8abba36d6a3e8628246aeec9b98b892ce780aa39bece1cb) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
    
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
    ///////////////// Size of key and message are equal to size of block in HMAC algorithm
    regInKeyData = 1088'h87868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData = 1088'b0;

    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData = 1088'h87868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataData = 1088'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);

    regInDataData = 1088'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData = 1088'b0;
	
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 256'h4e0c53ba9a1b60720e2910192a4192f1c500873e1a9e36149a5d9e036d001bec) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
   
   
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
    ///////////////// Size of key and message are bigger than size of block in HMAC algorithm
    regInKeyData = 1088'h87868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyData = 1088'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInKeyData = 1088'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000069b9a999897969594939291908f8e8d8c8b8a8988;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData = 1088'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData = 1088'h87868584838281807f7e7d7c7b7a797877767574737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataData = 1088'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData = 1088'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000069b9a999897969594939291908f8e8d8c8b8a8988;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData = 1088'b0;
	
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    
    if(outDataData == 256'h4852174c205df7387d0c1aa5dcbef96472c580b9fff9a33fa4855e021a0d4f9e) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
	wait(outBusy == 1'b0 && regInClk == 1'b0);
   $stop;
end

endmodule
