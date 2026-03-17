onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lfsr_counter_tb/g_steps
add wave -noupdate /lfsr_counter_tb/g_size
add wave -noupdate /lfsr_counter_tb/g_seed
add wave -noupdate -radix hexadecimal /lfsr_counter_tb/c_in_seed
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/g_size
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/g_state
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/i_clk
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/i_rst_n
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/o_trigger
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/r_state
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/r_trigger
add wave -noupdate -expand -group lfsr_counter /lfsr_counter_tb/lfsr_counter_inst/r_overload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9573 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {139319 ps}
