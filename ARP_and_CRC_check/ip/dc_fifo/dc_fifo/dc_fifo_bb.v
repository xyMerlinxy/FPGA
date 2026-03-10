
module dc_fifo (
	dc_fifo_0_in_clk_clk,
	dc_fifo_0_in_clk_reset_reset_n,
	dc_fifo_0_out_clk_clk,
	dc_fifo_0_out_clk_reset_reset_n,
	dc_fifo_0_in_data,
	dc_fifo_0_in_valid,
	dc_fifo_0_in_ready,
	dc_fifo_0_in_startofpacket,
	dc_fifo_0_in_endofpacket,
	dc_fifo_0_in_error,
	dc_fifo_0_out_data,
	dc_fifo_0_out_valid,
	dc_fifo_0_out_ready,
	dc_fifo_0_out_startofpacket,
	dc_fifo_0_out_endofpacket,
	dc_fifo_0_out_error);	

	input		dc_fifo_0_in_clk_clk;
	input		dc_fifo_0_in_clk_reset_reset_n;
	input		dc_fifo_0_out_clk_clk;
	input		dc_fifo_0_out_clk_reset_reset_n;
	input	[7:0]	dc_fifo_0_in_data;
	input		dc_fifo_0_in_valid;
	output		dc_fifo_0_in_ready;
	input		dc_fifo_0_in_startofpacket;
	input		dc_fifo_0_in_endofpacket;
	input	[0:0]	dc_fifo_0_in_error;
	output	[7:0]	dc_fifo_0_out_data;
	output		dc_fifo_0_out_valid;
	input		dc_fifo_0_out_ready;
	output		dc_fifo_0_out_startofpacket;
	output		dc_fifo_0_out_endofpacket;
	output	[0:0]	dc_fifo_0_out_error;
endmodule
