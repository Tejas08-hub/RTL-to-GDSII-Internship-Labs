# JK Flip-Flop

## Overview

A JK Flip-Flop is a sequential logic circuit used for storing one bit of data. It is an improved version of the SR Flip-Flop that eliminates the invalid state condition.

The JK Flip-Flop changes its output based on the inputs **J**, **K**, and the clock signal.

---

## Truth Table

| J | K | Q(next) | Operation |
|---|---|----------|-----------|
| 0 | 0 | Q        | No Change |
| 0 | 1 | 0        | Reset |
| 1 | 0 | 1        | Set |
| 1 | 1 | Q̅        | Toggle |

---

## Files Included

| File Name | Description |
|------------|-------------|
| `jk_flipflop.v` | Verilog design file for JK Flip-Flop |
| `jk_flipflop_tb.v` | Testbench used for simulation |
| `waveform.png` | GTKWave simulation waveform |

---

## Design Description

The JK Flip-Flop is a clocked sequential circuit that stores one bit of information.

### Operations

- **J = 0, K = 0** → Output remains unchanged.
- **J = 0, K = 1** → Output is reset to 0.
- **J = 1, K = 0** → Output is set to 1.
- **J = 1, K = 1** → Output toggles on every active clock edge.

The output updates only on the triggering edge of the clock.

---

## Simulation

The design was simulated using Verilator and GTKWave.

### Compile

```bash
verilator --binary jk_flipflop.v jk_flipflop_tb.v
```

### Run Simulation

```bash
./obj_dir/Vjk_flipflop
```

### View Waveform

```bash
gtkwave dump.vcd
```

---

## Expected Results

- Output remains unchanged when J = K = 0.
- Output resets when J = 0 and K = 1.
- Output sets when J = 1 and K = 0.
- Output toggles when J = K = 1.
- Simulation results match the JK Flip-Flop truth table.

---

## Waveform

The generated simulation waveform is available in:

```text
waveform.png
```

---

## Applications

- Counters
- Frequency Dividers
- Shift Registers
- State Machines
- Digital Storage Elements

---

## Learning Outcomes

- Understanding sequential logic circuits.
- Implementing edge-triggered flip-flops in Verilog.
- Writing testbenches for sequential designs.
- Verifying circuit behavior using simulation waveforms.
- Understanding state storage and toggling operations.

---
