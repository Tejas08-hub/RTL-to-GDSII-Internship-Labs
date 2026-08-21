create_clock -name clk -period 20.0 [get_ports clk]
set_input_delay 0.0 -clock clk [get_ports reset]
set_input_delay 0.0 -clock clk [get_ports uart_rx]
set_output_delay 0.0 -clock clk [get_ports uart_tx]
