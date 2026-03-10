
module sc_fifo (
	sc_fifo_0_clk_clk,
	sc_fifo_0_clk_reset_reset,
	sc_fifo_0_csr_address,
	sc_fifo_0_csr_read,
	sc_fifo_0_csr_write,
	sc_fifo_0_csr_readdata,
	sc_fifo_0_csr_writedata,
	sc_fifo_0_in_data,
	sc_fifo_0_in_valid,
	sc_fifo_0_in_ready,
	sc_fifo_0_in_startofpacket,
	sc_fifo_0_in_endofpacket,
	sc_fifo_0_in_error,
	sc_fifo_0_out_data,
	sc_fifo_0_out_valid,
	sc_fifo_0_out_ready,
	sc_fifo_0_out_startofpacket,
	sc_fifo_0_out_endofpacket,
	sc_fifo_0_out_error);	

	input		sc_fifo_0_clk_clk;
	input		sc_fifo_0_clk_reset_reset;
	input	[2:0]	sc_fifo_0_csr_address;
	input		sc_fifo_0_csr_read;
	input		sc_fifo_0_csr_write;
	output	[31:0]	sc_fifo_0_csr_readdata;
	input	[31:0]	sc_fifo_0_csr_writedata;
	input	[7:0]	sc_fifo_0_in_data;
	input		sc_fifo_0_in_valid;
	output		sc_fifo_0_in_ready;
	input		sc_fifo_0_in_startofpacket;
	input		sc_fifo_0_in_endofpacket;
	input	[0:0]	sc_fifo_0_in_error;
	output	[7:0]	sc_fifo_0_out_data;
	output		sc_fifo_0_out_valid;
	input		sc_fifo_0_out_ready;
	output		sc_fifo_0_out_startofpacket;
	output		sc_fifo_0_out_endofpacket;
	output	[0:0]	sc_fifo_0_out_error;
endmodule
