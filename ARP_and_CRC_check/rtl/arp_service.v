module arp_service #(
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
  
  output wire [7:0] aso_data,
  output wire       aso_valid,
  input  wire       aso_ready,
  output wire       aso_sop,
  output wire       aso_eop
);

reg [31:0] src_ip_addr;
reg [47:0] src_mac_addr;

reg [7:0] correct_data;
reg [7:0] sending_data;

reg r_sending = 1'b0;
reg r_skip = 1'b0;
reg r_eop = 1'b0;

reg [10:0] r_byte_counter = 1'b0;

wire w_asi_ta, w_asi_eta;
wire w_aso_ta, w_aso_eta;

// byte_counter
always @(posedge clk) begin
  if(~rst_n || w_asi_eta || w_aso_eta)
    r_byte_counter <= 1'b0;
  else if (w_asi_ta || w_aso_ta)
    r_byte_counter <= r_byte_counter + 1'b1;
end

// src_ip_addr and src_mac_addr
always @(posedge clk) begin
  if (w_asi_ta)begin
    case (r_byte_counter)
      11'd22:src_mac_addr[47:40] <= asi_data; 
      11'd23:src_mac_addr[39:32] <= asi_data; 
      11'd24:src_mac_addr[31:24] <= asi_data; 
      11'd25:src_mac_addr[23:16] <= asi_data; 
      11'd26:src_mac_addr[15:08] <= asi_data; 
      11'd27:src_mac_addr[07:00] <= asi_data; 
      11'd28:src_ip_addr[31:24] <= asi_data; 
      11'd29:src_ip_addr[23:16] <= asi_data; 
      11'd30:src_ip_addr[15:08] <= asi_data; 
      11'd31:src_ip_addr[07:00] <= asi_data; 
    endcase
  end
end

// r_skip
always @(posedge clk) begin
  if(~rst_n || r_eop)
    r_skip <= 1'b0;
  else if (w_asi_ta && (correct_data != asi_data || (r_byte_counter != 11'd59 && w_asi_eta)))
    r_skip <= 1'b1;
end

// r_eop
always @(posedge clk) begin
  if(w_asi_ta)
    r_eop <= asi_eop;
  else
    r_eop <= 1'b0;
end

// r_sending
always @(posedge clk) begin
  if(~rst_n || w_aso_eta)
    r_sending <= 1'b0;
  else if (r_eop && ~r_skip)
    r_sending <= 1'b1;
end



always @(*) begin
  case (r_byte_counter)
    11'd00: correct_data <= 8'hFF; // arp broadcast mac dest
    11'd01: correct_data <= 8'hFF;
    11'd02: correct_data <= 8'hFF;
    11'd03: correct_data <= 8'hFF;
    11'd04: correct_data <= 8'hFF;
    11'd05: correct_data <= 8'hFF;
    // 11'd06: correct_data <= ;  //  src address
    // 11'd07: correct_data <= ;
    // 11'd08: correct_data <= ;
    // 11'd09: correct_data <= ;
    // 11'd10: correct_data <= ;
    // 11'd11: correct_data <= ;
    11'd12: correct_data <= 8'h08; // type arp
    11'd13: correct_data <= 8'h06;
    11'd14: correct_data <= 8'h00; // hardware type ethernet
    11'd15: correct_data <= 8'h01;
    11'd16: correct_data <= 8'h08; // prtocol type IPv4
    11'd17: correct_data <= 8'h00;
    11'd18: correct_data <= 8'h06; //hardware size
    11'd19: correct_data <= 8'h04; // protocol size
    11'd20: correct_data <= 8'h00; //opcode
    11'd21: correct_data <= 8'h01;
    // 11'd22: correct_data <= 8'h; // src mac address
    // 11'd23: correct_data <= 8'h;
    // 11'd24: correct_data <= 8'h;
    // 11'd25: correct_data <= 8'h;
    // 11'd26: correct_data <= 8'h;
    // 11'd27: correct_data <= 8'h;
    // 11'd28: correct_data <= 8'h; // scr ip address
    // 11'd29: correct_data <= 8'h;
    // 11'd30: correct_data <= 8'h;
    // 11'd31: correct_data <= 8'h;
    // 11'd32: correct_data <= 8'h00;  // target mac address
    // 11'd33: correct_data <= 8'h00;
    // 11'd34: correct_data <= 8'h00;
    // 11'd35: correct_data <= 8'h00;
    // 11'd36: correct_data <= 8'h00;
    // 11'd37: correct_data <= 8'h00;
    11'd38: correct_data <= IP_ADDRESS[31:24]; // target ip
    11'd39: correct_data <= IP_ADDRESS[23:16];
    11'd40: correct_data <= IP_ADDRESS[15:8];
    11'd41: correct_data <= IP_ADDRESS[7:0];
    default: correct_data <= asi_data;
  endcase
end

always @(*) begin
  case (r_byte_counter)
    11'd00: sending_data <= src_mac_addr[47:40]; // dst address
    11'd01: sending_data <= src_mac_addr[39:32];
    11'd02: sending_data <= src_mac_addr[31:24];
    11'd03: sending_data <= src_mac_addr[23:16];
    11'd04: sending_data <= src_mac_addr[15:08];
    11'd05: sending_data <= src_mac_addr[07:00];
    11'd06: sending_data <= MAC_ADDRESS[47:40];  //  src address
    11'd07: sending_data <= MAC_ADDRESS[39:32];
    11'd08: sending_data <= MAC_ADDRESS[31:24];
    11'd09: sending_data <= MAC_ADDRESS[23:16];
    11'd10: sending_data <= MAC_ADDRESS[15:08];
    11'd11: sending_data <= MAC_ADDRESS[07:00];
    11'd12: sending_data <= 8'h08; // type arp
    11'd13: sending_data <= 8'h06;
    11'd14: sending_data <= 8'h00; // hardware type ethernet
    11'd15: sending_data <= 8'h01;
    11'd16: sending_data <= 8'h08; // prtocol type IPv4
    11'd17: sending_data <= 8'h00;
    11'd18: sending_data <= 8'h06; //hardware size
    11'd19: sending_data <= 8'h04; // protocol size
    11'd20: sending_data <= 8'h00; //opcode
    11'd21: sending_data <= 8'h02;
    11'd22: sending_data <= MAC_ADDRESS[47:40]; // src mac address
    11'd23: sending_data <= MAC_ADDRESS[39:32];
    11'd24: sending_data <= MAC_ADDRESS[31:24];
    11'd25: sending_data <= MAC_ADDRESS[23:16];
    11'd26: sending_data <= MAC_ADDRESS[15:08];
    11'd27: sending_data <= MAC_ADDRESS[07:00];
    11'd28: sending_data <= IP_ADDRESS[31:24]; // scr ip address
    11'd29: sending_data <= IP_ADDRESS[23:16];
    11'd30: sending_data <= IP_ADDRESS[15:08];
    11'd31: sending_data <= IP_ADDRESS[07:00];
    11'd32: sending_data <= src_mac_addr[47:40];  // target mac address
    11'd33: sending_data <= src_mac_addr[39:32];
    11'd34: sending_data <= src_mac_addr[31:24];
    11'd35: sending_data <= src_mac_addr[23:16];
    11'd36: sending_data <= src_mac_addr[15:08];
    11'd37: sending_data <= src_mac_addr[07:00];
    11'd38: sending_data <= src_ip_addr[31:24]; // target ip
    11'd39: sending_data <= src_ip_addr[23:16];
    11'd40: sending_data <= src_ip_addr[15:08];
    11'd41: sending_data <= src_ip_addr[07:00];
    default: sending_data <= 8'd0;
  endcase
end

assign w_asi_ta = asi_ready && asi_valid;
assign w_asi_eta = w_asi_ta && asi_eop;

assign w_aso_ta = aso_ready && aso_valid;
assign w_aso_eta = w_aso_ta && aso_eop;

assign asi_ready = ~r_sending && ~r_eop;

assign aso_data = sending_data; 
assign aso_valid = r_sending; 
assign aso_sop = w_aso_ta && r_byte_counter == 11'd0; 
assign aso_eop = w_aso_ta && r_byte_counter == 11'd59; 

endmodule