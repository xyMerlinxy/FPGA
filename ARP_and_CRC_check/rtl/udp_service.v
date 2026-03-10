module udp_service #(
  parameter [31:0] IP_ADDRESS = 32'hA9FE93FA, //169.254.147.250
  parameter [47:0] MAC_ADDRESS = 48'h001A2B3C4D5E
)(
  input wire clk, 
  input wire rst_n,

  input  wire [7:0] asi_data,
  input  wire       asi_valid,
  output wire       asi_ready,
  input  wire       asi_sop,
  input  wire       asi_eop,
  
  output wire [6:0] dis_7seg_0,
  output wire [6:0] dis_7seg_1,
  output wire [6:0] dis_7seg_2,
  output wire [6:0] dis_7seg_3,
  output wire [6:0] dis_7seg_4,
  output wire [6:0] dis_7seg_5,
  output wire [6:0] dis_7seg_6,
  output wire [6:0] dis_7seg_7
);

wire [13:0] w_out_conv;

bin27s  bin27s_inst_H (
    .in_data(asi_data[7:4]),
    .out_data(w_out_conv[13:7])
  );
  bin27s  bin27s_inst_L (
    .in_data(asi_data[3:0]),
    .out_data(w_out_conv[6:0])
  );

reg [6:0] r_7seg[7:0];

reg [7:0] correct_data;

reg r_skip = 1'b0;

reg [10:0] r_byte_counter = 1'b0;

wire w_asi_ta, w_asi_eta;


always @(posedge clk) begin
  if(~rst_n) begin
    r_7seg[0] <= 7'b1111111;
    r_7seg[2] <= 7'b1111111;
    r_7seg[3] <= 7'b1111111;
    r_7seg[1] <= 7'b1111111;
    r_7seg[4] <= 7'b1111111;
    r_7seg[5] <= 7'b1111111;
    r_7seg[6] <= 7'b1111111;
    r_7seg[7] <= 7'b1111111;
  end else if(~r_skip && w_asi_ta)begin
    case (r_byte_counter)
      11'd42: begin
        r_7seg[0] <= w_out_conv[13:7];
        r_7seg[1] <= w_out_conv[6:0];
      end
      11'd43: begin
        r_7seg[2] <= w_out_conv[13:7];
        r_7seg[3] <= w_out_conv[6:0];
      end
      11'd44: begin
        r_7seg[4] <= w_out_conv[13:7];
        r_7seg[5] <= w_out_conv[6:0];
      end
      11'd45: begin
        r_7seg[6] <= w_out_conv[13:7];
        r_7seg[7] <= w_out_conv[6:0];
      end
    endcase
  end
end

// byte_counter
always @(posedge clk) begin
  if(~rst_n || w_asi_eta)
    r_byte_counter <= 1'b0;
  else if (w_asi_ta)
    r_byte_counter <= r_byte_counter + 1'b1;
end


// r_skip
always @(posedge clk) begin
  if(~rst_n || w_asi_eta)
    r_skip <= 1'b0;
  else if (w_asi_ta && (correct_data != asi_data))
    r_skip <= 1'b1;
end


always @(*) begin
  case (r_byte_counter)
    11'd00: correct_data <= MAC_ADDRESS[47:40]; // mac address
    11'd01: correct_data <= MAC_ADDRESS[39:32];
    11'd02: correct_data <= MAC_ADDRESS[31:24];
    11'd03: correct_data <= MAC_ADDRESS[23:16];
    11'd04: correct_data <= MAC_ADDRESS[15:08];
    11'd05: correct_data <= MAC_ADDRESS[07:00];
    // 11'd06: correct_data <= ;  //  src address
    // 11'd07: correct_data <= ;
    // 11'd08: correct_data <= ;
    // 11'd09: correct_data <= ;
    // 11'd10: correct_data <= ;
    // 11'd11: correct_data <= ;
    11'd12: correct_data <= 8'h08;  // type ipv4
    11'd13: correct_data <= 8'h00;
    11'd14: correct_data <= 8'h45;  // version, ihl
    // 11'd15: correct_data <= // dscp
    // 11'd16: correct_data <=  //total lenght
    // 11'd17: correct_data <=
    // 11'd18: correct_data <=  //identyfication
    // 11'd19: correct_data <=
    // 11'd20: correct_data <= // flag
    // 11'd21: correct_data <=
    // 11'd22: correct_data <= // ttl
    11'd23: correct_data <= 8'h11;// protocol
    // 11'd24: correct_data <=  //header checksum
    // 11'd25: correct_data <=
    // 11'd26: correct_data <= // src ip
    // 11'd27: correct_data <=
    // 11'd28: correct_data <=
    // 11'd29: correct_data <=
    11'd30: correct_data <= IP_ADDRESS[31:24]; // dest ip
    11'd31: correct_data <= IP_ADDRESS[23:16];
    11'd32: correct_data <= IP_ADDRESS[15:08];
    11'd33: correct_data <= IP_ADDRESS[07:00];
    // 11'd34: correct_data <= IP_ADDRESS[07:00]; // src port
    // 11'd35: correct_data <= IP_ADDRESS[07:00];
    11'd36: correct_data <= 8'h08; // dst port
    11'd37: correct_data <= 8'h59;
    default: correct_data <= asi_data;
  endcase
end


assign w_asi_ta = asi_ready && asi_valid;
assign w_asi_eta = w_asi_ta && asi_eop;

assign asi_ready = 1'b1;

assign dis_7seg_0 = r_7seg[7];
assign dis_7seg_1 = r_7seg[6];
assign dis_7seg_2 = r_7seg[5];
assign dis_7seg_3 = r_7seg[4];
assign dis_7seg_4 = r_7seg[3];
assign dis_7seg_5 = r_7seg[2];
assign dis_7seg_6 = r_7seg[1];
assign dis_7seg_7 = r_7seg[0];

endmodule