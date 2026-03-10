onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arp_service_tb/arp_service_inst/IP_ADDRESS
add wave -noupdate /arp_service_tb/arp_service_inst/MAC_ADDRESS
add wave -noupdate /arp_service_tb/arp_service_inst/clk
add wave -noupdate /arp_service_tb/arp_service_inst/rst_n
add wave -noupdate -expand -group asi /arp_service_tb/arp_service_inst/asi_data
add wave -noupdate -expand -group asi /arp_service_tb/arp_service_inst/asi_valid
add wave -noupdate -expand -group asi /arp_service_tb/arp_service_inst/asi_ready
add wave -noupdate -expand -group asi /arp_service_tb/arp_service_inst/asi_sop
add wave -noupdate -expand -group asi /arp_service_tb/arp_service_inst/asi_eop
add wave -noupdate -expand -group aso /arp_service_tb/arp_service_inst/aso_data
add wave -noupdate -expand -group aso /arp_service_tb/arp_service_inst/aso_valid
add wave -noupdate -expand -group aso /arp_service_tb/arp_service_inst/aso_ready
add wave -noupdate -expand -group aso /arp_service_tb/arp_service_inst/aso_sop
add wave -noupdate -expand -group aso /arp_service_tb/arp_service_inst/aso_eop
add wave -noupdate /arp_service_tb/arp_service_inst/src_ip_addr
add wave -noupdate /arp_service_tb/arp_service_inst/src_mac_addr
add wave -noupdate /arp_service_tb/arp_service_inst/correct_data
add wave -noupdate /arp_service_tb/arp_service_inst/sending_data
add wave -noupdate /arp_service_tb/arp_service_inst/r_sending
add wave -noupdate /arp_service_tb/arp_service_inst/r_skip
add wave -noupdate /arp_service_tb/arp_service_inst/r_eop
add wave -noupdate /arp_service_tb/arp_service_inst/r_byte_counter
add wave -noupdate /arp_service_tb/arp_service_inst/w_asi_ta
add wave -noupdate /arp_service_tb/arp_service_inst/w_asi_eta
add wave -noupdate /arp_service_tb/arp_service_inst/w_aso_ta
add wave -noupdate /arp_service_tb/arp_service_inst/w_aso_eta
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {916201 ps}
