module crc_checker (
  input wire clk, 
  input wire rst_n,

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

  output wire out_error
);



reg [31:0] r_crc;
wire [31:0] w_out_crc;

reg r_out_error;

wire asi_ta;
wire asi_eta;

wire w_false_crc;

crc  crc_inst (
    .crcIn(r_crc),
    .data(asi_data),
    .crcOut(w_out_crc)
  );
  
stream_delay_4 stream_delay_4_inst(
  .clk(clk), 
  .rst_n(rst_n),
  .asi_data(asi_data),
  .asi_valid(asi_valid),
  .asi_ready(asi_ready),
  .asi_sop(asi_sop),
  .asi_error(asi_error),
  .aso_data(aso_data),
  .aso_valid(aso_valid),
  .aso_ready(aso_ready),
  .aso_sop(aso_sop),
  .aso_eop(aso_eop),
  .aso_error(aso_error),
  .eop(asi_eop),
  .error(w_false_crc),
  .write_eop_error(asi_eta)
);

// r_crc
always @(posedge clk) begin
  if (~rst_n || asi_error || asi_eta) begin
    r_crc <= 32'hFFFFFFFF;
  end else if (asi_ta) begin
    r_crc <= w_out_crc;
  end
end

// r_out_error
always @(posedge clk) begin
  if (~rst_n) begin
    r_out_error <= 1'd0;
  end else if (asi_ta) begin
    if (asi_error || w_false_crc) // 2144df1c ^ FFFFFFFF = debb20e3
      r_out_error <= 1'd1;
    else
      r_out_error <= 1'b0;
  end
end

assign asi_ta = asi_ready && asi_valid;
assign asi_eta = asi_ta && asi_eop;

assign out_error = r_out_error;


assign w_false_crc = asi_eta && w_out_crc != 32'hdebb20e3;

endmodule

