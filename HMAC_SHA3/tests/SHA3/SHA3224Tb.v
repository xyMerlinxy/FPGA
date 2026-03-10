module SHA3224Tb;

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
reg   [1151:0]   inDataData   = 128'b0;
reg      inEnd   = 1'b0;
wire    [223:0]   outDataData;
wire      outBusy;

SHA3 #(.HASH_SIZE(224)
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
   inDataData = 1152'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006;
  
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 1152'b0;
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
   if(outDataData == 224'hc76b5a5b3f8e071b9a7f59d4abb10e4f45156e3bb7db673642034e6b) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   
   
   TEST = TEST + 1;
   //bit stream 11001
   inDataData = 1152'h8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d3;
     
   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 1152'b0;
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
   if(outDataData == 224'hab74964801336bca2db3b1aeec6867dc0602338917d7ba96dad5baff) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end

   TEST = TEST + 1;
   //bit stream a3*1600
   // inDataData = 1152'ha3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   inDataData = 1152'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006636261;

   // inDataWr = 1'b1;
   @(posedge inClk);
   // inDataWr = 1'b0; inDataData = 1152'b0;
   // if(regPrint==1'b1) begin
      // $display("reg: %x", Sha3.instSha3RegData.regData);
   // end
   // //wait(outBusy == 1'b0 && inClk == 1'b0);
   // while(outBusy == 1'b1) begin
      // wait(inClk == 1'b1);
      // if(regPrint==1'b1) begin
         // $display("Round: %d", Sha3.wireControlOutRoundCnt);
         // $display("Round IN: %x", Sha3.instSha3Rnd.inState);
         // $display("Af Theta: %x", Sha3.instSha3Rnd.temp1);
         // $display("Af Rho: %x", Sha3.instSha3Rnd.temp2);
         // $display("Af Pi: %x", Sha3.instSha3Rnd.temp3);
         // $display("Af Chi: %x", Sha3.instSha3Rnd.temp4);
         // $display("Round OUT: %x", Sha3.instSha3Rnd.outState);
      // end
      // wait(inClk == 1'b0);
   // end
   // wait(outBusy == 1'b0 && inClk == 1'b0);
   
   // inDataData = 1152'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;
   // //              h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3;

   inDataWr = 1'b1; inEnd = 1'b1;
   @(posedge inClk);
   inDataWr = 1'b0; inEnd = 1'b0; inDataData = 1152'b0;
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
   if(outDataData == 224'hdf6fb473ad940c8d16a5a3c96f763c7dee3492d04af28c3f4c8242e6) begin
      $display("OK TEST:%d. Hash: %x",TEST,outDataData);
   end else begin
      $display("FAIL TEST:%d. Hash: %x",TEST,outDataData);
   end
   TEST = TEST + 1;

   $stop;
end

endmodule
