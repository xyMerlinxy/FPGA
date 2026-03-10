module phy_transmitter(
  input wire rst_n,

  output wire [3:0] txd,
  input  wire tx_clk,
  output wire tx_en,

  input  wire [7:0] asi_data,
  input  wire       asi_valid,
  output wire       asi_ready,
  input  wire       asi_sop,
  input  wire       asi_eop
);


reg [3:0]  r_counter;
reg [7:0]  r_data;

reg [3:0] out_data;

reg [1:0] r_state;
// 0 - idle
// 1 - preamble sending
// 2 - end_preamble
// 3 - data sending

wire asi_ta, asi_eta;

// r_data
always @(posedge tx_clk) begin
  if (asi_ta)
    r_data <= asi_data;
end


// r_state
always @(posedge tx_clk) begin
  if(~rst_n)
    r_state = 1'b0;
  else begin
    case (r_state)
      2'd0: begin
        if(asi_valid)
          r_state <= 2'b1;
      end
      2'd1:begin
        if(r_counter == 4'd12)
          r_state <= 2'd2;
      end
      2'd2:begin
        r_state <= 2'd3;
      end
      2'd3:
        if(asi_eta)
          r_state <= 2'd0;
    endcase
  end 
end

// r_counter
always @(posedge tx_clk) begin
  if(~rst_n || ~tx_en)
    r_counter <= 1'b0;
  else begin
    case (r_state)
      2'd0: r_counter <= 1'd0;
      2'd1: r_counter <= r_counter + 1'b1;
      2'd2: r_counter = 1'd0;
      2'd3: r_counter <= r_counter ^ 1'b1;
    endcase
  end
end

// save data
always @(*) begin
    case (r_state)
      2'd0: out_data <= 4'b0;
      2'd1: out_data <= 4'b0101;
      2'd2: out_data <= 4'b1101;
      2'd3: out_data <= (r_counter == 4'b0)? r_data[3:0]: r_data[7:4];
    endcase
end

assign asi_ready = (r_state == 2'd0 && ~asi_valid) || (r_state == 2'd3 && r_counter == 5'd1) || r_state == 2'd2;

assign txd = out_data;
assign tx_en = r_state != 2'd0;

assign asi_ta = asi_ready && asi_valid;
assign asi_eta = asi_ta && asi_eop;

endmodule