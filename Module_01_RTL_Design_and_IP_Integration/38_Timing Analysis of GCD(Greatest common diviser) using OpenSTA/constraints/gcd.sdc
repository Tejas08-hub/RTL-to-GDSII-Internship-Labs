# Clock
create_clock -period 5 -name clk [get_ports clk]

# Input delays
set_input_delay 5 -min -rise [get_ports clk] -clock clk
set_input_delay 5 -min -rise [get_ports {rst start A B}] -clock clk

# Input transitions
set_input_transition 15 -min -fall [get_ports {rst start A B}] -clock clk
set_input_transition 15 -max -fall [get_ports clk] -clock clk

# Output load
set_load -pin_load 4 [get_ports {done result}]

# Output delay
set_output_delay 5 -max -rise [get_ports {done result}] -clock clk
