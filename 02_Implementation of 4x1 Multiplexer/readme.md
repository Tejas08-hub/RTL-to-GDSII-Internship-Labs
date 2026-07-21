# 4:1 Multiplexer

## Objective

Design and verify a 4:1 Multiplexer using Verilog HDL with different modeling styles.

## Theory

A 4:1 Multiplexer selects one of four input signals and forwards it to the output based on the select lines.

### Truth Table

| S1 | S0 | Output |
|----|----|--------|
| 0  | 0  | I0 |
| 0  | 1  | I1 |
| 1  | 0  | I2 |
| 1  | 1  | I3 |

## Implementations

### Gate-Level Modeling
Implementation using basic logic gates.

Files:
- `mux_using_gate.v`
- `mux_using_gate_tb.v`

### Dataflow Modeling
Implementation using continuous assignment statements.

Files:
- `mux_dataflow.v`
- `mux_dataflow_tb.v`

## Simulation Tool

- Verilator
- GTKWave

## Result

The 4:1 Multiplexer was successfully designed and verified using Gate-Level and Dataflow modeling styles. The simulation output matched the expected functionality for all select line combinations.

## Waveform

Refer to `waveform.png` for simulation results.
