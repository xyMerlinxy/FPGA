module SHA3512Tb;

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


////////////////////////////////////////
reg      regReset = 1'b0;

reg      inDataWr   = 1'b0;
reg   [575:0]   inDataData   = 128'b0;
reg      inEnd   = 1'b0;
wire    [511:0]   outDataData;
wire      outBusy;

SHA3 #(.HASH_SIZE(512)
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
   inDataData = 576'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
  
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);

   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 576'b0;
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
   if(outDataData == 512'h26CD1D2886857501E3D3B6959D1900F558C53A2C40E9E3114CF9F5F13A12B215A6805C47C1DCD1E05958E24F1682C9976E755A18DC67B5C8C59A3AA2CC739FA6)
   begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   
   
   TEST = TEST + 1;
   //bit stream 11001
   inDataData = 576'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d3;
     
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 576'b0;
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
   if(outDataData == 512'h373F88249F2AE258B0DD8A91815E5E7999E0D53367BE53EBDC4B81E581144C5427CB61D9E406E0D2AD3C759D0370CE2121438C28702A620098C0144149013EA1)
   begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end

   TEST = TEST + 1;
   //bit stream a3*1600
   inDataData = 576'ha3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   
   inDataWr = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inDataData = 576'b0;
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
   
   inDataData = 576'ha3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   
   inDataWr = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inDataData = 576'b0;
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
   
   inDataData = 576'h80000000000000000000000000000006a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;

   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 576'b0;
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
   if(outDataData == 512'h00BAE81C5A54F66D41A8A4A11CC589E56BF42D9A73849565A352DF0AC3137C1BA8ECAE8CC45D80E4C0FDF3F5ED2876EC1B3658FA2FCF7F46B1A88420D2FA6DE7) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   TEST = TEST + 1;

   $stop;
end

endmodule
