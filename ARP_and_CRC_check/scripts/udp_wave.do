onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /udp_service_tb/udp_service_inst/IP_ADDRESS
add wave -noupdate /udp_service_tb/udp_service_inst/MAC_ADDRESS
add wave -noupdate /udp_service_tb/udp_service_inst/clk
add wave -noupdate /udp_service_tb/udp_service_inst/rst_n
add wave -noupdate /udp_service_tb/udp_service_inst/asi_data
add wave -noupdate /udp_service_tb/udp_service_inst/asi_valid
add wave -noupdate /udp_service_tb/udp_service_inst/asi_ready
add wave -noupdate /udp_service_tb/udp_service_inst/asi_sop
add wave -noupdate /udp_service_tb/udp_service_inst/asi_eop
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_0
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_1
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_2
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_3
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_4
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_5
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_6
add wave -noupdate /udp_service_tb/udp_service_inst/dis_7seg_7
add wave -noupdate /udp_service_tb/udp_service_inst/w_out_conv
add wave -noupdate /udp_service_tb/udp_service_inst/r_7seg
add wave -noupdate -radix hexadecimal /udp_service_tb/udp_service_inst/correct_data
add wave -noupdate -radix unsigned /udp_service_tb/udp_service_inst/r_skip
add wave -noupdate -radix unsigned /udp_service_tb/udp_service_inst/r_byte_counter
add wave -noupdate /udp_service_tb/udp_service_inst/w_asi_ta
add wave -noupdate /udp_service_tb/udp_service_inst/w_asi_eta
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {501356 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {293450 ps} {599082 ps}
