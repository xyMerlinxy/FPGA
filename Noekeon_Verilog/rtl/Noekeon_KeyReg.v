// Memory module for key storage
// Supports key loading from an external interface and from the encrypted data output

module NoekeonKeyReg(
  input wire        inClk,
  input wire        inReset,
  
  input wire        inKeyWrExt,    // Loading key from an external source
  input wire  [127:0]  inKeyDataExt,
  
  input wire         inKeyWrInt,    // Loading key from DataOutReg
  input wire  [127:0]  inKeyDataInt,
  
  output wire  [127:0]  outKey
);


reg [127:0]    KeyReg = 128'd0;

always @(posedge(inClk) or posedge(inReset))
begin
  if(inReset == 1'b1) begin
    KeyReg = 128'b0;
  end else begin
    if(inKeyWrExt == 1'b1) begin
      KeyReg = inKeyDataExt;
    end else begin
      if (inKeyWrInt == 1'b1) begin
        KeyReg = inKeyDataInt;
      end
    end
  end
end

assign outKey = KeyReg;

endmodule
