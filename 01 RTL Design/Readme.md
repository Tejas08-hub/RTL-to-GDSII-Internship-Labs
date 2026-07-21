# RTL Design

## Overview

This section focuses on the implementation of fundamental digital circuits using **Verilog HDL**. It introduces the basic building blocks of digital design, including combinational and sequential circuits, and demonstrates their functional verification through simulation.

The labs in this section provide hands-on experience in designing, coding, simulating, and verifying RTL modules using industry-standard open-source tools.

---

# Objectives

- Understand the fundamentals of RTL design.
- Implement basic combinational and sequential logic circuits.
- Develop Verilog HDL modules.
- Write testbenches for functional verification.
- Simulate digital designs.
- Analyze simulation waveforms.
- Learn good RTL coding practices.

---

# Tools Used

| Tool | Purpose |
|-------|---------|
| GVim | Verilog Code Editor |
| Verilator | Simulation |
| GTKWave | Waveform Analysis |
| Linux (Ubuntu) | Development Environment |

---

# RTL Design Labs

## 01. Implementation of AND Gate

Design and verification of a 2-input AND gate.

### Concepts Covered

- Basic combinational logic
- Continuous assignment
- Truth table verification

---

## 02. Implementation of 4×1 Multiplexer

Design of a 4-to-1 multiplexer using Verilog HDL.

### Concepts Covered

- Data selection
- Conditional operators
- Combinational circuit design

---

## 03. Implementation of Half Adder

Design of a Half Adder capable of performing single-bit binary addition.

### Concepts Covered

- XOR Gate
- AND Gate
- Arithmetic Logic

---

## 04. Implementation of JK Flip-Flop

Design of an edge-triggered JK Flip-Flop.

### Concepts Covered

- Sequential Logic
- Clocked Circuits
- State Retention

---

## 05. Simple 4-Bit UP Counter

Implementation of a synchronous 4-bit binary up counter.

### Concepts Covered

- Sequential Logic
- Counter Design
- Clock-driven Operation

---

## 06. Simple 4-Bit DOWN Counter

Implementation of a synchronous 4-bit binary down counter.

### Concepts Covered

- Down Counting
- Binary State Transition
- Sequential Logic

---

## 07. 4-Bit Ripple UP Counter

Design of a ripple (asynchronous) counter using cascaded flip-flops.

### Concepts Covered

- Asynchronous Counter
- Ripple Clocking
- Propagation Delay

---

# Folder Structure

```
01 RTL Design
│
├── 01_Implementation of AND gate
│   ├── RTL
│   ├── Testbench
│   ├── Waveform
│   └── README.md
│
├── 02_Implementation of 4x1 Multiplexer
│   ├── RTL
│   ├── Testbench
│   ├── Waveform
│   └── README.md
│
├── 03_Implementation of Half Adder
│
├── 04_Implementation of JK Flip-Flop
│
├── 05_Simple 4-Bit UP Counter
│
├── 06_Simple 4-Bit DOWN Counter
│
├── 07_4-bit Ripple UP Counter
│
└── README.md
```

---

# Learning Outcomes

After completing this section, the following concepts were understood:

- RTL Design Methodology
- Verilog HDL Syntax
- Combinational Logic Design
- Sequential Logic Design
- Counters
- Flip-Flops
- Multiplexers
- Arithmetic Circuits
- Functional Verification
- Testbench Development
- Simulation Flow
- Waveform Analysis

---

# Skills Acquired

- Verilog HDL Programming
- RTL Coding
- Digital Circuit Design
- Functional Simulation
- Testbench Development
- Debugging RTL Designs
- GTKWave Analysis
- Linux-based Development

---

# Summary

This section establishes the foundation of RTL design by implementing essential combinational and sequential circuits. The knowledge gained here serves as the basis for advanced topics such as communication protocols, clock domain crossing (CDC), synthesis, timing analysis, and physical design covered in the subsequent sections of this repository.
