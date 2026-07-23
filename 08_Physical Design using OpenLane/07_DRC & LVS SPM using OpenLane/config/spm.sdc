create_clock -name clk -period 10 [get_ports clk]

set_input_delay 2 -clock clk [get_ports {x[*] y}]
set_output_delay 2 -clock clk [get_ports p]

set_false_path -from [get_ports rst]
