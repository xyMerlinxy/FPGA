module fp_as #(
  parameter [191:0] MOD_P = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff
) (
  clk,
  rst_n,
  i_data_a,
  i_data_b,
  i_operation, // 0 add, 1 sub
  i_data_wr,
  o_data,
  o_valid
  );


input  wire         clk, rst_n;
input  wire [191:0] i_data_a, i_data_b;
input  wire         i_data_wr;
input  wire         i_operation;
output wire [191:0] o_data;
output wire         o_valid;

localparam OP_IDLE           = 4'd0;
localparam OP_FIRST_SET_VAL  = 4'd1; // set values for subtract and addition 
localparam OP_FIRST_CALC_0   = 4'd2;
localparam OP_FIRST_CALC_1   = 4'd3;
localparam OP_FIRST_CALC_2   = 4'd4;
localparam OP_SECOND_SET_VAL = 4'd5; // set values for subtract and addition 
localparam OP_SECOND_CALC_0  = 4'd6;
localparam OP_SECOND_CALC_1  = 4'd7;
localparam OP_SECOND_CALC_2  = 4'd8;
localparam OP_SAVE_CARRY     = 4'd9;
localparam OP_SAVE_OUTPUT    = 4'd10;

reg [191:0] r_in_a;
reg [191:0] r_in_b;
reg         r_in_operation;

reg [3:0] r_state;


reg [191:0] r_add_data_a;
reg [191:0] r_add_data_b;
reg [191:0] r_sub_data_a;
reg [191:0] r_sub_data_b;

reg [191:0] r_sub_output;
reg [191:0] r_add_output;
reg [2:0]   r_carry_add;
reg [2:0]   r_carry_sub;

reg         r_valid;
reg [191:0] r_output;

reg r_carry;

always @(posedge clk) begin
  // r_add_data and r_sub_data
  if(r_in_operation) begin
    r_add_data_a <= r_sub_output;
    r_add_data_b <= MOD_P;
    r_sub_data_a <= r_in_a;
    r_sub_data_b <= r_in_b;
  end else begin
    r_add_data_a <= r_in_a;
    r_add_data_b <= r_in_b;
    r_sub_data_a <= r_add_output;
    r_sub_data_b <= MOD_P;
  end
end

// save inputs
always @(posedge clk) begin
  if(r_state == OP_IDLE && i_data_wr) begin
    r_in_a <= i_data_a;
    r_in_b <= i_data_b;
    r_in_operation <= i_operation;
  end
end

// calculations
always @(posedge clk) begin
      {r_carry_add[0], r_add_output[063:000]} <=  r_add_data_a[063:000] + r_add_data_b[063:000];
      {r_carry_add[1], r_add_output[127:064]} <=  r_add_data_a[127:064] + r_add_data_b[127:064] + r_carry_add[0];
      {r_carry_add[2], r_add_output[191:128]} <=  r_add_data_a[191:128] + r_add_data_b[191:128] + r_carry_add[1];

      {r_carry_sub[0], r_sub_output[063:000]} <=  r_sub_data_a[063:000] - r_sub_data_b[063:000];
      {r_carry_sub[1], r_sub_output[127:064]} <=  r_sub_data_a[127:064] - r_sub_data_b[127:064] - r_carry_sub[0];
      {r_carry_sub[2], r_sub_output[191:128]} <=  r_sub_data_a[191:128] - r_sub_data_b[191:128] - r_carry_sub[1];
end

// save output
always @(posedge clk) begin
  casex ({r_in_operation, r_carry})
    3'b01: r_output <= r_add_output;
    3'b00: r_output <= r_sub_output;
    3'b11: r_output <= r_add_output;
    3'b10: r_output <= r_sub_output;
  endcase
end

// r_carry
always @(posedge clk) begin
  r_carry <= r_carry_sub[2];
end

// r_state
always @(posedge clk) begin
  if (!rst_n) begin
    r_state <= OP_IDLE;
    r_valid <= 1'b0;
  end else begin
    case (r_state)
      OP_IDLE: begin
        if(i_data_wr) begin
          r_valid <= 1'b0;
          r_state <= OP_FIRST_SET_VAL;
        end
      end
      OP_FIRST_SET_VAL, OP_FIRST_CALC_0, OP_FIRST_CALC_1,
      OP_FIRST_CALC_2, OP_SECOND_SET_VAL, OP_SECOND_CALC_0,
      OP_SECOND_CALC_1, OP_SECOND_CALC_2, OP_SAVE_CARRY:
        r_state <= r_state + 1'b1;
      OP_SAVE_OUTPUT: begin
        r_valid <= 1'b1;
        r_state <= OP_IDLE;
      end
    endcase
  end
end

assign o_data = r_output;
assign o_valid = r_valid;

endmodule