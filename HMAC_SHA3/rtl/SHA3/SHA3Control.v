// The SHA3Control module implements the control unit for the SHA3 algorithm coprocessor.
// The SHA3Control module manages the control signals for all internal components of the coprocessor.
// The SHA3Control module is based on a counter stored in the regRoundCnt register. 
// A counter value of 24 indicates the IDLE state, while values from 0 to 23 
// represent the index of the round currently being executed.

module SHA3Control (
    input  wire       inClk,             // Clock signal input; active on the rising edge
    input  wire       inExtRst,          // External reset input for initial state restoration; active high
    input  wire       inExtDataWr,       // External message data write enable; active high
    input  wire       inEnd,             // End-of-message signal; triggers the final hash computation

    output wire       outRegDataInIntWr, // Internal interface data register write enable; active high
    output wire       outRegDataInExtWr, // External interface data register write enable; active high
    output wire       outRegOutDataWr,   // Hash output register write enable; active high
    output wire [4:0] outRoundCnt,       // Round number output bus

    output wire       outRegDataRst,     // State register initialization signal; active high

    output wire       outBusy            // System busy status output; active high
);




reg [4:0] regRoundCnt = 5'd24;
reg       regEnd = 1'b0;



always @(posedge inClk) begin
  if(inExtRst == 1'b1) begin
    regEnd <= 1'b0;
  end else if(inExtDataWr && ~outBusy) begin
    regEnd <= inEnd;
  end
end

always @(posedge(inClk)) begin
  if(inExtRst == 1'b1)
    regRoundCnt <= 5'd24;
  else if(~outBusy && inExtDataWr)
    regRoundCnt <= 5'd0;
  else if(regRoundCnt != 5'd24)
    regRoundCnt <= regRoundCnt+5'd1;
end

assign outRegDataInIntWr = (regRoundCnt < 5'd24) ? 1'd1 : 1'd0;

assign outRegDataInExtWr = (regRoundCnt == 5'd24) ? inExtDataWr : 1'd0;
assign outRegOutDataWr = ((regRoundCnt == 5'd23)&&(regEnd == 1'b1)) ? 1'd1 : 1'd0;
assign outRoundCnt = regRoundCnt;
assign outRegDataRst = ((regRoundCnt == 5'd23)&&(regEnd == 1'b1)) ? 1'd1 : 1'd0;
assign outBusy = (regRoundCnt == 5'd24) ? 1'd0 : 1'd1;

endmodule