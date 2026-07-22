# Ripple Up Counter

## Overview

A Ripple Up Counter is an asynchronous sequential circuit in which the output of one flip-flop serves as the clock input for the next flip-flop. The counter increments its value with each incoming clock pulse and propagates changes through successive stages.

This design uses T Flip-Flops to implement a multi-bit Ripple Up Counter in Verilog HDL and is verified through simulation.

---

## Counter Sequence

```text
0000 → 0001 → 0010 → 0011 → 0100 → ...
...
1110 → 1111 → 0000
```

The counter continuously increments and wraps around after reaching its maximum count value.

---

## Specifications

| Parameter | Value |
|------------|---------|
| Counter Type | Ripple (Asynchronous) Up Counter |
| Flip-Flop Type | T Flip-Flop |
| Clocking | Asynchronous |
| Count Direction | Up |
| HDL | Verilog |

---

## Files Included

| File Name | Description |
|------------|-------------|
| `t_flipflop.v` | Verilog implementation of T Flip-Flop |
| `ripple_up_counter.v` | Ripple Up Counter design |
| `ripple_up_counter_tb.v` | Testbench for simulation |
| `waveform.png` | GTKWave simulation waveform |

---

## Design Description

The Ripple Up Counter is constructed using cascaded T Flip-Flops.

### Operation

- The first flip-flop is driven by the external clock.
- Each subsequent flip-flop is triggered by the output of the previous flip-flop.
- The count value increments on every clock pulse.
- Due to propagation delay between stages, output transitions ripple through the counter.

---

## Simulation

The design was simulated using Verilator and GTKWave.

### Compile

```bash
verilator --binary t_flipflop.v ripple_up_counter.v ripple_up_counter_tb.v
```

### Run Simulation

```bash
./obj_dir/Vripple_up_counter
```

### View Waveform

```bash
gtkwave dump.vcd
```

---

## Expected Results

- Counter increments on each clock pulse.
- Binary sequence progresses from 0 to maximum count value.
- Output wraps around after reaching the maximum count.
- Ripple effect can be observed due to asynchronous operation.
- Simulation results match expected counter behavior.

---

## Waveform

The generated simulation waveform is available in:

```text
waveform.png
```

---

## Applications

- Event Counters
- Frequency Division Circuits
- Digital Clocks
- Timing Circuits
- Embedded Systems
- Educational Demonstration of Asynchronous Counters

---

## Learning Outcomes

- Understanding asynchronous sequential circuits.
- Implementing T Flip-Flops in Verilog HDL.
- Designing Ripple Counters using cascaded flip-flops.
- Analyzing propagation delay effects.
- Verifying sequential logic using simulation waveforms.

---
