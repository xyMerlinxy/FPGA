module SHA3384Tb;

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
reg   [831:0]   inDataData   = 128'b0;
reg      inEnd   = 1'b0;
wire    [383:0]   outDataData;
wire      outBusy;

SHA3 #(.HASH_SIZE(384)
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
   inDataData = 832'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
  
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 832'b0;
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
   if(outDataData == 384'h04F0D558E0D16BFB47DB4A26313871C32A3A98EEBB715E9961FC94AAAA501AC585244C2E857D10017D4F5E845BA7630C) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   
   
   TEST = TEST + 1;
   //bit stream 11001
   inDataData = 832'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d3;
     
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 832'b0;
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
   if(outDataData == 384'h641C1B17EF7F236B4B9B779FCE1DEB55640A6A6B232C3F4748E1C3713465A9DCF87B1A7492E72874BFE98518499B7C73) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end

   TEST = TEST + 1;
   //bit stream a3*1600
   inDataData = 832'ha3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   
   inDataWr = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inDataData = 832'b0;
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
   
   inDataData = 832'h8000000000000006a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;

   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 832'b0;
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
   if(outDataData == 384'h8F3E47DD50702D9F98EE55FD317A1976DDBC1DCE492673D18E16742BE4C19C182B005F8F2B73C45DF91EE4A72CDE8118) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   TEST = TEST + 1;

   $stop;
end

endmodule
