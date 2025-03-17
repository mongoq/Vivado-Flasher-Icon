# Open Hardware Manager and connect to the JTAG server
open_hw_manager
connect_hw_server
open_hw_target

# Get the project directory and project name
set project_dir [get_property DIRECTORY [current_project]]
set project_name [file tail $project_dir]

# Ensure the project directory exists
if {$project_dir eq ""} {
    puts "ERROR: No open project found!"
    close_hw_manager
    exit 1
}

# Try to search for the bitstream in the default location
puts "Searching for bitstream in: $project_dir/runs/impl_1/"
set available_bitstreams [glob -nocomplain "$project_dir/runs/impl_1/*.bit"]

# If nothing is found, try the alternate directory with project name in it
if {$available_bitstreams eq ""} {
    puts "No bitstream found in $project_dir/runs/impl_1/, trying $project_dir/${project_name}.runs/impl_1/"
    set available_bitstreams [glob -nocomplain "$project_dir/${project_name}.runs/impl_1/*.bit"]
}

puts "Found bitstreams: $available_bitstreams"
set bitstream_file [lindex $available_bitstreams 0]

# Check if a valid bitstream file was found
if {$bitstream_file eq ""} {
    puts "ERROR: No valid bitstream (*.bit) found in either:"
    puts "       $project_dir/runs/impl_1/ or"
    puts "       $project_dir/${project_name}.runs/impl_1/"
    close_hw_manager
    exit 1
}

puts "Using bitstream: $bitstream_file"

# Set the bitstream file and program the FPGA
set_property PROGRAM.FILE $bitstream_file [current_hw_device]
program_hw_devices

# Close Hardware Manager
close_hw_manager
puts "FPGA successfully programmed with $bitstream_file!"
