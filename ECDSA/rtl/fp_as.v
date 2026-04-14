module fp_as #(
  parameter [191:0] MOD_P = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff
) (
  clk,
  rst_n,

  o_i_ready,
  i_i_valid,
  i_i_operation, // 0 add, 1 sub
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
input  wire         i_i_operation;
input  wire [191:0] i_i_a;
input  wire [191:0] i_i_b;

input  wire         i_o_ready;
output wire         o_o_valid;
output wire [191:0] o_o_data;

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
reg [192:0] r_sub_data_a;
reg [191:0] r_sub_data_b;

reg [191:0] r_sub_output;
reg [191:0] r_add_output;
reg [2:0]   r_carry_add;
reg [2:0]   r_carry_sub;

reg         r_ready;
reg         r_valid;
reg [191:0] r_output;

reg r_carry;

wire w_i_active;
wire w_o_active;
assign w_i_active = i_i_valid && r_ready;
assign w_o_active = r_valid && i_o_ready;

// save inputs
always @(posedge clk) begin
  if(w_i_active) begin
    r_in_a <= i_i_a;
    r_in_b <= i_i_b;
    r_in_operation <= i_i_operation;
  end
end

// r_add_data and r_sub_data
always @(posedge clk) begin
  if(r_in_operation) begin
    r_add_data_a <= r_sub_output;
    r_add_data_b <= MOD_P;
    r_sub_data_a <= {1'b0, r_in_a};
    r_sub_data_b <= r_in_b;
  end else begin
    r_add_data_a <= r_in_a;
    r_add_data_b <= r_in_b;
    r_sub_data_a <= {r_carry_add[2], r_add_output};
    r_sub_data_b <= MOD_P;
  end
end

// calculations
always @(posedge clk) begin
      {r_carry_add[0], r_add_output[063:000]} <=  r_add_data_a[063:000] + r_add_data_b[063:000];
      {r_carry_add[1], r_add_output[127:064]} <=  r_add_data_a[127:064] + r_add_data_b[127:064] + r_carry_add[0];
      {r_carry_add[2], r_add_output[191:128]} <=  r_add_data_a[191:128] + r_add_data_b[191:128] + r_carry_add[1];

      {r_carry_sub[0], r_sub_output[063:000]} <=  r_sub_data_a[063:000] - r_sub_data_b[063:000];
      {r_carry_sub[1], r_sub_output[127:064]} <=  r_sub_data_a[127:064] - r_sub_data_b[127:064] - r_carry_sub[0];
      {r_carry_sub[2], r_sub_output[191:128]} <=  r_sub_data_a[192:128] - r_sub_data_b[191:128] - r_carry_sub[1];
end

// r_output
always @(posedge clk) begin
  if (r_carry)
    r_output <= r_add_output;
  else
    r_output <= r_sub_output;
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
    r_ready <= 1'b0;
  end else begin
    case (r_state)
      OP_IDLE: begin
        if(w_i_active) begin
          r_ready <= 1'b0;
          r_state <= OP_FIRST_SET_VAL;
        end else begin
          r_ready <= 1'b1;
        end
      end
      OP_FIRST_SET_VAL, OP_FIRST_CALC_0, OP_FIRST_CALC_1,
      OP_FIRST_CALC_2, OP_SECOND_SET_VAL, OP_SECOND_CALC_0,
      OP_SECOND_CALC_1, OP_SECOND_CALC_2, OP_SAVE_CARRY:
        r_state <= r_state + 1'b1;
      OP_SAVE_OUTPUT: begin
        if(w_o_active) begin
          r_valid <= 1'b0;
          r_state <= OP_IDLE;
          r_ready <= 1'b1;
        end else begin
          r_valid <= 1'b1;
        end
      end
    endcase
  end
end

assign o_i_ready = r_ready;
assign o_o_valid = r_valid;
assign o_o_data  = r_output;

endmodule