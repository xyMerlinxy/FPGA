onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fp_as_tb/fp_as_inst/MOD_P
add wave -noupdate /fp_as_tb/fp_as_inst/clk
add wave -noupdate /fp_as_tb/fp_as_inst/rst_n
add wave -noupdate /fp_as_tb/fp_as_inst/i_data_a
add wave -noupdate /fp_as_tb/fp_as_inst/i_data_b
add wave -noupdate /fp_as_tb/fp_as_inst/i_data_wr
add wave -noupdate /fp_as_tb/fp_as_inst/i_operation
add wave -noupdate /fp_as_tb/fp_as_inst/o_data
add wave -noupdate /fp_as_tb/fp_as_inst/o_valid
add wave -noupdate /fp_as_tb/fp_as_inst/r_in_a
add wave -noupdate /fp_as_tb/fp_as_inst/r_in_b
add wave -noupdate /fp_as_tb/fp_as_inst/r_in_operation
add wave -noupdate /fp_as_tb/fp_as_inst/r_state
add wave -noupdate /fp_as_tb/fp_as_inst/r_add_data_a
add wave -noupdate /fp_as_tb/fp_as_inst/r_add_data_b
add wave -noupdate /fp_as_tb/fp_as_inst/r_sub_data_a
add wave -noupdate /fp_as_tb/fp_as_inst/r_sub_data_b
add wave -noupdate /fp_as_tb/fp_as_inst/r_sub_output
add wave -noupdate /fp_as_tb/fp_as_inst/r_add_output
add wave -noupdate /fp_as_tb/fp_as_inst/r_carry_add
add wave -noupdate /fp_as_tb/fp_as_inst/r_carry_sub
add wave -noupdate /fp_as_tb/fp_as_inst/r_valid
add wave -noupdate /fp_as_tb/fp_as_inst/r_output
add wave -noupdate /fp_as_tb/fp_as_inst/r_carry
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
