# Create project
project_new ECDSA -overwrite

# Device settings - Cyclone V on DE0-CV
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CEBA4F23C8

# Project settings
set_global_assignment -name TOP_LEVEL_ENTITY point_mul_lad
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

# VHDL version
set_global_assignment -name VHDL_INPUT_VERSION VHDL_1993

# Add all VHDL files from rtl and subdirectories
foreach f [glob -nocomplain ../../rtl/*.vhd] {
    set_global_assignment -name VHDL_FILE $f
}
foreach f [glob -nocomplain ../../rtl/**/*.vhd] {
    set_global_assignment -name VHDL_FILE $f
}

# Add all Verilog files from rtl and subdirectories
foreach f [glob -nocomplain ../../rtl/*.v] {
    set_global_assignment -name Verilog_FILE $f
}
foreach f [glob -nocomplain ../../rtl/**/*.v] {
    set_global_assignment -name Verilog_FILE $f
}

foreach f [glob -nocomplain ../../sdc/*.sdc] {
    set_global_assignment -name SDC_FILE $f
}


# add virtual pin assignments
set_instance_assignment -name VIRTUAL_PIN ON -to rst_n
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_x
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_y
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_z
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_mul
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_wr
set_instance_assignment -name VIRTUAL_PIN ON -to o_data_x
set_instance_assignment -name VIRTUAL_PIN ON -to o_data_y
set_instance_assignment -name VIRTUAL_PIN ON -to o_data_z
set_instance_assignment -name VIRTUAL_PIN ON -to o_valid
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_a
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_b
set_instance_assignment -name VIRTUAL_PIN ON -to i_operation
set_instance_assignment -name VIRTUAL_PIN ON -to o_data
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_x1
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_x2
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_y1
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_y2
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_z1
set_instance_assignment -name VIRTUAL_PIN ON -to i_data_z2

# Save and close
export_assignments