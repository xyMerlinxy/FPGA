module NoekeonTb;

reg  [7:0]  TEST = 8'b0;
integer i;
/////////////////////////////////////////

parameter   inClk_p = 10;
reg         inClk  = 1'b0;

always
begin
    #(inClk_p/2) inClk = !inClk;
end

/////////////////////////////////////////
reg    regReset = 1'b0;
reg    regMode = 1'b0;
reg    regDecipher = 1'b0;

reg    inDataWr  = 1'b0;
reg  [127:0]  inDataData  = 128'b0;
reg    inKeyWr    = 1'b0;
reg  [127:0]  inKeyData  = 128'b0;

wire   [127:0]  outDataData;
wire    outBusy;

Noekeon noekeon(
  .inClk(inClk),
  .inReset(regReset),
  .inMode(regMode),
  .inDecipher(regDecipher),
  .inDataWr(inDataWr),
  .inDataData(inDataData),
  .inKeyWr(inKeyWr),
  .inKeyData(inKeyData),
  .outBusy(outBusy),
  .outData(outDataData)
);

always
begin

// directed mode
    TEST = TEST + 1;
    regMode = 1'b0; regDecipher = 1'b0;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = 128'b0;
    @(posedge inClk);
    inDataWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'h503D2DFC24B70148699E29FAB1656851) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d Cipher OK", TEST);
        $display("Result: %h", outDataData);
    end 

    TEST = TEST + 1;
    regMode = 1'b0; regDecipher = 1'b1;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = outDataData;
    @(posedge inClk);
    inDataWr = 1'b0;
    
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'h0) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d Decipher OK", TEST);
        $display("Result: %h", outDataData);
    end 
    

// indirect mode
    TEST = TEST + 1;
    regMode = 1'b1; regDecipher = 1'b0;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = 128'b0;
    @(posedge inClk);
    inDataWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'hF678178B99A99F089299C716BA693381) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d Indirect Encrypt OK", TEST);
        $display("Result: %h", outDataData);
    end 

    TEST = TEST + 1;
    regMode = 1'b1; regDecipher = 1'b1;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = outDataData;
    @(posedge inClk);
    inDataWr = 1'b0;
    
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'h0) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d Indirect Decrypt OK", TEST);
        $display("Result: %h", outDataData);
    end 

  // resetTest - encryption should execute correctly following a reset
  TEST = TEST + 1;
    regMode = 1'b1; regDecipher = 1'b0;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = 128'b0;
    @(posedge inClk);
    inDataWr = 1'b0;

    @(posedge inClk);
    @(posedge inClk);
    @(posedge inClk);
    @(posedge inClk);

  regReset = 1'b1;
    @(posedge inClk);
  regReset = 1'b0;
    @(posedge inClk);
  
  regMode = 1'b1; regDecipher = 1'b0;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = 128'b0;
    @(posedge inClk);
    inDataWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'hF678178B99A99F089299C716BA693381) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d Reset test OK", TEST);
        $display("Result: %h", outDataData);
    end 
   
// indirect encrypt without key write
    TEST = TEST + 1;
    regMode = 1'b1; regDecipher = 1'b0;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'hF678178B99A99F089299C716BA693381;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = 128'h5011C7D8DF7B6FAA283C1F7B52F88A7B;
    @(posedge inClk);
    inDataWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'hC277FA70D9495515C82AE6E25096F2BF) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d  Indirect Encrypt v2 OK", TEST);
        $display("Result: %h", outDataData);
    end 

    TEST = TEST + 1;
    regMode = 1'b1; regDecipher = 1'b1;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);

    inDataWr = 1'b1; inDataData = outDataData;
    @(posedge inClk);
    inDataWr = 1'b0;
    
    wait(outBusy == 1'b0 && inClk == 1'b0);
  
    if (outDataData != 128'h5011C7D8DF7B6FAA283C1F7B52F88A7B) begin
        $display("TEST: %3d Error\n", TEST);
        $stop;
    end else begin
        $display("TEST: %3d Indirect Decrypt - Same key OK", TEST);
        $display("Result: %h", outDataData);
    end
   
    // 10 times test

    TEST = TEST + 1;
    regMode = 1'b1; regDecipher = 1'b0;
    inKeyWr = 1'b0; inKeyData = 128'b0;
    inDataWr = 1'b0; inDataData = 128'b0;
    @(posedge inClk);
    inKeyWr = 1'b1; inKeyData = 128'hF678178B99A99F089299C716BA693381;
    @(posedge inClk);
    inKeyWr = 1'b0;
    wait(outBusy == 1'b0 && inClk == 1'b0);
    inDataWr = 1'b1; inDataData = outDataData;
    @(posedge inClk);
    inDataWr = 1'b0;
    
    wait(outBusy == 1'b0 && inClk == 1'b0);   
   
    $stop;
end

endmodule
