module stream_delay_4(
  input wire clk, 
  input wire rst_n,

  input  wire [7:0] asi_data,
  input  wire       asi_valid,
  output wire       asi_ready,
  input  wire       asi_sop,
  input  wire       asi_error,
  
  output wire [7:0] aso_data,
  output wire       aso_valid,
  input  wire       aso_ready,
  output wire       aso_sop,
  output wire       aso_eop,
  output wire       aso_error,

  input wire eop,
  input wire error,
  input wire write_eop_error
);

reg [9:0] r_data [5:0]; //error, sop, data
reg [2:0] r_size = 3'd0; // show ending
reg       r_eop = 1'd0;
reg       r_error = 1'd0;

wire [9:0] w_out_data;

wire asi_ta;
wire aso_ta;


always @(posedge clk) begin
  if(asi_ta) begin
      r_data[0] <= {asi_error, asi_sop, asi_data};
      r_data[1] <= r_data[0];
      r_data[2] <= r_data[1];
      r_data[3] <= r_data[2];
      r_data[4] <= r_data[3];
      r_data[5] <= r_data[4];
  end
end

// r_size
always @(posedge clk) begin
  if(~rst_n)
    r_size <= 3'd0;
  else if (aso_ta && r_eop)
    r_size <= 3'd0;
  else if (asi_ta && ~aso_ta)
    r_size <= r_size + 1'b1;
  else if (~asi_ta && aso_ta)
    r_size <= r_size - 1'b1;    
end

// r_eop, r_error
always @(posedge clk) begin
  if(~rst_n || r_size == 3'd0) begin
    r_eop <= 1'd0;
    r_error <= 1'd0;
  end else if (write_eop_error) begin
    r_eop <= eop;
    r_error <= error;
  end
end



assign w_out_data = (r_size == 3'd0)? 9'd0:
                    (r_size == 3'd1)? r_data[0]:
                    (r_size == 3'd2)? r_data[1]:
                    (r_size == 3'd3)? r_data[2]:
                    (r_size == 3'd4)? r_data[3]:
                    (r_size == 3'd5)? r_data[4]:
                    (r_size == 3'd6)? r_data[5]:  9'd0;

assign aso_valid = (asi_ta && r_size == 3'd4 && ~write_eop_error) || (r_eop && r_size > 3'd0);
assign aso_error = w_out_data[9] || r_error;
assign aso_eop = r_eop;
assign aso_data = w_out_data[7:0];
assign aso_sop = w_out_data[8];


assign asi_ready = (r_size == 3'd4 && aso_ready) || r_size < 3'd4; 

assign asi_ta = asi_ready && asi_valid;
assign aso_ta = aso_ready && aso_valid;

endmodule