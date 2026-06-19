# 4-Bit Up Counter

## Overview

A 4-Bit Up Counter is a sequential circuit that increments its count value by one on every active clock edge. It is commonly used in digital systems for counting events, generating timing sequences, and frequency division.

This design is implemented in Verilog HDL and verified through simulation.

---

## Counter Sequence

```text
0000 → 0001 → 0010 → 0011 → 0100 → ...
...
1110 → 1111 → 0000
```

The counter automatically wraps around to zero after reaching its maximum count value.

---

## Specifications

| Parameter | Value |
|------------|---------|
| Counter Width | 4 Bits |
| Maximum Count | 15 (1111) |
| Minimum Count | 0 (0000) |
| Clock Trigger | Positive Edge |
| Counter Type | Up Counter |

---

## Files Included

| File Name | Description |
|------------|-------------|
| `up_counter_4bit.v` | Verilog design file for 4-bit Up Counter |
| `up_counter_tb.v` | Testbench used for simulation |
| `waveform.png` | GTKWave simulation waveform |

---

## Design Description

The counter increments its value by one on every rising edge of the clock signal.

### Operation

- Initial count starts from 0.
- Count increases by 1 for each clock pulse.
- After reaching 15 (1111), the counter rolls over to 0 (0000).
- The process repeats continuously.

---

## Simulation

The design was simulated using Verilator and GTKWave.

### Compile

```bash
verilator --binary up_counter_4bit.v up_counter_tb.v
```

### Run Simulation

```bash
./obj_dir/Vup_counter_4bit
```

### View Waveform

```bash
gtkwave dump.vcd
```

---

## Expected Results

- Counter increments on every clock edge.
- Binary count progresses sequentially from 0 to 15.
- Counter resets to 0 after reaching 15.
- Simulation results match the expected counting sequence.

---

## Waveform

The generated simulation waveform is available in:

```text
waveform.png
```

---

## Applications

- Digital Clocks
- Frequency Dividers
- Event Counters
- Timers
- State Machines
- Control Systems

---

## Learning Outcomes

- Understanding sequential logic design.
- Implementing counters using Verilog HDL.
- Working with clock-driven circuits.
- Writing testbenches for sequential systems.
- Verifying counter operation through waveform analysis.

---
