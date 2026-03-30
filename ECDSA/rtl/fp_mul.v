module fp_mul #(
  parameter [191:0] MOD_P = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff
) (
  clk,
  rst_n,
  i_data_a,
  i_data_b,
  i_data_wr,
  o_data,
  o_valid
  );

input  wire         clk, rst_n;
input  wire [191:0] i_data_a, i_data_b;
input  wire         i_data_wr;
output wire [191:0] o_data;
output wire         o_valid;

localparam OP_IDLE    = 3'd0;
localparam OP_ADD_0_S = 3'd1;
localparam OP_ADD_0_W = 3'd2;
localparam OP_ADD_1_S = 3'd3;
localparam OP_ADD_1_W = 3'd4;

reg [191:0] r_in_a;
reg [191:0] r_in_b;
reg [191:0] r_out;

reg [7:0] r_bit_cnt;
reg [2:0] r_state;
reg       r_o_valid;

reg  [191:0] r_as_data_b;
wire [191:0] w_as_data_out;
reg          r_as_data_wr;
wire         w_as_valid;

fp_add #(
  .MOD_P(MOD_P)
) fp_add_inst (
    .clk(clk),
    .rst_n(rst_n),
    .i_data_a(r_out),
    .i_data_b(r_as_data_b),
    .i_data_wr(r_as_data_wr),
    .o_data(w_as_data_out),
    .o_valid(w_as_valid)
  );

// store data
always @(posedge clk) begin
  if(r_state == OP_IDLE && i_data_wr) begin
    r_in_a <= i_data_a;
    r_in_b <= i_data_b;
  end else if(r_state == OP_ADD_0_W && w_as_valid)
    r_in_b <= r_in_b << 1;
end

// r_state
always @(posedge clk) begin
  if (!rst_n) begin
    r_state <= OP_IDLE;
    r_o_valid <= 1'b0;
    r_as_data_wr <= 1'b0;
  end else begin
    case (r_state)
      OP_IDLE: begin
        if (i_data_wr) begin
          r_state <= OP_ADD_0_S;
          r_as_data_wr <= 1'b1;
          r_as_data_b <= 192'd0;
          r_o_valid <= 1'b0;
        end
      end 
      OP_ADD_0_S: begin
        r_state <= OP_ADD_0_W;
        r_as_data_wr <= 1'b0;
      end
      OP_ADD_0_W: begin
        if(w_as_valid) begin
          if(r_in_b[191]) begin
            r_state <= OP_ADD_1_S;
            r_as_data_wr <= 1'b1;
            r_as_data_b <= r_in_a;
          end else begin // don't add
            r_as_data_b <= w_as_data_out;
            if (r_bit_cnt == 192) begin
              r_state <= OP_IDLE;
              r_o_valid <= 1'b1;
            end else begin
              r_state <= OP_ADD_0_S;
              r_as_data_wr <= 1'b1;
            end
          end
        end
      end
      OP_ADD_1_S: begin
        r_state <= OP_ADD_1_W;
        r_as_data_wr <= 1'b0;
      end
      OP_ADD_1_W: begin
        if(w_as_valid) begin
          r_as_data_b <= w_as_data_out;
          if (r_bit_cnt == 192) begin
            r_state <= OP_IDLE;
            r_o_valid <= 1'b1;
          end else begin
            r_state <= OP_ADD_0_S;
            r_as_data_wr <= 1'b1;
          end
        end
      end
    endcase
  end
end

// r_out
always @(posedge clk) begin
  if(r_state == OP_IDLE && i_data_wr) begin
    r_out <= 192'b0;
  end else if (w_as_valid) begin
    r_out <= w_as_data_out;
  end
end

// r_bit_cnt
always @(posedge clk) begin
  case (r_state)
    OP_IDLE: begin
      r_bit_cnt <= 1'b0;
    end
    OP_ADD_0_S: begin
      r_bit_cnt <= r_bit_cnt + 1'b1;
    end
  endcase
end

assign o_data = r_out;
assign o_valid = r_o_valid;

endmodule