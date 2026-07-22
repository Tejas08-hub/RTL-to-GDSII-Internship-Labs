# Static Timing Analysis using OpenSTA

## Overview

Static Timing Analysis (STA) is the process of verifying whether a synthesized digital circuit meets all timing requirements without performing functional simulation. It calculates signal propagation delays through every timing path and determines whether the design can operate correctly at the target clock frequency.

This section demonstrates timing analysis using **OpenSTA**, an open-source static timing analyzer. Various synthesized RTL designs are analyzed to understand setup timing, hold timing, clock propagation, timing constraints, slack calculation, and critical path identification.

---

# Objectives

- Understand Static Timing Analysis (STA)
- Learn OpenSTA workflow
- Create timing constraints using SDC
- Analyze setup and hold timing
- Calculate slack
- Identify critical paths
- Interpret timing reports
- Verify synthesized RTL designs

---

# What is Static Timing Analysis?

Static Timing Analysis verifies whether all timing paths satisfy the required timing constraints.

Unlike simulation, STA does **not** apply input vectors. Instead, it mathematically computes the delay through every possible timing path.

Benefits include:

- Fast timing verification
- Complete path coverage
- No testbench required
- Industry-standard verification method
- Detects timing violations before physical design

---

# Why STA is Important

A digital circuit must complete all computations before the next active clock edge.

If a signal arrives too late:

- Setup violation occurs.

If a signal changes too early:

- Hold violation occurs.

STA ensures that every timing path satisfies both setup and hold requirements.

---

# OpenSTA

OpenSTA is an open-source Static Timing Analysis engine used in ASIC implementation flows.

Features include:

- Timing graph construction
- Setup analysis
- Hold analysis
- Clock analysis
- Delay calculation
- Slack computation
- Critical path identification
- SDC constraint support

---

# Timing Analysis Flow

```
RTL Design
      │
      ▼
RTL Synthesis (Yosys)
      │
      ▼
Gate-Level Netlist
      │
      ▼
SDC Constraints
      │
      ▼
OpenSTA
      │
      ▼
Timing Reports
```

---

# Timing Constraints (SDC)

OpenSTA uses Synopsys Design Constraints (SDC) to define timing requirements.

Typical constraints include:

- Clock definition
- Clock period
- Input delay
- Output delay
- False paths
- Multicycle paths

Example:

```
create_clock -period 10 clk
```

This creates a clock with a period of **10 ns**.

---

# Timing Path

A timing path consists of:

```
Launch Flip-Flop
        │
        ▼
Combinational Logic
        │
        ▼
Capture Flip-Flop
```

OpenSTA calculates the delay through every timing path.

---

# Setup Time

Setup time is the minimum amount of time the input data must remain stable **before** the active clock edge.

```
Data -----------|
                |
Clock _________↑______
```

If the data arrives too late:

- Setup Violation

---

# Hold Time

Hold time is the minimum amount of time data must remain stable **after** the clock edge.

```
Clock _________↑______

Data ----------|
               |
```

If data changes too early:

- Hold Violation

---

# Clock-to-Q Delay

Clock-to-Q delay is the time required for a flip-flop output to change after the active clock edge.

```
Clock Edge
     │
     ▼
Clock-to-Q Delay
     │
     ▼
Output Changes
```

---

# Arrival Time

Arrival Time is the total delay from the launching flip-flop to the destination.

```
Arrival Time

=

Clock-to-Q

+

Logic Delay

+

Wire Delay
```

---

# Required Time

Required Time is the latest allowable arrival time determined by the clock period and setup requirements.

---

# Slack

Slack indicates whether a timing path meets timing requirements.

Formula:

```
Slack

=

Required Time

-

Arrival Time
```

---

## Positive Slack

```
Slack > 0
```

Timing is met.

---

## Zero Slack

```
Slack = 0
```

Design exactly meets timing.

---

## Negative Slack

```
Slack < 0
```

Timing violation exists.

---

# Critical Path

The critical path is the path with the **largest delay**.

Characteristics:

- Longest combinational delay
- Determines maximum clock frequency
- Optimization target

---

# Setup Analysis

Checks whether data reaches the destination flip-flop before the next clock edge.

If:

```
Arrival Time

>

Required Time
```

Setup violation occurs.

---

# Hold Analysis

Checks whether data changes too quickly after the launching clock edge.

Hold violations usually occur due to:

- Very short combinational paths
- Clock skew
- Improper buffering

---

# Timing Reports

OpenSTA generates reports containing:

- Arrival Time
- Required Time
- Slack
- Critical Path
- Clock Information
- Setup Analysis
- Hold Analysis
- Path Delay

---

# Labs Included

## 01. Timing Analysis of Counter using OpenSTA

Performed timing analysis on a synthesized counter.

### Concepts Covered

- Counter Timing
- Clock Constraints
- Setup Analysis
- Hold Analysis
- Slack Calculation

---

## 02. Timing Analysis of D Flip-Flop using OpenSTA

Analyzed the timing characteristics of a D Flip-Flop.

### Concepts Covered

- Clock-to-Q Delay
- Setup Time
- Hold Time
- Sequential Timing

---

## 03. Timing Analysis of Shift Register Using OpenSTA

Performed timing verification of a synthesized shift register.

### Concepts Covered

- Register Chains
- Sequential Timing Paths
- Clock Propagation
- Timing Reports

---

## 04. Timing Analysis of GCD (Greatest Common Divisor) using OpenSTA

Performed static timing analysis on the synthesized GCD design.

### Concepts Covered

- Complex Timing Paths
- Critical Path Identification
- Slack Analysis
- Timing Verification

---

# Folder Structure

```
Project
│
├── rtl/
│   └── Verilog Source
│
├── synthesis/
│   └── Gate-Level Netlist
│
├── constraints/
│   └── SDC File
│
├── reports/
│   ├── Setup Report
│   ├── Hold Report
│   └── Timing Report
│
├── screenshots/
│   └── OpenSTA Output
│
└── README.md
```

---

# Tools Used

| Tool | Purpose |
|------|----------|
| OpenSTA | Static Timing Analysis |
| Yosys | RTL Synthesis |
| GVim | RTL Editing |
| Ubuntu Linux | Development Environment |

---

# Typical OpenSTA Flow

```
read_liberty library.lib

read_verilog design.v

link_design top_module

read_sdc constraints.sdc

report_checks

report_tns

report_wns

report_clock

report_timing
```

---

# Learning Outcomes

After completing this section, the following concepts were understood:

- Static Timing Analysis
- OpenSTA Flow
- Setup Timing
- Hold Timing
- Slack Calculation
- Critical Path Analysis
- Timing Constraints
- SDC File Creation
- Timing Reports
- Clock Analysis

---

# Skills Acquired

- OpenSTA
- Static Timing Analysis
- Timing Constraints
- SDC
- Slack Analysis
- Setup/Hold Verification
- Critical Path Identification
- ASIC Timing Verification

---

# Applications

Static Timing Analysis is widely used in:

- ASIC Design
- Physical Design
- Timing Closure
- Clock Tree Synthesis
- Signoff Verification
- Processor Design
- SoC Development
- FPGA Timing Verification

---

# Summary

Static Timing Analysis is a critical verification stage in the RTL-to-GDSII design flow. Using OpenSTA, synthesized designs are analyzed against timing constraints to ensure reliable operation at the target clock frequency. This section demonstrates setup and hold analysis, slack computation, critical path identification, and interpretation of timing reports across multiple digital circuits, providing a practical foundation for timing closure in ASIC design.
