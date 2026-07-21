# 38. Timing Analysis of GCD (Greatest Common Divisor) Using OpenSTA

## Overview

This project demonstrates **Static Timing Analysis (STA)** of a synthesized **Greatest Common Divisor (GCD)** hardware design using **OpenSTA**. The RTL is developed in **Verilog HDL**, synthesized using **Yosys**, and analyzed using the **OSU018 Standard Cell Library** under different timing constraints (10 ns and 5 ns).

The objective is to understand setup and hold timing analysis, identify critical paths, and observe how clock constraints affect the timing performance of a digital design.

---

# Introduction

Static Timing Analysis (STA) is an important verification stage in the ASIC design flow. Unlike simulation, STA mathematically analyzes every timing path in the circuit to verify whether data propagates correctly between sequential elements without violating setup or hold requirements.

In this project, OpenSTA is used to verify the timing of a synthesized GCD hardware module by generating setup and hold timing reports under different clock periods.

---

# What is GCD?

The **Greatest Common Divisor (GCD)** is the largest positive integer that divides two numbers without leaving a remainder.

### Example

```
GCD(48,18)=6
```

Because

```
48 = 6 × 8

18 = 6 × 3
```

---

# Euclidean Algorithm

This hardware implements the **subtraction-based Euclidean Algorithm**.

```
while(B != 0)

    if(A > B)

        A = A - B;

    else

        B = B - A;

Result = A
```

### Example

```
A = 48

B = 18

48 > 18

A = 30

30 > 18

A = 12

18 > 12

B = 6

12 > 6

A = 6

B = 0

Result = 6
```

The algorithm repeatedly subtracts the smaller number from the larger one until one operand becomes zero. The remaining value is the Greatest Common Divisor.

---

# Applications

- Cryptography
- RSA Encryption
- Digital Signal Processing
- Error Detection and Correction
- Arithmetic Accelerators
- Coprocessors
- Embedded Systems
- Rational Number Simplification

---

# Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL Design |
| Yosys | Logic Synthesis |
| OpenSTA | Static Timing Analysis |
| OSU018 Standard Cell Library | Standard Cell Library |
| gVim | Code Editor |
| Ubuntu Linux | Development Environment |

---

# Project Structure

```text
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

The GCD hardware is implemented using a **Finite State Machine (FSM)** and the **subtraction-based Euclidean Algorithm**. The computation is performed sequentially on every rising edge of the clock until the GCD is obtained.

## Module Interface

```verilog
module gcd(
    input clk,
    input rst,
    input start,
    input [31:0] A,
    input [31:0] B,
    output reg done,
    output reg [31:0] result
);
```

The module accepts two 32-bit operands (**A** and **B**) along with **clk**, **rst**, and **start** signals. Once the computation is complete, the GCD is stored in **result**, and the **done** signal is asserted.

---

## Finite State Machine (FSM)

```verilog
localparam IDLE = 2'd0,
           RUN  = 2'd1,
           DONE = 2'd2;
```

The controller consists of three states:

### IDLE

- Waits for the **start** signal.
- Loads the input operands into internal registers.
- Clears the **done** signal.

### RUN

- Executes the Euclidean subtraction algorithm.
- Repeatedly subtracts the smaller operand from the larger operand.
- Continues until one operand becomes zero.

### DONE

- Stores the computed GCD in the output register.
- Asserts the **done** signal.
- Waits for **start** to become LOW before returning to the IDLE state.

---

## Sequential Logic

```verilog
always @(posedge clk or posedge rst)
```

All computations occur on the rising edge of the system clock, while the asynchronous reset initializes the design immediately whenever **rst** is asserted.

---

## Core GCD Computation

```verilog
if (b_reg == 0)
    result <= a_reg;
else if (a_reg > b_reg)
    a_reg <= a_reg - b_reg;
else
    b_reg <= b_reg - a_reg;
```

This is the heart of the Euclidean Algorithm.

- If **b_reg** becomes zero, the computation is complete.
- Otherwise, the larger operand is reduced by subtracting the smaller operand.
- The process repeats until the GCD is obtained.

---

# Synthesis Flow

The RTL design is synthesized using **Yosys**.

The synthesis flow performs:

- RTL Parsing
- Logic Optimization
- Technology Mapping
- Flip-Flop Mapping
- Gate-Level Netlist Generation

Generated Netlist:

```
gcd_synth.v
```

---

# Timing Constraints

Timing constraints are defined using an **SDC (Synopsys Design Constraints)** file.

The constraints specify:

- Clock Period
- Input Delay
- Output Delay
- Input Transition
- Output Load

Timing analysis is performed for:

- **10 ns Clock**
- **5 ns Clock**

---

# OpenSTA Flow

The complete timing analysis flow consists of:

1. Loading the OSU018 Liberty library.
2. Reading the synthesized gate-level netlist.
3. Linking the top-level design.
4. Reading the SDC timing constraints.
5. Generating setup and hold timing reports.

---

# Timing Results

## 10 ns Analysis

| Timing Check | Result |
|--------------|--------|
| Setup | **Slack = -1.95 ns (VIOLATED)** |
| Hold | **Slack = 0.37 ns (MET)** |

The hold timing satisfies the required constraint, while setup timing violates the specified output timing requirement.

---

## 5 ns Analysis

| Timing Check | Result |
|--------------|--------|
| Setup | **Slack = -6.95 ns (VIOLATED)** |
| Hold | **Slack = 0.37 ns (MET)** |

Reducing the clock period increases the setup timing violation because the available time for data propagation becomes smaller.

---

# Observations

- RTL synthesized successfully using Yosys.
- Gate-level netlist generated successfully.
- OpenSTA successfully analyzed the synthesized design.
- Hold timing requirements are satisfied.
- Setup timing violations are observed due to tighter timing constraints.
- The timing reports clearly identify the critical timing paths and slack values.
- Reducing the clock period from **10 ns** to **5 ns** increases the setup timing violation.

---

# Conclusion

This project demonstrates the complete **Static Timing Analysis (STA)** flow of a synthesized **Greatest Common Divisor (GCD)** hardware implementation using **OpenSTA**.

The RTL was synthesized using **Yosys**, and timing analysis was performed under **10 ns** and **5 ns** clock constraints using the **OSU018 Standard Cell Library**. The generated timing reports show that **hold timing requirements are satisfied**, while **setup timing violations** occur because the selected clock constraints are more restrictive than the synthesized design's propagation delay.

This project provides practical experience with RTL synthesis, timing constraints, critical path analysis, slack interpretation, and timing verification, making it an important step toward understanding ASIC timing closure and digital VLSI design.
