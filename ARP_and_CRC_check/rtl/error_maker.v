module error_maker(
  input wire clk,

  input  wire [7:0] asi_data,
  input  wire       asi_valid,
  output wire       asi_ready,
  input  wire       asi_sop,
  input  wire       asi_eop,
  input  wire       asi_error,
  
  output wire [7:0] aso_data,
  output wire       aso_valid,
  input  wire       aso_ready,
  output wire       aso_sop,
  output wire       aso_eop,
  output wire       aso_error,

  input wire [7:0] error_value,
  input wire [7:0] error_addr,
  input wire       error_enable
);

wire w_asi_ta, w_asi_eta;
reg [10:0] r_byte_counter = 1'b0;

// byte_counter
always @(posedge clk) begin
  if(w_asi_eta)
    r_byte_counter <= 1'b0;
  else if (w_asi_ta)
    r_byte_counter <= r_byte_counter + 1'b1;
end



assign w_asi_ta = asi_ready && asi_valid;
assign w_asi_eta = w_asi_ta && asi_eop;

assign asi_ready = aso_ready;
assign aso_data = (r_byte_counter == error_addr && error_enable)? asi_data^error_value : asi_data;
assign aso_valid = asi_valid;
assign aso_sop = asi_sop;
assign aso_eop = asi_eop;
assign aso_error = asi_error;
endmodule