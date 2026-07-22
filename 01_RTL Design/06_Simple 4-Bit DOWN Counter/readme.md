# 4-Bit Down Counter

## Overview

A 4-Bit Down Counter is a sequential logic circuit that decrements its count value by one on every active clock edge. It is widely used in digital systems for countdown operations, timing applications, and control logic.

This design is implemented in Verilog HDL and verified using simulation.

---

## Counter Sequence

```text
1111 → 1110 → 1101 → 1100 → ...
...
0010 → 0001 → 0000 → 1111
```

The counter automatically wraps around to its maximum value after reaching zero.

---

## Specifications

| Parameter | Value |
|------------|---------|
| Counter Width | 4 Bits |
| Maximum Count | 15 (1111) |
| Minimum Count | 0 (0000) |
| Clock Trigger | Positive Edge |
| Counter Type | Down Counter |

---

## Files Included

| File Name | Description |
|------------|-------------|
| `down_counter_4bit.v` | Verilog design file for 4-bit Down Counter |
| `down_counter_tb.v` | Testbench used for simulation |
| `waveform.png` | GTKWave simulation waveform |

---

## Design Description

The counter decreases its value by one on every rising edge of the clock signal.

### Operation

- Initial count starts from 15 (1111).
- Count decreases by 1 for each clock pulse.
- After reaching 0 (0000), the counter rolls over to 15 (1111).
- The counting process repeats continuously.

---

## Simulation

The design was simulated using Verilator and GTKWave.

### Compile

```bash
verilator --binary down_counter_4bit.v down_counter_tb.v
```

### Run Simulation

```bash
./obj_dir/Vdown_counter_4bit
```

### View Waveform

```bash
gtkwave dump.vcd
```

---

## Expected Results

- Counter decrements on every clock edge.
- Binary count progresses sequentially from 15 to 0.
- Counter rolls over to 15 after reaching 0.
- Simulation results match the expected countdown sequence.

---

## Waveform

The generated simulation waveform is available in:

```text
waveform.png
```

---

## Applications

- Digital Timers
- Countdown Systems
- Control Logic
- Event Monitoring
- Embedded Systems
- State Machines

---

## Learning Outcomes

- Understanding sequential logic design.
- Implementing synchronous counters in Verilog HDL.
- Working with clock-driven circuits.
- Writing testbenches for counter verification.
- Analyzing waveform behavior using GTKWave.

---
