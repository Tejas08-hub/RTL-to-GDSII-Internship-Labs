create_clock -period 5 -name clk [get_ports clk]
set_input_delay 5 -min -rise [get_ports clk] -clock clk
set_input_delay 5 -max -fall [get_ports {rst data_in}] -clock clk
set_input_transition 5 -min -rise [get_ports {rst data_in}] -clock clk
set_input_transition 5 -max -fall [get_ports clk] -clock clk
set_load -pin_load 4 [get_ports q]

set_output_delay 2 -min -rise [get_ports q] -clock clk
