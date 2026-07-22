# CDC and RDC

## Overview

Clock Domain Crossing (CDC) and Reset Domain Crossing (RDC) are critical aspects of digital ASIC and FPGA design. Modern System-on-Chip (SoC) designs often contain multiple clock domains and multiple reset sources operating independently. Improper synchronization between these domains can lead to metastability, data corruption, unpredictable behavior, and functional failures.

This section demonstrates the fundamental concepts of CDC and RDC through practical Verilog implementations, simulations, and waveform analysis. The labs illustrate common synchronization techniques, reset handling strategies, and best practices followed in industry-standard digital design.

---

# Objectives

- Understand the concept of multiple clock domains.
- Learn the causes and effects of metastability.
- Study synchronization techniques for reliable data transfer.
- Understand different reset architectures.
- Learn Reset Domain Crossing (RDC) concepts.
- Implement synchronizers using Verilog HDL.
- Verify synchronization logic through simulation.
- Understand industry-standard CDC/RDC design practices.

---

# What is Clock Domain Crossing (CDC)?

A **Clock Domain Crossing (CDC)** occurs whenever a signal generated in one clock domain is transferred to another clock domain operating at a different frequency or phase.

Since the receiving clock samples the incoming signal asynchronously, the signal may violate setup or hold timing requirements, causing the receiving flip-flop to enter a **metastable state**.

Without proper synchronization, CDC issues can cause:

- Random output values
- Data corruption
- Timing failures
- Functional instability
- Intermittent hardware bugs
- Difficult-to-debug silicon failures

---

# What is Metastability?

Metastability is a temporary condition in which a flip-flop cannot immediately resolve its output to a valid logic HIGH or LOW.

It typically occurs when:

- Setup time is violated
- Hold time is violated
- Asynchronous inputs are sampled directly
- Signals cross different clock domains without synchronization

Although metastability eventually resolves itself, the resolution time is unpredictable, making the circuit unreliable.

---

# Common CDC Synchronization Techniques

Several synchronization techniques are used depending on the type of signal being transferred.

### Single-Bit Synchronizer

- Two-stage flip-flop synchronizer
- Three-stage synchronizer
- Multi-stage synchronizer

### Multi-Bit Synchronization

- Handshake protocol
- Asynchronous FIFO
- Gray-code counters

### Clock Management

- Clock Multiplexers
- Clock Dividers
- Clock Gating

---

# What is Reset Domain Crossing (RDC)?

Reset Domain Crossing (RDC) occurs when reset signals originate from one reset domain and affect logic operating in another clock or reset domain.

Unlike clocks, reset signals are usually asynchronous. Improper reset release may cause different flip-flops to start operating at different clock cycles, resulting in inconsistent system behavior.

Proper reset synchronization ensures all sequential elements leave reset safely and predictably.

---

# Types of Reset

### Asynchronous Reset

- Independent of clock
- Immediate reset assertion
- Requires synchronization during release

Advantages

- Fast response
- Widely used for power-on reset

Disadvantages

- Risk of metastability during reset de-assertion

---

### Synchronous Reset

- Reset is sampled by the clock
- Safer release
- Easier timing closure

Advantages

- No asynchronous timing issues
- Simpler verification

Disadvantages

- Requires active clock
- Slightly slower reset response

---

# Reset Synchronization

A common industry practice is:

**Asynchronous Assertion + Synchronous De-assertion**

This combines the advantages of both reset methods:

- Immediate reset activation
- Safe synchronized reset release

---

# Labs Included

## 01. Demonstrating Metastability Without Synchronization

This lab demonstrates the effect of transferring asynchronous signals directly into a clocked system without synchronization.

### Concepts Covered

- Setup Time Violation
- Hold Time Violation
- Metastability
- Unstable Output
- Asynchronous Input

---

## 02. Fixing Metastability Using a 2-Stage Synchronizer

Implementation of the industry-standard two-flip-flop synchronizer to safely transfer single-bit signals between clock domains.

### Concepts Covered

- Two-Stage Synchronizer
- Metastability Reduction
- Signal Synchronization
- Reliability Improvement

---

## 03. Exploring Reset Types — Foundation for RDC

Comparison between synchronous and asynchronous reset methodologies.

### Concepts Covered

- Reset Architectures
- Reset Timing
- Power-On Reset
- Reset Assertion
- Reset De-assertion

---

## 04. Inserting Clock and Reset Synchronization Logic

Integration of synchronization logic into a digital design.

### Concepts Covered

- CDC Integration
- RDC Integration
- Synchronization Logic
- Safe Signal Transfer

---

## 05. Multi-Stage Synchronizer for Stable CDC

Implementation of multiple synchronization stages for improved metastability reduction.

### Concepts Covered

- Three-Stage Synchronizer
- Multi-Stage Synchronizer
- Mean Time Between Failure (MTBF)

---

## 06. Global Reset vs Synchronized Reset Release

Study of system-wide reset distribution and synchronized reset release techniques.

### Concepts Covered

- Global Reset
- Local Reset
- Reset Synchronization
- Reliable System Startup

---

## 07. Reset Stretcher with Synchronous Release

Implementation of reset stretching logic to ensure stable system initialization.

### Concepts Covered

- Reset Stretching
- Pulse Extension
- Safe Startup
- Sequential Initialization

---

# Folder Structure

```
03 CDC and RDC
│
├── 01_Demonstrating Metastability Without Synchronization
├── 02_Fixing Metastability Using a 2-Stage Synchronizer
├── 03_Exploring Reset Types — Foundation for RDC
├── 04_Inserting Clock and Reset Synchronization Logic
├── 05_Multi-Stage Synchronizer for Stable CDC
├── 06_Global Reset vs Synchronized Reset Release
├── 07_Reset Stretcher with Synchronous Release
└── README.md
```

---

# Tools Used

| Tool | Purpose |
|-------|---------|
| GVim | Verilog Development |
| Verilator | RTL Simulation |
| GTKWave | Waveform Analysis |
| Linux (Ubuntu) | Development Environment |

---

# Learning Outcomes

After completing this section, the following concepts were understood:

- Clock Domain Crossing (CDC)
- Reset Domain Crossing (RDC)
- Metastability
- Setup and Hold Violations
- Two-Stage Synchronizers
- Multi-Stage Synchronizers
- Reset Architectures
- Reset Synchronization
- MTBF Improvement
- Clock Synchronization Techniques
- Industry Best Practices for CDC/RDC

---

# Skills Acquired

- Verilog RTL Design
- Synchronizer Design
- Reset Logic Design
- CDC Verification
- RDC Verification
- Functional Simulation
- Timing-Aware Digital Design
- Debugging Metastability Issues

---

# Applications

CDC and RDC techniques are widely used in:

- ASIC Design
- FPGA Design
- Multi-Clock SoCs
- High-Speed Interfaces
- Communication Systems
- Embedded Processors
- Memory Controllers
- Network-on-Chip (NoC)
- Automotive Electronics
- Aerospace and Safety-Critical Systems

---

# Summary

Clock Domain Crossing (CDC) and Reset Domain Crossing (RDC) are essential topics in modern digital design. Proper synchronization techniques significantly improve the reliability and robustness of complex digital systems by preventing metastability, ensuring safe data transfer across clock domains, and guaranteeing deterministic reset behavior. The labs in this section provide practical exposure to industry-standard synchronization methods used in ASIC and FPGA development.
