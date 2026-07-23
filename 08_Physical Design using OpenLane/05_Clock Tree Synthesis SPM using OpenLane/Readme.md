# 05_Clock Tree Synthesis (CTS) SPM using OpenLane

## Overview

This lab demonstrates the **Clock Tree Synthesis (CTS)** stage of the RTL-to-GDSII physical design flow using the **OpenLane** automated ASIC design flow. CTS is performed after placement and before routing to build an optimized clock distribution network that delivers the clock signal uniformly to all sequential elements in the design.

A balanced clock tree minimizes clock skew, insertion delay, and clock uncertainty while maintaining reliable synchronous operation. OpenLane uses the **OpenROAD CTS engine** to automatically insert clock buffers and inverters, ensuring that the clock network meets timing and design constraints before proceeding to routing.

---

# Objectives

- Understand the importance of Clock Tree Synthesis in ASIC Physical Design.
- Generate an optimized clock distribution network using OpenLane.
- Learn how OpenLane inserts clock buffers and clock inverters.
- Visualize the CTS layout using KLayout.
- Prepare the design for the Routing stage.

---

# Design Used

**Design Name:** Serial Parallel Multiplier (SPM)

The Serial Parallel Multiplier (SPM) is a 32-bit arithmetic circuit implemented using Carry Save Adders (CSA) and Transition Comparator (TCMP) blocks. During CTS, OpenLane constructs a balanced clock network to distribute the clock signal efficiently to all sequential elements while minimizing skew and latency.

---

# Theory of Clock Tree Synthesis (CTS)

Clock Tree Synthesis is the process of constructing a balanced clock distribution network that delivers the clock signal from the clock source to every sequential element in the design.

Without CTS:

- Different flip-flops receive the clock at different times.
- Excessive clock skew may occur.
- Timing violations become more likely.
- Circuit reliability decreases.

The CTS engine inserts clock buffers and inverters where required to distribute the clock signal evenly across the chip while satisfying timing constraints.

---

# Why Clock Tree Synthesis is Required

A clock signal drives every sequential element in a synchronous digital circuit. Since the clock must travel through long metal interconnects, propagation delays naturally occur.

Clock Tree Synthesis helps to:

- Reduce clock skew
- Minimize insertion delay
- Balance clock arrival times
- Improve timing closure
- Maintain synchronous operation
- Reduce clock uncertainty

---

# Clock Skew

Clock skew is the difference in clock arrival time between two sequential elements.

**Types of Clock Skew**

### Positive Clock Skew

The destination flip-flop receives the clock later than the source flip-flop.

### Negative Clock Skew

The destination flip-flop receives the clock earlier than the source flip-flop.

A well-balanced CTS network minimizes both positive and negative clock skew.

---

# Clock Latency

Clock latency is the delay from the clock source to the clock pin of a flip-flop.

Lower latency improves timing performance and overall circuit reliability.

---

# Clock Buffers and Inverters

During CTS, OpenLane automatically inserts:

- Clock Buffers
- Clock Inverters

These cells help:

- Drive larger fanout
- Reduce delay
- Improve signal integrity
- Balance clock distribution
- Meet timing constraints

---

# CTS Flow

Clock Tree Synthesis is performed after placement and before routing.

The overall RTL-to-GDSII flow is:

RTL Design

↓

Synthesis

↓

Floorplanning

↓

Placement

↓

**Clock Tree Synthesis (CTS)**

↓

Routing

↓

GDSII Generation

---

# Tools Used

- OpenLane
- OpenROAD
- KLayout
- Sky130 PDK

---

# Project Structure

```
05_Clock Tree Synthesis SPM using OpenLane
│
├── config
│   ├── config.json
│   ├── pin_order.cfg
│   └── spm.sdc
│
├── layout
│   ├── spm.def
│   ├── spm.odb
│   └── spm.sdc
│
├── logs
│
├── reports
│
├── screenshots
│
└── src
    └── spm.v
```

---

# Files Included

## Configuration Files

- config.json
- pin_order.cfg
- spm.sdc

These files define design constraints, clock information, pin locations, and OpenLane configuration parameters.

---

## RTL Source

- spm.v

Contains the RTL implementation of the Serial Parallel Multiplier.

---

## Layout Files

- spm.def
- spm.odb

These files contain the physical design database after Clock Tree Synthesis.

---

## Logs

Contains CTS execution logs generated during the OpenLane flow.

---

## Reports

Contains CTS-related reports generated during the OpenLane flow (if available).

> **Note:** Depending on the OpenLane version, the `reports/cts` directory may remain empty. This is normal, as some versions primarily generate CTS outputs in the `layout` and `logs` directories.

---

# OpenLane Commands

The CTS stage was executed using the following commands:

```tcl
flow.tcl -interactive

prep -design spm

run_synthesis

run_floorplan

run_placement

run_cts
```

---

# CTS Results

After successful Clock Tree Synthesis:

- Clock buffers were inserted.
- Clock inverters were inserted where required.
- Clock distribution was balanced.
- Clock skew was minimized.
- Timing optimization was performed.
- Updated DEF and ODB files were generated.
- The design became ready for Routing.

---

# Layout Analysis

The CTS DEF file was visualized using **KLayout**.

The following observations were made:

- Standard cells remained legally placed.
- Clock network preparation completed successfully.
- Buffer insertion was performed by the CTS engine.
- The design is ready for the Routing stage.

> **Note:** In this OpenLane version, the physical clock routing is not clearly visible in the CTS DEF. The complete routed clock tree becomes visible after the Routing stage, which is consistent with the lab manual.

---

# Learning Outcomes

Through this lab, the following concepts were learned:

- Importance of Clock Tree Synthesis
- Clock distribution techniques
- Clock skew reduction
- Clock latency optimization
- Clock buffer insertion
- Clock inverter insertion
- CTS visualization using KLayout
- Preparation for Routing

---

# Conclusion

Clock Tree Synthesis of the Serial Parallel Multiplier (SPM) was successfully completed using the OpenLane ASIC flow. OpenLane generated an optimized clock distribution network by inserting clock buffers and inverters while minimizing clock skew and insertion delay. The CTS stage prepared the design for the Routing stage, ensuring reliable synchronous operation and improved timing performance in the RTL-to-GDSII flow.
