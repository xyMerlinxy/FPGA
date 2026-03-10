module HMACSHA3384Tb;
// The HMACSHA3384Tb module implements a testbench for verifying the HMACSHA3 module using the Questa simulator.
// The HMACSHA3384Tb module generates control signals for the HMACSHA3 unit and verifies the correctness of the computed HMAC digests.

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
reg [ 831:0] regInDataData =  832'b0;
reg          regInDataEnd  = 1'b0;

reg          regInKeyWr    = 1'b0;
reg [ 831:0] regInKeyData  =  832'b0;
reg          regInKeyEnd   = 1'b0;

wire [383:0] outDataData;
wire         outHashEnable;
wire         outBusy;


HMACSHA3 #(
  .HASH_SIZE(384)
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
    /* regInKeyData =  832'h0;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  832'b0;
    
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  832'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  832'b0;

    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 384'h8390a489d0350964f422e2c33a486cb2f100bc44f94ebbd5e044901b) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    ///// checking whether encryption with the same key will work
    TEST = TEST + 1;
    regInDataData =  832'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  832'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 384'h1dc122f62b664bb1514dc18e80a7baff2ffd2d9f636fc2dd10456f71) begin
        $display("TEST:%d OK HASH: %x",TEST,outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x",TEST, outDataData);
    end
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    //// checking whether encryption with the same key will work - version 2
    TEST = TEST + 1;
    regInDataData =  832'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000062211;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  832'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 384'h6b8923483177b81a775eb1fe4b57cf13f1e63f3be21f88d7ed43b44b) begin
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
    regInKeyData =  832'h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  832'b0;

    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    
    regInDataData =  832'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  832'b0;
   
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 384'hb30d2263ff2f8f27c1c3f3b7a64f8d976e48c4d52572a09c13ff9a78d15fc55e418c2b2622dad2ab75f8d6f7cb796897) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
    
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
    ///////////////// Size of key and message are equal to size of block in HMAC algorithm
    regInKeyData =  832'h67666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  832'b0;

    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  832'h67666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataData =  832'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);

    regInDataData =  832'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  832'b0;
	
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    if(outDataData == 384'hd65da97d27fd94312f2bd45aa7efcb75093db8a73f6dcb2e5bcfd0af75a466c4679e938509df58310d302e29aa1ab07d) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
   
   
    regReset=1'b1;#(inClkp);
    regReset=1'b0;#(inClkp);
    TEST = TEST + 1;
    ///////////////// Size of key and message are bigger than size of block in HMAC algorithm
    regInKeyData =  832'h67666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInKeyWr = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyData =  832'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInKeyData =  832'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000067f7e7d7c7b7a797877767574737271706f6e6d6c6b6a6968;
    regInKeyWr = 1'b1; regInKeyEnd = 1'b1; #(inClkp);
    regInKeyWr = 1'b0; regInKeyEnd = 1'b0; regInKeyData =  832'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  832'h67666564636261605f5e5d5c5b5a595857565554535251504f4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a292827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    regInDataWr = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataData =  832'b0;
	
    wait(outBusy == 1'b0 && regInClk == 1'b0);
    
    regInDataData =  832'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000067f7e7d7c7b7a797877767574737271706f6e6d6c6b6a6968;
    regInDataWr = 1'b1; regInDataEnd = 1'b1; #(inClkp);
    regInDataWr = 1'b0; regInDataEnd = 1'b0; regInDataData =  832'b0;
	
    wait(outHashEnable == 1'b1 && regInClk == 1'b0);
    
    if(outDataData == 384'hb341da3658d01481f1dbd1daffbf7aeafad15d2870dbd5244230e4ff400c3baf6959d2f7e8683999c15bd4cd56c79ac8) begin
        $display("TEST:%d OK HASH: %x", TEST, outDataData);
    end else begin
        $display("TEST:%d FAIL HASH: %x", TEST, outDataData);
    end
	wait(outBusy == 1'b0 && regInClk == 1'b0);
   $stop;
end

endmodule
