#!/bin/bash
verilator --binary sync2_stage.v sync3_stage.v sync_tb.v \
--top sync_tb \
--timing \
--trace
cd obj_dir || exit
./Vsync_tb
gtkwave dump.vcd
