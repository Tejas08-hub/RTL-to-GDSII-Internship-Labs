# Half Adder

## Overview
A Half Adder is a basic combinational circuit used to perform the addition of two single-bit binary numbers. It produces two outputs:

- **Sum (S)** – Result of binary addition
- **Carry (C)** – Carry generated from the addition

This design is implemented in Verilog HDL and verified using a testbench simulation.

---

## Truth Table

| A | B | Sum | Carry |
|---|---|-----|--------|
| 0 | 0 |  0  |   0    |
| 0 | 1 |  1  |   0    |
| 1 | 0 |  1  |   0    |
| 1 | 1 |  0  |   1    |

---

## Logic Equations

```text
Sum   = A XOR B
Carry = A AND B
```

---

## Files Included

| File Name | Description |
|------------|-------------|
| `half_adder.v` | Verilog design file for Half Adder |
| `half_adder_tb.v` | Testbench used for simulation |
| `waveform.png` | GTKWave simulation waveform |

---

## Design Description

The Half Adder takes two 1-bit inputs (`A` and `B`) and generates:

- Sum using XOR operation
- Carry using AND operation

This circuit does not consider any carry input from a previous stage.

---

## Simulation

The design was simulated using Verilator and GTKWave.

### Compile

```bash
verilator --binary half_adder.v half_adder_tb.v
```

### Run Simulation

```bash
./obj_dir/Vhalf_adder
```

### View Waveform

```bash
gtkwave dump.vcd
```

---

## Expected Results

- Sum becomes HIGH when exactly one input is HIGH.
- Carry becomes HIGH only when both inputs are HIGH.
- Simulation results match the Half Adder truth table.

---

## Waveform

The generated simulation waveform is available in:

```text
waveform.png
```

---

## Learning Outcomes

- Understanding combinational logic design in Verilog.
- Implementing XOR and AND based arithmetic circuits.
- Writing Verilog testbenches.
- Performing simulation and waveform verification using GTKWave.

---
