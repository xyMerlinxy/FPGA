# Create project
project_new lfsr -overwrite

# Device settings - Cyclone V on DE0-CV
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CEBA4F23C7

# Project settings
set_global_assignment -name TOP_LEVEL_ENTITY lfsr
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

foreach f [glob -nocomplain ../../sdc/*.sdc] {
    set_global_assignment -name SDC_FILE $f
}

# Save and close
export_assignments