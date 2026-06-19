# AND Gate

## Objective
Design and verify a 2-input AND gate using Verilog HDL.

## Theory
An AND gate produces logic HIGH (`1`) only when all inputs are HIGH (`1`).

### Truth Table

| A | B | Y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

## Files

- `and_gate.v` - Verilog design module
- `and_gate_tb.v` - Testbench for simulation
- `waveform.png` - Simulation waveform

## Simulation Tool

- Verilator
- GTKWave

## Result

The AND gate was successfully designed and verified. Simulation results matched the expected truth table.

## Waveform

Refer to `waveform.png` for simulation results.
