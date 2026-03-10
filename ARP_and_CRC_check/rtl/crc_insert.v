module crc_inserter (
  input wire clk, 
  input wire rst_n,

  input  wire [7:0] asi_data,
  input  wire       asi_valid,
  output wire       asi_ready,
  input  wire       asi_sop,
  input  wire       asi_eop,
  
  output wire [7:0] aso_data,
  output wire       aso_valid,
  input  wire       aso_ready,
  output wire       aso_sop,
  output wire       aso_eop

);

reg [31:0] r_crc;
wire [31:0] w_out_crc;

wire aso_ta;
wire aso_eta;
wire asi_ta;
wire asi_eta;

reg       r_inserting = 1'b0;
reg [1:0] r_counter   = 2'd0;

reg [7:0] r_output_data;

crc  crc_inst (
    .crcIn(r_crc),
    .data(asi_data),
    .crcOut(w_out_crc)
  );

// r_crc
always @(posedge clk) begin
  if (~rst_n || aso_eta) begin
    r_crc <= 32'hFFFFFFFF;
  end else if (asi_ta && ~r_inserting) begin
    r_crc <= w_out_crc;
  end
end

// r_inserting
always @(posedge clk) begin
  if (~rst_n || aso_eta) begin
    r_inserting <= 1'b0;
  end else if (asi_eta) begin
    r_inserting <= 1'b1;
  end
end

// r_counter
always @(posedge clk) begin
  if (~rst_n || aso_eta) begin
    r_counter <= 2'b0;
  end else if (aso_ta && r_inserting) begin
    r_counter <= r_counter + 1'b1;
  end
end

always @(*) begin
  if(r_inserting) begin
    case (r_counter)
      2'd0: r_output_data <= r_crc[7:0] ^ 8'hFF;
      2'd1: r_output_data <= r_crc[15:8] ^ 8'hFF;
      2'd2: r_output_data <= r_crc[23:16] ^ 8'hFF;
      2'd3: r_output_data <= r_crc[31:24] ^ 8'hFF;
    endcase
  end else
    r_output_data <= asi_data;
end

assign asi_ta = asi_ready && asi_valid;
assign aso_ta = aso_ready && aso_valid;
assign asi_eta = asi_ta && asi_eop;
assign aso_eta = aso_ta && aso_eop;

assign aso_data = r_output_data;
assign aso_valid = asi_valid || r_inserting;
assign asi_ready = aso_ready && ~r_inserting;
assign aso_sop = asi_sop && ~r_inserting;
assign aso_eop = r_inserting && r_counter == 2'd3;

endmodule

