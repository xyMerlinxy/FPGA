// Memory module for data storage
// Supports data loading from an external interface, the round function output, or storing the key as data

module NoekeonDataReg(
  input wire        inClk,
  input wire        inReset,
  
  input wire        inDataWrKey,    // Loading data from the key register
  input wire  [127:0]  inDataDataKey,
  
  input wire        inDataWrExt,    // Loading data from an external source
  input wire  [127:0]  inDataDataExt,
  
  input wire         inDataWrInt,    // Loading data from the round function module
  input wire  [127:0]  inDataDataInt,
  
  output wire  [127:0]  outData
);

reg [127:0]    DataReg = 128'b0;

always @(posedge(inClk) or posedge(inReset))
begin
  if(inReset == 1'b1) begin
    DataReg = 128'b0;
  end else begin
    if(inDataWrKey == 1'b1) begin
      DataReg = inDataDataKey;
    end else begin
      if (inDataWrExt == 1'b1) begin
        DataReg = inDataDataExt;
      end else begin
        if (inDataWrInt == 1'b1) begin
          DataReg = inDataDataInt;
        end
      end
    end
  end
end

assign outData = DataReg;

endmodule
