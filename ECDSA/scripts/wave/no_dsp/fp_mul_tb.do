onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fp_mul_tb/fp_mul_inst/MOD_P
add wave -noupdate /fp_mul_tb/fp_mul_inst/clk
add wave -noupdate /fp_mul_tb/fp_mul_inst/rst_n
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_state
add wave -noupdate /fp_mul_tb/fp_mul_inst/i_data_a
add wave -noupdate /fp_mul_tb/fp_mul_inst/i_data_b
add wave -noupdate /fp_mul_tb/fp_mul_inst/i_data_wr
add wave -noupdate /fp_mul_tb/fp_mul_inst/o_data
add wave -noupdate /fp_mul_tb/fp_mul_inst/o_valid
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_in_a
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_in_b
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_out
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_bit_cnt
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_o_valid
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_as_data_b
add wave -noupdate /fp_mul_tb/fp_mul_inst/w_as_data_out
add wave -noupdate /fp_mul_tb/fp_mul_inst/r_as_data_wr
add wave -noupdate /fp_mul_tb/fp_mul_inst/w_as_valid
add wave -noupdate -expand -group add /fp_mul_tb/fp_mul_inst/fp_add_inst/i_data_a
add wave -noupdate -expand -group add /fp_mul_tb/fp_mul_inst/fp_add_inst/i_data_b
add wave -noupdate -expand -group add /fp_mul_tb/fp_mul_inst/fp_add_inst/i_data_wr
add wave -noupdate -expand -group add /fp_mul_tb/fp_mul_inst/fp_add_inst/o_data
add wave -noupdate -expand -group add /fp_mul_tb/fp_mul_inst/fp_add_inst/o_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23980709 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 345
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
configure wave -timelineunits ps
update
WaveRestoreZoom {163854171 ps} {164265570 ps}
