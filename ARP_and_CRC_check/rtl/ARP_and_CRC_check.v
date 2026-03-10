

  module ARP_and_CRC_check#(
    parameter [31:0] IP_ADDRESS = 32'hA9FE93FA, //169.254.147.250
    // parameter [31:0] IP_ADDRESS = 32'hC0A83716, //192.168.55.22
    parameter [47:0] MAC_ADDRESS = 48'h001A2B3C4D5E
  )(
  input wire rst_n,
  input wire clk,

  input wire [3:0] rxd,
  input wire rx_clk,
  input wire rx_dv,
  input wire rx_er,

  output wire [3:0] txd,
  input  wire tx_clk,
  output wire tx_en,

  output wire [6:0] dis_7seg_0,
  output wire [6:0] dis_7seg_1,
  output wire [6:0] dis_7seg_2,
  output wire [6:0] dis_7seg_3,
  output wire [6:0] dis_7seg_4,
  output wire [6:0] dis_7seg_5,
  output wire [6:0] dis_7seg_6,
  output wire [6:0] dis_7seg_7,

  output wire out_error,
  output wire rst_n_marvel,

  input wire [7:0] error_value,
  input wire [7:0] error_addr,
  input wire       error_enable
  );

wire [7:0] as_rec_dcf0_data;
wire       as_rec_dcf0_valid;
wire       as_rec_dcf0_sop;
wire       as_rec_dcf0_eop;
wire       as_rec_dcf0_error;

wire [7:0] as_dcf0_erm_data;
wire       as_dcf0_erm_valid;
wire       as_dcf0_erm_ready;
wire       as_dcf0_erm_sop;
wire       as_dcf0_erm_eop;
wire       as_dcf0_erm_error;

wire [7:0] as_erm_crc_data;
wire       as_erm_crc_valid;
wire       as_erm_crc_ready;
wire       as_erm_crc_sop;
wire       as_erm_crc_eop;
wire       as_erm_crc_error;


wire [7:0] as_crc_scf0_data;
wire       as_crc_scf0_valid;
wire       as_crc_scf0_ready;
wire       as_crc_scf0_sop;
wire       as_crc_scf0_eop;
wire       as_crc_scf0_error;

wire [7:0] as_scf0_arpudp_data;
wire       as_scf0_arpudp_valid;
wire       as_scf0_udp_ready;
wire       as_scf0_arp_ready;
wire       as_scf0_arpudp_sop;
wire       as_scf0_arpudp_eop;

wire [7:0] as_arp_crcins_data;
wire       as_arp_crcins_valid;
wire       as_arp_crcins_ready;
wire       as_arp_crcins_sop;
wire       as_arp_crcins_eop;

wire [7:0] as_crcins_dcf1_data;
wire       as_crcins_dcf1_valid;
wire       as_crcins_dcf1_ready;
wire       as_crcins_dcf1_sop;
wire       as_crcins_dcf1_eop;

wire [7:0] as_dcf1_tran_data;
wire       as_dcf1_tran_valid;
wire       as_dcf1_tran_ready;
wire       as_dcf1_tran_sop;
wire       as_dcf1_tran_eop;

phy_receiver  phy_receiver_inst (
    .rst_n(rst_n),
    .rxd(rxd),
    .rx_clk(rx_clk),
    .rx_dv(rx_dv),
    .rx_er(rx_er),
    .aso_data(as_rec_dcf0_data),
    .aso_valid(as_rec_dcf0_valid),
    .aso_sop(as_rec_dcf0_sop),
    .aso_eop(as_rec_dcf0_eop),
    .aso_error(as_rec_dcf0_error)
  );
  
  dc_fifo  dc_fifo_inst_0 (
    .dc_fifo_0_in_data(as_rec_dcf0_data),
    .dc_fifo_0_in_valid(as_rec_dcf0_valid),
    .dc_fifo_0_in_ready(),
    .dc_fifo_0_in_startofpacket(as_rec_dcf0_sop),
    .dc_fifo_0_in_endofpacket(as_rec_dcf0_eop),
    .dc_fifo_0_in_error(as_rec_dcf0_error),
    .dc_fifo_0_in_clk_clk(rx_clk),
    .dc_fifo_0_in_clk_reset_reset_n(rst_n),
    
    .dc_fifo_0_out_data(as_dcf0_erm_data),
    .dc_fifo_0_out_valid(as_dcf0_erm_valid),
    .dc_fifo_0_out_ready(as_dcf0_erm_ready),
    .dc_fifo_0_out_startofpacket(as_dcf0_erm_sop),
    .dc_fifo_0_out_endofpacket(as_dcf0_erm_eop),
    .dc_fifo_0_out_error(as_dcf0_erm_error),
    .dc_fifo_0_out_clk_clk(clk),
    .dc_fifo_0_out_clk_reset_reset_n(rst_n)
  );

  error_maker  error_maker_inst (
    .clk(clk),
    .asi_data(as_dcf0_erm_data),
    .asi_valid(as_dcf0_erm_valid),
    .asi_ready(as_dcf0_erm_ready),
    .asi_sop(as_dcf0_erm_sop),
    .asi_eop(as_dcf0_erm_eop),
    .asi_error(as_dcf0_erm_error),
    .aso_data(as_erm_crc_data),
    .aso_valid(as_erm_crc_valid),
    .aso_ready(as_erm_crc_ready),
    .aso_sop(as_erm_crc_sop),
    .aso_eop(as_erm_crc_eop),
    .aso_error(as_erm_crc_error),
    .error_value(error_value),
    .error_addr(error_addr),
    .error_enable(error_enable)
  );

  crc_checker  crc_checker_inst (
    .clk(clk),
    .rst_n(rst_n),
    .asi_data(as_erm_crc_data),
    .asi_valid(as_erm_crc_valid),
    .asi_ready(as_erm_crc_ready),
    .asi_sop(as_erm_crc_sop),
    .asi_eop(as_erm_crc_eop),
    .asi_error(as_erm_crc_error),

    .aso_data(as_crc_scf0_data),
    .aso_valid(as_crc_scf0_valid),
    .aso_ready(as_crc_scf0_ready),
    .aso_sop(as_crc_scf0_sop),
    .aso_eop(as_crc_scf0_eop),
    .aso_error(as_crc_scf0_error),
    
    .out_error(out_error)
  );

  sc_fifo sc_fifo_inst_0 (
    .sc_fifo_0_clk_clk(clk),
    .sc_fifo_0_clk_reset_reset(~rst_n),
    .sc_fifo_0_csr_address(1'd0),
    .sc_fifo_0_csr_read(1'd0),
    .sc_fifo_0_csr_write(1'd0),
    .sc_fifo_0_csr_readdata(),
    .sc_fifo_0_csr_writedata(1'd0),

    .sc_fifo_0_in_data(as_crc_scf0_data),
    .sc_fifo_0_in_valid(as_crc_scf0_valid),
    .sc_fifo_0_in_ready(as_crc_scf0_ready),
    .sc_fifo_0_in_startofpacket(as_crc_scf0_sop),
    .sc_fifo_0_in_endofpacket(as_crc_scf0_eop),
    .sc_fifo_0_in_error(as_crc_scf0_error),

    .sc_fifo_0_out_data(as_scf0_arpudp_data),
    .sc_fifo_0_out_valid(as_scf0_arpudp_valid),
    .sc_fifo_0_out_ready(as_scf0_udp_ready && as_scf0_arp_ready),
    .sc_fifo_0_out_startofpacket(as_scf0_arpudp_sop), 
    .sc_fifo_0_out_endofpacket(as_scf0_arpudp_eop),
    .sc_fifo_0_out_error()
  );
  arp_service #(
    .IP_ADDRESS(IP_ADDRESS),
    .MAC_ADDRESS(MAC_ADDRESS)
  ) arp_service_inst (
    .clk(clk),
    .rst_n(rst_n),
    .asi_data(as_scf0_arpudp_data),
    .asi_valid(as_scf0_arpudp_valid),
    .asi_ready(as_scf0_arp_ready),
    .asi_sop(as_scf0_arpudp_sop),
    .asi_eop(as_scf0_arpudp_eop),
    .aso_data(as_arp_crcins_data),
    .aso_valid(as_arp_crcins_valid),
    .aso_ready(as_arp_crcins_ready),
    .aso_sop(as_arp_crcins_sop),
    .aso_eop(as_arp_crcins_eop)
  );

  udp_service # (
    .IP_ADDRESS(IP_ADDRESS),
    .MAC_ADDRESS(MAC_ADDRESS)
  )
  udp_service_inst (
    .clk(clk),
    .rst_n(rst_n),
    .asi_data(as_scf0_arpudp_data),
    .asi_valid(as_scf0_arpudp_valid),
    .asi_ready(as_scf0_udp_ready),
    .asi_sop(as_scf0_arpudp_sop),
    .asi_eop(as_scf0_arpudp_eop),
    .dis_7seg_0(dis_7seg_0),
    .dis_7seg_1(dis_7seg_1),
    .dis_7seg_2(dis_7seg_2),
    .dis_7seg_3(dis_7seg_3),
    .dis_7seg_4(dis_7seg_4),
    .dis_7seg_5(dis_7seg_5),
    .dis_7seg_6(dis_7seg_6),
    .dis_7seg_7(dis_7seg_7)
  );

  crc_inserter  crc_inserter_inst (
    .clk(clk),
    .rst_n(rst_n),
    .asi_data(as_arp_crcins_data),
    .asi_valid(as_arp_crcins_valid),
    .asi_ready(as_arp_crcins_ready),
    .asi_sop(as_arp_crcins_sop),
    .asi_eop(as_arp_crcins_eop),
    .aso_data(as_crcins_dcf1_data),
    .aso_valid(as_crcins_dcf1_valid),
    .aso_ready(as_crcins_dcf1_ready),
    .aso_sop(as_crcins_dcf1_sop),
    .aso_eop(as_crcins_dcf1_eop)
  );

  dc_fifo  dc_fifo_inst_1 (
    .dc_fifo_0_in_data(as_crcins_dcf1_data),
    .dc_fifo_0_in_valid(as_crcins_dcf1_valid),
    .dc_fifo_0_in_ready(as_crcins_dcf1_ready),
    .dc_fifo_0_in_startofpacket(as_crcins_dcf1_sop),
    .dc_fifo_0_in_endofpacket(as_crcins_dcf1_eop),
    .dc_fifo_0_in_error(1'd0),
    .dc_fifo_0_in_clk_clk(clk),
    .dc_fifo_0_in_clk_reset_reset_n(rst_n),
    
    .dc_fifo_0_out_data(as_dcf1_tran_data),
    .dc_fifo_0_out_valid(as_dcf1_tran_valid),
    .dc_fifo_0_out_ready(as_dcf1_tran_ready),
    .dc_fifo_0_out_startofpacket(as_dcf1_tran_sop),
    .dc_fifo_0_out_endofpacket(as_dcf1_tran_eop),
    .dc_fifo_0_out_error(),
    .dc_fifo_0_out_clk_clk(tx_clk),
    .dc_fifo_0_out_clk_reset_reset_n(rst_n)
  );

  phy_transmitter phy_transmitter_inst (
    .rst_n(rst_n),
    .txd(txd),
    .tx_clk(tx_clk),
    .tx_en(tx_en),
    .asi_data(as_dcf1_tran_data),
    .asi_valid(as_dcf1_tran_valid),
    .asi_ready(as_dcf1_tran_ready),
    .asi_sop(as_dcf1_tran_sop),
    .asi_eop(as_dcf1_tran_eop)
  );


  assign rst_n_marvel = rst_n;

  endmodule