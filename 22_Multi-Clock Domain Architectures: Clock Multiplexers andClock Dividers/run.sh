#!/bin/bash

verilator --binary clk_mux.v clk_divider.v multi_clk_tb.v \
--top multi_clk_tb \
--timing \
--trace

cd obj_dir || exit

./Vmulti_clk_tb

gtkwave dump.vcd
