create_clock -name i_clk -period 5.000 [get_ports {i_clk}]

set_input_delay -clock i_clk 0 [get_ports {i_rst_n}]

set_output_delay -clock i_clk 0 [get_ports {o_*}]
