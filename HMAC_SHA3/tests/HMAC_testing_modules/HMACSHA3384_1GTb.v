module HMACSHA3384_1GTb;

reg [7:0] TEST = 8'b0;
integer i;
/////////////////////////////////////////

parameter inClkp = 10;
reg       inClk  = 1'b0;

always
begin
    #(inClkp/2) inClk = !inClk;
end

////////////////////////////////////////
reg   regReset = 1'b0;

wire         outBusy;
wire         outCorrect;

HMACSHA3384_1G HMACSHA3384_1G_inst(
   .inClk(inClk),
   .inRst(regReset),
   .outCorrect(outCorrect),
   .outBusy(outBusy)
);

reg regWork = 1'b1;

always
begin
   #(inClkp);

    while(regWork == 1'b1 ) begin
		#(10000*inClkp);
		if(outBusy == 1'b0 ) begin
			regWork <= 1'b0;
		end
		$display("WORKING %d %d", HMACSHA3384_1G_inst.regCounter, regWork);
	end
    if(outCorrect == 1'b1) begin
       $display("Test passed.");
    end else begin
        $display("Test failed!");
    end
   $stop;
end

endmodule
