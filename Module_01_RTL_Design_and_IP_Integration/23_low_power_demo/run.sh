#!/bin/bash

verilator --binary \
counter_baseline.v \
counter_clk_gate.v \
counter_pwr_gate.v \
low_power_tb.v \
--top low_power_tb \
--timing \
--trace

cd obj_dir || exit

./Vlow_power_tb

gtkwave dump.vcd
