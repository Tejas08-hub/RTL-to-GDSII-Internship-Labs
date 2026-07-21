create_clock -period 10 -name clk [get_ports clk]

set_input_delay 0 -min -rise [get_ports clk] -clock clk

set_input_delay 5 -max -fall [get_ports rst] -clock clk

set_input_transition 10 -min -rise [get_ports rst] -clock clk

set_input_transition 25 -max -fall [get_ports clk] -clock clk

set_load -pin_load 4 [get_ports out]

set_output_delay 2 -min -rise [get_ports out] -clock clk
