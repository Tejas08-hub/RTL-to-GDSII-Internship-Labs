# Timing Analysis of D Flip-Flop using OpenSTA

## Overview

This project demonstrates the **Static Timing Analysis (STA)** of a synthesized **D Flip-Flop** using **OpenSTA**. The RTL design is synthesized using **Yosys** with the **OSU018 standard cell library**, followed by timing analysis under different clock constraints (10 ns and 5 ns).

The objective is to understand setup and hold timing analysis, identify critical timing paths, and verify whether the design satisfies the specified timing constraints.

---

## Objectives

- Design a D Flip-Flop using Verilog HDL.
- Synthesize the RTL design using Yosys.
- Generate a gate-level netlist using the OSU018 standard cell library.
- Apply timing constraints using an SDC file.
- Perform Static Timing Analysis using OpenSTA.
- Analyze setup and hold timing reports.
- Compare timing performance for different clock periods.

---

## Applications

D Flip-Flops are widely used in digital systems for:

- Registers
- Shift Registers
- Counters
- Finite State Machines (FSMs)
- Data Synchronization
- Pipeline Registers
- Memory Elements
- Sequential Logic Design

---

## Tools Used

| Tool | Purpose |
|------|----------|
| Verilog HDL | RTL Design |
| Yosys | Logic Synthesis |
| OpenSTA | Static Timing Analysis |
| OSU018 Standard Cell Library | Technology Library |
| gVim | Source Code Editing |
| Ubuntu Linux | Development Environment |

---

## Project Structure

```text
36_Timing Analysis of D Flip-Flop using OpenSTA
│
├── constraints
│   └── d_ff.sdc
│
├── reports
│   ├── setup_10ns.txt
│   ├── hold_10ns.txt
│   ├── setup_5ns.txt
│   └── hold_5ns.txt
│
├── rtl
│   └── d_ff.v
│
├── screenshots
│   ├── setup_10ns.png
│   ├── hold_10ns.png
│   ├── setup_5ns.png
│   └── hold_5ns.png
│
├── synthesis
│   ├── d_ff.ys
│   └── d_ff_synth.v
│
└── README.md
```

---

# RTL Design

The design implements a positive-edge triggered D Flip-Flop with synchronous reset.

```verilog
module d_ff(
    input clk,
    input rst,
    input d,
    output reg q
);

always @(posedge clk)
begin
    if(rst)
        q <= 0;
    else
        q <= q;
end

endmodule
```

---

# Synthesis Flow

The RTL was synthesized using **Yosys** with the **OSU018 standard cell library**.

Main synthesis steps:

1. Read Verilog RTL
2. Perform synthesis
3. Map sequential cells
4. Technology mapping
5. Generate gate-level netlist

Generated File:

- `d_ff_synth.v`

---

# Static Timing Analysis Flow

OpenSTA Commands:

```tcl
read_liberty osu018_stdcells.lib

read_verilog d_ff_synth.v

link_design d_ff

read_sdc d_ff.sdc

report_checks
```

---

# Timing Constraints

Two timing constraints were analyzed:

- Clock Period = **10 ns**
- Clock Period = **5 ns**

The constraints include:

- Clock Definition
- Input Delay
- Output Delay
- Input Transition
- Output Load

---

# Timing Results

## Setup Analysis

### 10 ns Clock

- Setup Slack = **4.77 ns**
- Status = ✅ MET

### 5 ns Clock

- Setup Slack = **-0.23 ns**
- Status = ❌ VIOLATED

---

## Hold Analysis

### 10 ns Clock

- Hold Slack = **5.68 ns**
- Status = ✅ MET

### 5 ns Clock

- Hold Slack = **5.68 ns**
- Status = ✅ MET

---

# Timing Comparison

| Clock Period | Setup Slack | Hold Slack | Status |
|--------------|------------:|-----------:|--------|
| 10 ns | 4.77 ns | 5.68 ns | Timing Met |
| 5 ns | -0.23 ns | 5.68 ns | Setup Violation |

---

# Observations

- The synthesized D Flip-Flop successfully passed timing analysis for the 10 ns clock period.
- Positive setup slack indicates sufficient timing margin at 10 ns.
- Hold timing is satisfied under both timing constraints.
- Reducing the clock period to 5 ns introduces a setup timing violation.
- The negative setup slack indicates that the combinational delay exceeds the available clock period.
- Timing closure can be achieved by relaxing the clock constraint or optimizing the design.

---

# Conclusion

This experiment demonstrates Static Timing Analysis (STA) of a synthesized D Flip-Flop using OpenSTA. The design satisfies both setup and hold timing requirements when operating at a 10 ns clock period. However, reducing the clock period to 5 ns results in a setup timing violation while the hold timing remains satisfied. This lab highlights the importance of timing constraints, slack analysis, and timing verification during the digital VLSI design flow.


GitHub Repository:
https://github.com/Tejas08-hub/RTL-to-GDSII-Internship-Labs
