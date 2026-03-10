## Generated SDC file "ARP_and_CRC_check.sdc"

## Copyright (C) 2023  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 23.1std.0 Build 991 11/28/2023 SC Lite Edition"

## DATE    "Mon Dec 18 03:07:56 2023"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]
create_clock -name {rx_clk} -period 40.000 -waveform { 0.000 20.000 } [get_ports {rx_clk}]
create_clock -name {tx_clk} -period 40.000 -waveform { 0.000 20.000 } [get_ports {tx_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {tx_clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {tx_clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {rx_clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {rx_clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {tx_clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {tx_clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {rx_clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {rx_clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {tx_clk}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {tx_clk}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {tx_clk}] -rise_to [get_clocks {tx_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {tx_clk}] -fall_to [get_clocks {tx_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {tx_clk}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {tx_clk}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {tx_clk}] -rise_to [get_clocks {tx_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {tx_clk}] -fall_to [get_clocks {tx_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {rx_clk}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {rx_clk}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {rx_clk}] -rise_to [get_clocks {rx_clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {rx_clk}] -fall_to [get_clocks {rx_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {rx_clk}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {rx_clk}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {rx_clk}] -rise_to [get_clocks {rx_clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {rx_clk}] -fall_to [get_clocks {rx_clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_addr[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_enable}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {error_value[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rst_n}]
set_input_delay -add_delay  -clock [get_clocks {rx_clk}]  1.000 [get_ports {rx_dv}]
set_input_delay -add_delay  -clock [get_clocks {rx_clk}]  1.000 [get_ports {rx_er}]
set_input_delay -add_delay  -clock [get_clocks {rx_clk}]  1.000 [get_ports {rxd[0]}]
set_input_delay -add_delay  -clock [get_clocks {rx_clk}]  1.000 [get_ports {rxd[1]}]
set_input_delay -add_delay  -clock [get_clocks {rx_clk}]  1.000 [get_ports {rxd[2]}]
set_input_delay -add_delay  -clock [get_clocks {rx_clk}]  1.000 [get_ports {rxd[3]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_0[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_1[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_2[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_3[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_4[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_5[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_6[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {dis_7seg_7[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {out_error}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rst_n_marvel}]
set_output_delay -add_delay  -clock [get_clocks {tx_clk}]  1.000 [get_ports {tx_en}]
set_output_delay -add_delay  -clock [get_clocks {tx_clk}]  1.000 [get_ports {txd[0]}]
set_output_delay -add_delay  -clock [get_clocks {tx_clk}]  1.000 [get_ports {txd[1]}]
set_output_delay -add_delay  -clock [get_clocks {tx_clk}]  1.000 [get_ports {txd[2]}]
set_output_delay -add_delay  -clock [get_clocks {tx_clk}]  1.000 [get_ports {txd[3]}]


#**************************************************************
# Set Clock Groups
#**************************************************************


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

