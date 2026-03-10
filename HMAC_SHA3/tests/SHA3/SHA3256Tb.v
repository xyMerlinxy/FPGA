module SHA3256Tb;

reg   [7:0]   TEST = 8'b0;
reg regPrint = 1'b0; // Debugging: Prints the current state register (regState) after each operation/transition
integer i;
/////////////////////////////////////////

parameter   inClkp = 10;
reg         inClk  = 1'b0;

always
begin
    #(inClkp/2) inClk = !inClk;
end

/////////////////////////////////////////



////////////////////////////////////////
reg      regReset = 1'b0;

reg      inDataWr   = 1'b0;
reg   [1087:0]   inDataData   = 128'b0;
reg      inEnd   = 1'b0;
wire    [255:0]   outDataData;
wire      outBusy;

SHA3 #(.HASH_SIZE(256)
) Sha3(
   .inClk(inClk),
   .inRst(regReset),
   .inDataWr(inDataWr),
   .inEnd(inEnd),
   .inDataData(inDataData),
   .outBusy(outBusy),
   .outDataData(outDataData)
);

always
begin
   
   //empty string
   inDataData = 1088'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
  
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 1088'b0;
   if(regPrint==1'b1) begin
      $display("reg: %x", Sha3.instSha3RegData.regData);
   end
   //wait(outBusy == 1'b0 && inClk == 1'b0);
   while(outBusy == 1'b1) begin
      wait(inClk == 1'b1);
      if(regPrint==1'b1) begin
         $display("Round: %d", Sha3.wireControlOutRoundCnt);
         $display("Round IN: %x", Sha3.instSha3Rnd.inState);
         $display("Af Theta: %x", Sha3.instSha3Rnd.temp1);
         $display("Af Rho: %x", Sha3.instSha3Rnd.temp2);
         $display("Af Pi: %x", Sha3.instSha3Rnd.temp3);
         $display("Af Chi: %x", Sha3.instSha3Rnd.temp4);
         $display("Round OUT: %x", Sha3.instSha3Rnd.outState);
      end

      wait(inClk == 1'b0);
   end
   wait(outBusy == 1'b0 && inClk == 1'b0);
   if(outDataData == 256'h4A43F8804B0AD882FA493BE44DFF80F562D661A05647C15166D71EBFF8C6FFA7) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   
   
   TEST = TEST + 1;
   //bit stream 11001
   inDataData = 1088'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d3;
     
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 1087'b0;
   if(regPrint==1'b1) begin
      $display("reg: %x", Sha3.instSha3RegData.regData);
   end
   //wait(outBusy == 1'b0 && inClk == 1'b0);
   while(outBusy == 1'b1) begin
      wait(inClk == 1'b1);
      if(regPrint==1'b1) begin
         $display("Round: %d", Sha3.wireControlOutRoundCnt);
         $display("Round IN: %x", Sha3.instSha3Rnd.inState);
         $display("Af Theta: %x", Sha3.instSha3Rnd.temp1);
         $display("Af Rho: %x", Sha3.instSha3Rnd.temp2);
         $display("Af Pi: %x", Sha3.instSha3Rnd.temp3);
         $display("Af Chi: %x", Sha3.instSha3Rnd.temp4);
         $display("Round OUT: %x", Sha3.instSha3Rnd.outState);
      end

      wait(inClk == 1'b0);
   end
   wait(outBusy == 1'b0 && inClk == 1'b0);
   if(outDataData == 256'hAF57D9B5E33201835E36469A05B7F465CF2253B00FBF3C368268455ACF47007B) begin
      $display("OK TEST:%d. Hash: $x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end

   TEST = TEST + 1;
   //bit stream a3*1600
   inDataData = 1088'ha3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   
   inDataWr = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inDataData = 1088'b0;
   if(regPrint==1'b1) begin
      $display("reg: %x", Sha3.instSha3RegData.regData);
   end
   //wait(outBusy == 1'b0 && inClk == 1'b0);
   while(outBusy == 1'b1) begin
      wait(inClk == 1'b1);
      if(regPrint==1'b1) begin
         $display("Round: %d", Sha3.wireControlOutRoundCnt);
         $display("Round IN: %x", Sha3.instSha3Rnd.inState);
         $display("Af Theta: %x", Sha3.instSha3Rnd.temp1);
         $display("Af Rho: %x", Sha3.instSha3Rnd.temp2);
         $display("Af Pi: %x", Sha3.instSha3Rnd.temp3);
         $display("Af Chi: %x", Sha3.instSha3Rnd.temp4);
         $display("Round OUT: %x", Sha3.instSha3Rnd.outState);
      end
      wait(inClk == 1'b0);
   end
   wait(outBusy == 1'b0 && inClk == 1'b0);
   
   inDataData = 1088'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   //              h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;

   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 1088'b0;
   if(regPrint==1'b1) begin
      $display("reg: %x", Sha3.instSha3RegData.regData);
   end
   //wait(outBusy == 1'b0 && inClk == 1'b0);
   while(outBusy == 1'b1) begin
      wait(inClk == 1'b1);
      if(regPrint==1'b1) begin
         $display("Round: %d", Sha3.wireControlOutRoundCnt);
         $display("Round IN: %x", Sha3.instSha3Rnd.inState);
         $display("Af Theta: %x", Sha3.instSha3Rnd.temp1);
         $display("Af Rho: %x", Sha3.instSha3Rnd.temp2);
         $display("Af Pi: %x", Sha3.instSha3Rnd.temp3);
         $display("Af Chi: %x", Sha3.instSha3Rnd.temp4);
         $display("Round OUT: %x", Sha3.instSha3Rnd.outState);
      end
      wait(inClk == 1'b0);
   end
   wait(outBusy == 1'b0 && inClk == 1'b0);

   wait(outBusy == 1'b0 && inClk == 1'b0);
   if(outDataData == 256'h8717E39DBDA15FC673392EB281FD6CD4BFAF24836EF78EA90703C2C5DE8AF379) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   TEST = TEST + 1;

   $stop;
end

endmodule
