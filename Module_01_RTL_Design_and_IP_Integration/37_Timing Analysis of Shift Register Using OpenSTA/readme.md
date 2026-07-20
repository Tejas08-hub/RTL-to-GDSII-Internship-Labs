# 37. Timing Analysis of Shift Register Using OpenSTA

## Overview

This project demonstrates **Static Timing Analysis (STA)** of a synthesized **8-bit Shift Register** using **OpenSTA**, an open-source static timing analysis tool. The RTL design is first synthesized using **Yosys** with the **OSU018 Standard Cell Library**, generating a gate-level netlist. OpenSTA is then used to analyze the synthesized design under different clock constraints (10 ns and 5 ns).

The timing analysis evaluates setup and hold timing requirements, identifies critical paths, and reports slack values to determine whether the design satisfies the specified timing constraints.

---

# Introduction

Static Timing Analysis (STA) is one of the most important verification stages in digital VLSI design. Instead of simulating all possible input combinations, STA mathematically analyzes every timing path in the synthesized circuit to ensure that data propagates correctly between sequential elements within the required clock period.

In this lab, OpenSTA is used to verify the timing performance of an **8-bit Shift Register** synthesized using Yosys and mapped to the **OSU018 Standard Cell Library**.

---

# Objective

After completing this project, the following objectives are achieved:

- Design an 8-bit Shift Register using Verilog HDL.
- Synthesize the RTL using Yosys.
- Generate a gate-level netlist.
- Apply timing constraints using an SDC file.
- Import the synthesized design into OpenSTA.
- Perform setup timing analysis.
- Perform hold timing analysis.
- Compare timing performance under different clock periods.
- Understand slack, required time, arrival time, and critical timing paths.

---

# Applications

Shift registers are widely used in digital systems for:

- Serial-to-Parallel Data Conversion
- Parallel-to-Serial Data Conversion
- Data Buffering
- Delay Elements
- UART Communication
- SPI Communication
- Ring Counters
- Johnson Counters
- Digital Signal Processing
- Sequence Generation

---

# Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL Design |
| Yosys | Logic Synthesis |
| OpenSTA | Static Timing Analysis |
| OSU018 Standard Cell Library | Technology Library |
| gVim | Code Editor |
| Ubuntu Linux | Development Environment |

---

# Project Structure

```
37_Timing Analysis of Shift Register Using OpenSTA
│
├── constraints
│   └── shift_register.sdc
│
├── reports
│   ├── 10ns_setup_report.txt
│   ├── 10ns_hold_report.txt
│   ├── 5ns_setup_report.txt
│   └── 5ns_hold_report.txt
│
├── screenshots
│   ├── 10ns_setup.png
│   ├── 10ns_hold.png
│   ├── 5ns_setup.png
│   └── 5ns_hold.png
│
├── src
│   ├── shift_register.v
│   ├── shift_register.ys
│   └── shift_register_synth.v
│
└── README.md
```

---

# RTL Design

The Shift Register is an **8-bit sequential circuit**.

### Inputs

- clk
- rst
- data_in[7:0]

### Output

- q[7:0]

On every positive edge of the clock:

- Reset clears the register.
- Otherwise, all bits shift left.
- The MSB of `data_in` is inserted into the LSB position.

---

# Synthesis Flow

The RTL is synthesized using **Yosys**.

The synthesis flow performs:

- RTL Parsing
- Process Conversion
- Technology Mapping
- Flip-Flop Mapping
- Logic Optimization
- Gate-Level Netlist Generation

The synthesized output file is:

```
shift_register_synth.v
```

---

# Timing Constraints (SDC)

The design uses **Synopsys Design Constraints (SDC)** to define timing requirements.

The constraints include:

- Clock Period
- Input Delay
- Output Delay
- Input Transition
- Output Load

Two timing scenarios are analyzed:

- **10 ns Clock**
- **5 ns Clock**

---

# Static Timing Analysis Flow

The OpenSTA flow consists of the following steps:

### 1. Load Liberty Library

Loads the OSU018 standard cell timing library.

### 2. Read Gate-Level Netlist

Imports the synthesized Verilog netlist.

### 3. Link the Design

Creates the complete design hierarchy.

### 4. Read SDC File

Loads all timing constraints.

### 5. Timing Analysis

Generates:

- Setup Timing Report
- Hold Timing Report

---

# Timing Reports

The following reports are generated.

## 10 ns Setup Report

Contains:

- Critical Path
- Arrival Time
- Required Time
- Setup Slack

---

## 10 ns Hold Report

Contains:

- Hold Path
- Hold Slack
- Minimum Delay Analysis

---

## 5 ns Setup Report

Performs setup timing analysis using a tighter clock period.

---

## 5 ns Hold Report

Checks minimum delay timing under 5 ns clock constraints.

---

# Screenshots

The timing reports captured from OpenSTA are available in the **screenshots** directory.

- 10 ns Setup Analysis
- 10 ns Hold Analysis
- 5 ns Setup Analysis
- 5 ns Hold Analysis

---

# Observations

### 10 ns Clock

- Timing meets the required clock period.
- Positive setup slack is observed.
- Hold timing is verified.
- No setup violations are present.

---

### 5 ns Clock

- Clock period becomes more restrictive.
- Setup slack decreases.
- Critical path becomes more timing-sensitive.
- Hold timing remains nearly unchanged.

---

# Comparison

| Clock Period | Setup Analysis | Hold Analysis |
|--------------|---------------|---------------|
| 10 ns | Positive slack with relaxed timing constraints | Timing meets hold requirements |
| 5 ns | Reduced setup slack due to tighter timing | Hold timing remains stable |

---

# Results

The synthesized Shift Register was successfully analyzed using OpenSTA under both **10 ns** and **5 ns** timing constraints.

The generated reports provide detailed information regarding:

- Critical Paths
- Arrival Time
- Required Time
- Setup Slack
- Hold Slack

The analysis demonstrates how reducing the clock period affects setup timing while hold timing remains largely unaffected.

---

# Conclusion

This project successfully demonstrates **Static Timing Analysis (STA)** of an **8-bit Shift Register** using **OpenSTA**.

The RTL was synthesized using **Yosys**, and timing analysis was performed using the **OSU018 Standard Cell Library**. Timing reports were generated for both **10 ns** and **5 ns** clock periods, allowing comparison of setup and hold timing characteristics.

The lab provides practical experience in applying timing constraints, interpreting OpenSTA reports, analyzing critical paths, and understanding the impact of clock frequency on digital circuit timing. This workflow reflects an essential stage of ASIC implementation and timing signoff used in modern VLSI design.

---

**RTL-to-GDSII-Internship-Labs**
