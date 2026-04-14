module fp_mul #(
  parameter [191:0] MOD_P = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff
) (
  clk,
  rst_n,

  o_i_ready,
  i_i_valid,
  i_i_a,
  i_i_b,
  
  i_o_ready,
  o_o_valid,
  o_o_data
  );

input  wire         clk;
input  wire         rst_n;

output wire         o_i_ready;
input  wire         i_i_valid;
input  wire [191:0] i_i_a;
input  wire [191:0] i_i_b;

input  wire         i_o_ready;
output wire         o_o_valid;
output wire [191:0] o_o_data;

localparam OP_IDLE     = 3'd0;
localparam OP_DOUBLE_S = 3'd1;
localparam OP_DOUBLE_W = 3'd2;
localparam OP_ADD_S =    3'd3;
localparam OP_ADD_W =    3'd4;
localparam OP_END   =    3'd5;

reg [191:0] r_i_a;
reg [191:0] r_i_b;

reg [7:0] r_bit_cnt;
reg [2:0] r_state;

reg  [191:0] r_add_b;
reg          r_add_b_select;

wire [191:0] w_add_o_data;

wire         w_add_i_ready;
reg          r_add_i_valid;

wire         w_add_o_valid;

reg         r_ready;
reg         r_valid;
reg [191:0] r_out;

fp_add #(
  .MOD_P(MOD_P)
) fp_add_inst (
    .clk(clk),
    .rst_n(rst_n),

    .o_i_ready(w_add_i_ready),
    .i_i_valid(r_add_i_valid),
    .i_i_a(r_out),
    .i_i_b(r_add_b),
    
    .i_o_ready(1'b1),
    .o_o_valid(w_add_o_valid),
    .o_o_data(w_add_o_data)
  );


wire w_i_active;
wire w_o_active;
assign w_i_active = i_i_valid && o_i_ready;
assign w_o_active = o_o_valid && i_o_ready;

wire w_add_i_active;
wire w_add_o_active;
assign w_add_i_active = w_add_i_ready && r_add_i_valid;
assign w_add_o_active = w_add_o_valid;


// save inputs
always @(posedge clk) begin
  if(w_i_active) begin
    r_i_a <= i_i_a;
    r_i_b <= i_i_b;
  end else if(r_state == OP_DOUBLE_W && w_add_o_active)
    r_i_b <= r_i_b << 1;
end


// r_add_b
always @(posedge clk) begin
  if(w_i_active) begin
    r_add_b <= 192'd0;
  end else if(w_add_o_active)
    if(r_add_b_select)
      r_add_b <= r_i_a;
    else
      r_add_b <= w_add_o_data;
end



// r_state
always @(posedge clk) begin
  if (!rst_n) begin
    r_state <= OP_IDLE;
    r_ready <= 1'b0;
    r_valid <= 1'b0;
    r_add_i_valid <= 1'b0;
    r_add_b_select <= 1'b0;
  end else begin
    case (r_state)
      OP_IDLE: begin
        if (w_i_active) begin
          r_state <= OP_DOUBLE_S;
          r_add_i_valid <= 1'b1;
          r_ready <= 1'b0;
        end else
          r_ready <= 1'b1;
      end 
      OP_DOUBLE_S: begin
        if(w_add_i_active) begin
          r_state <= OP_DOUBLE_W;
          r_add_i_valid <= 1'b0;
        end
        r_add_b_select <= r_i_b[191];
      end
      OP_DOUBLE_W: begin
        if(w_add_o_active) begin
          if(r_i_b[191]) begin
            r_state <= OP_ADD_S;
            r_add_i_valid <= 1'b1;
          end else begin // don't add
            if (r_bit_cnt == 8'd192) begin
              r_state <= OP_END;
              r_valid <= 1'b1;
            end else begin
              r_state <= OP_DOUBLE_S;
              r_add_i_valid <= 1'b1;
            end
          end
        end
      end
      OP_ADD_S: begin
        if(w_add_i_active) begin
          r_state <= OP_ADD_W;
          r_add_i_valid <= 1'b0;
        end
        r_add_b_select <= 1'b0;
      end
      OP_ADD_W: begin
        if(w_add_o_active) begin
          if (r_bit_cnt == 8'd192) begin
            r_state <= OP_END;
            r_valid <= 1'b1;
          end else begin
            r_state <= OP_DOUBLE_S;
            r_add_i_valid <= 1'b1;
          end
        end
      end
      OP_END: begin
        if(w_o_active) begin
          r_valid <= 1'b0;
          r_state <= OP_IDLE;
        end
      end
    endcase
  end
end

// r_out
always @(posedge clk) begin
  if(w_i_active) begin
    r_out <= 192'b0;
  end else if (w_add_o_active) begin
    r_out <= w_add_o_data;
  end
end

// r_bit_cnt
always @(posedge clk) begin
  if(w_i_active)
      r_bit_cnt <= 1'b0;
  else if (r_state == OP_DOUBLE_S && w_add_i_active)
      r_bit_cnt <= r_bit_cnt + 1'b1;
end

assign o_i_ready = r_ready;
assign o_o_valid = r_valid;
assign o_o_data = r_out;

endmodule