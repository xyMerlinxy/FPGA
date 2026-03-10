module phy_receiver(
  input wire rst_n,
  input wire [3:0] rxd,
  input wire rx_clk,
  input wire rx_dv,
  input wire rx_er,

  output wire [7:0] aso_data,
  output wire       aso_valid,
  output wire       aso_sop,
  output wire       aso_eop,
  output wire       aso_error
);


reg [1:0]  r_state = 1'b0;
reg [1:0]  r_counter;
reg [7:0]  r_data_1;
reg [7:0]  r_data_2;
reg        r_sop;

wire [3:0] in_data;
// 0 - idle
// 1 - preamble detected
// 2 - transmission
// 3 - ending


// r_state
always @(posedge rx_clk) begin
  if(~rst_n || rx_er)
    r_state = 1'b0;
  else begin
    case (r_state)
      2'd0: begin
        if(rx_dv && in_data == 4'b1010)
          r_state <= 2'b1;
      end
      2'd1:begin
        if(rx_dv && in_data == 4'b1011)
          r_state <= 2'd2;
      end
      2'd2:begin
        if(~rx_dv)
          r_state <= 2'd3;
      end
      2'd3:
        r_state <= 2'd0;
    endcase
  end 
end

// r_counter
always @(posedge rx_clk) begin
  if(~rst_n || rx_er)
    r_counter = 1'b0;
  else if(r_state == 2'd2 && rx_dv)
    r_counter = r_counter + 1'b1;
  else if(r_state == 2'd2)
    r_counter = r_counter;
  else
    r_counter = 2'd0;
end

// save data
always @(posedge rx_clk) begin
  if(~rst_n || rx_er) begin
    r_data_1 = 8'b0;
    r_data_2 = 8'b0;
  end
  else if(r_state == 2'd2 && rx_dv) begin
    case (r_counter)
      2'd0: r_data_1[3:0] <= rxd;
      2'd1: r_data_1[7:4] <= rxd;
      2'd2: r_data_2[3:0] <= rxd;
      2'd3: r_data_2[7:4] <= rxd;
    endcase
  end
end

// r_sop
always @(posedge rx_clk) begin
  if(~rst_n || rx_er)
    r_sop = 1'b0;
  else if(r_state == 2'd1 && rx_dv && in_data == 4'b1011)
    r_sop <= 1'b1;
  else if(aso_valid)
    r_sop = 1'd0;
end

assign aso_sop = r_sop;
assign aso_eop = r_state == 2'd3;


assign aso_data = (r_counter == 2'd2 || r_counter == 2'd3) ? r_data_1: r_data_2;
assign aso_valid = ((r_counter == 2'd3 || (r_counter == 2'd1 && ~r_sop)) && r_state == 2'd2 || r_state == 2'd3);
assign aso_error = rx_er;

assign in_data = {rxd[0],rxd[1],rxd[2],rxd[3]};

endmodule