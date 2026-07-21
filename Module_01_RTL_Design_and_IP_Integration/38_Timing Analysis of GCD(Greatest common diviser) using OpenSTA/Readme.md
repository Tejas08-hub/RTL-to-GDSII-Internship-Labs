# 38. Timing Analysis of GCD (Greatest Common Divisor) Using OpenSTA

## Overview

This project demonstrates **Static Timing Analysis (STA)** of a synthesized **Greatest Common Divisor (GCD)** hardware design using **OpenSTA**. The RTL is written in **Verilog HDL**, synthesized using **Yosys**, and analyzed using the **OSU018 Standard Cell Library** under different clock constraints.

The objective of this project is to understand how setup and hold timing are verified after synthesis and how changing the clock period affects timing closure.

---

# Introduction

Static Timing Analysis (STA) is one of the most important stages in the digital ASIC design flow. Instead of simulating every possible input combination, STA mathematically verifies all timing paths in a digital circuit.

In this project, the synthesized GCD hardware is analyzed using OpenSTA to verify:

- Setup Timing
- Hold Timing
- Critical Paths
- Slack
- Timing Violations

The analysis is performed for two different clock periods:

- **10 ns**
- **5 ns**

allowing comparison of the design performance under relaxed and aggressive timing constraints.

---

# What is GCD?

The **Greatest Common Divisor (GCD)** is the largest positive integer that divides two integers without leaving a remainder.

Example:

```
GCD(48,18)=6
```

because

```
48 = 6 × 8

18 = 6 × 3
```

and no larger integer divides both numbers.

---

# Euclidean Algorithm

The RTL implements the subtraction-based Euclidean Algorithm.

Algorithm:

```
while(B != 0)

    if(A > B)

        A = A - B;

    else

        B = B - A;

Result = A
```

Example:

```
A = 48

B = 18

48 >18

A =30

30 >18

A =12

18 >12

B =6

12 >6

A =6

6 =6

B =0

Result =6
```

The algorithm continues until one operand becomes zero.

---

# Applications

Digital GCD circuits are widely used in

- Cryptography
- RSA Encryption
- Modular Arithmetic
- Error Correction
- Digital Signal Processing
- Hardware Accelerators
- Arithmetic Logic Units
- Coprocessors
- Rational Number Simplification

---

# Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL Design |
| Yosys | Logic Synthesis |
| OpenSTA | Static Timing Analysis |
| OSU018 Standard Cell Library | Technology Library |
| Ubuntu Linux | Development Environment |
| gVim | RTL Editing |

---

# Project Structure

```
38_Timing Analysis of GCD(Greatest common diviser) using OpenSTA

│
├── constraints
│   └── gcd.sdc
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
│   ├── gcd.v
│   ├── gcd.ys
│   └── gcd_synth.v
│
└── README.md
```

---

# RTL Design

## Module Declaration

```verilog
module gcd(
```

Creates the top-level hardware module.

---

## Inputs

```verilog
input clk
```

System clock controlling all sequential operations.

```verilog
input rst
```

Asynchronous reset.

```verilog
input start
```

Starts the GCD computation.

```verilog
input [31:0] A

input [31:0] B
```

Two 32-bit operands whose GCD is calculated.

---

## Outputs

```verilog
output reg done
```

Indicates completion of the computation.

```verilog
output reg [31:0] result
```

Stores the final GCD value.

---

# Finite State Machine (FSM)

The controller uses three states.

## IDLE

```
Waiting for start signal.
```

When

```
start =1
```

the operands are loaded into internal registers.

---

## RUN

Performs the Euclidean subtraction algorithm.

```
if(B==0)

Result=A

Done=1

else

A=A-B

or

B=B-A
```

depending on which operand is larger.

---

## DONE

The result remains available until

```
start
```

returns low.

The FSM then returns to the IDLE state.

---

# Internal Registers

```
a_reg
```

Stores operand A during computation.

```
b_reg
```

Stores operand B during computation.

These registers are repeatedly updated until the GCD is found.

---

# Sequential Logic

The design operates on

```verilog
always @(posedge clk or posedge rst)
```

meaning

- Operations occur only on the rising clock edge.
- Reset immediately initializes the design.

---

# Synthesis

The RTL is synthesized using **Yosys**.

The synthesis flow performs

- RTL Parsing
- Logic Optimization
- Flip-Flop Mapping
- Technology Mapping
- Gate-Level Netlist Generation

Output

```
gcd_synth.v
```

---

# Timing Constraints

Timing constraints are written in **SDC (Synopsys Design Constraints)**.

They define

- Clock Period
- Input Delay
- Output Delay
- Input Transition
- Output Load

Two timing scenarios are analyzed

- 10 ns
- 5 ns

---

# OpenSTA Flow

The following steps are executed.

## 1. Read Liberty

Loads the OSU018 timing library.

---

## 2. Read Netlist

Imports the synthesized design.

---

## 3. Link Design

Creates the complete design hierarchy.

---

## 4. Read SDC

Applies timing constraints.

---

## 5. Generate Timing Reports

Produces

- Setup Report
- Hold Report

---

# Setup Timing Analysis

Setup timing verifies that data arrives **before** the next active clock edge.

The setup report provides

- Data Arrival Time
- Data Required Time
- Critical Path
- Setup Slack

Positive slack

```
Slack > 0
```

indicates timing is met.

Negative slack

```
Slack < 0
```

indicates a setup violation.

---

# Hold Timing Analysis

Hold timing ensures that data remains stable immediately after the active clock edge.

The hold report contains

- Hold Slack
- Minimum Delay Path
- Critical Hold Path

Positive hold slack indicates correct operation.

---

# Timing Results

## 10 ns Clock

### Hold Analysis

```
Slack = 0.37 ns

Status = MET
```

The minimum delay path satisfies the hold timing requirement.

---

### Setup Analysis

```
Slack = -1.95 ns

Status = VIOLATED
```

The data arrives later than the required time.

Therefore, the design fails setup timing under the given output delay constraint.

---

## 5 ns Clock

### Hold Analysis

```
Slack = 0.37 ns

Status = MET
```

Hold timing continues to satisfy the requirement.

---

### Setup Analysis

```
Slack = -6.95 ns

Status = VIOLATED
```

Reducing the clock period further tightens the setup requirement, increasing the setup violation.

---

# Screenshots

The screenshots folder contains

- 10 ns Setup Analysis
- 10 ns Hold Analysis
- 5 ns Setup Analysis
- 5 ns Hold Analysis

captured directly from OpenSTA.

---

# Observations

- RTL successfully synthesized.
- Gate-level netlist generated successfully.
- OpenSTA correctly imported the design.
- Hold timing is satisfied under both clock constraints.
- Setup timing fails because the required timing is more restrictive than the data arrival time.
- The violation increases when the clock period is reduced from 10 ns to 5 ns.
- Timing reports clearly identify the critical timing paths.

---

# Conclusion

This project demonstrates the complete **Static Timing Analysis (STA)** flow for a synthesized **Greatest Common Divisor (GCD)** hardware implementation.

The RTL was synthesized using **Yosys**, and OpenSTA was used to verify setup and hold timing under **10 ns** and **5 ns** clock constraints.

The analysis shows that **hold timing is successfully met**, while **setup timing violations occur** because the selected clock constraints are aggressive relative to the synthesized design's propagation delay. Tightening the clock period from **10 ns** to **5 ns** further increases the setup violation, illustrating how clock constraints directly influence timing closure.

This project provides practical experience with synthesis, timing constraints, critical path analysis, slack interpretation, and timing verification, which are fundamental steps in modern ASIC and VLSI physical design.

GitHub Repository

**RTL-to-GDSII-Internship-Labs**
