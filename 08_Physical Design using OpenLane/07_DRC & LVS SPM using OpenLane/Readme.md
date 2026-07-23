# 07_DRC & LVS SPM using OpenLane

## Overview

This project demonstrates the **Design Rule Check (DRC)** and **Layout Versus Schematic (LVS)** verification stages of the RTL-to-GDSII physical design flow using the OpenLane ASIC design flow. The design implemented is a **Serial Parallel Multiplier (SPM)** synthesized and physically implemented using the Sky130A Process Design Kit (PDK).

After completing synthesis, floorplanning, placement, clock tree synthesis (CTS), and routing, the design enters the signoff stage where it is verified for manufacturability and logical correctness before fabrication.

---

## Objectives

- Perform post-routing layout verification.
- Verify that the physical layout satisfies all Sky130A design rules.
- Compare the extracted layout netlist with the synthesized netlist.
- Generate final GDSII layout for fabrication.
- Understand the ASIC signoff verification flow.

---

# Design Description

### Serial Parallel Multiplier (SPM)

The Serial Parallel Multiplier performs binary multiplication by combining serial data processing with parallel addition. It consists of:

- Shift Registers
- Full Adders
- AND Gates
- Control Logic
- Flip-Flops

The design was synthesized using Yosys and implemented using OpenLane on the Sky130A technology node.

---

# What is DRC?

**Design Rule Check (DRC)** is the process of verifying that the physical layout follows all manufacturing rules specified by the semiconductor foundry.

These rules include:

- Minimum metal width
- Metal spacing
- Via enclosure
- Contact spacing
- Diffusion spacing
- Poly spacing
- Well spacing

A DRC-clean layout ensures that the design can be reliably manufactured without violating fabrication constraints.

---

# What is LVS?

**Layout Versus Schematic (LVS)** verifies that the physical layout matches the intended circuit connectivity.

LVS compares:

- Synthesized Netlist
- Extracted Layout Netlist

The verification checks:

- Cell instances
- Net connections
- Pins
- Inputs
- Outputs
- Power connections

A successful LVS confirms that the fabricated chip will implement the intended logic correctly.

---

# Tools Used

- OpenLane
- Yosys
- OpenROAD
- Magic
- Netgen
- KLayout
- Sky130A PDK

---

# OpenLane Signoff Flow

The following OpenLane commands were executed:

```tcl
flow.tcl -interactive

prep -design spm

run_synthesis

run_floorplan

run_placement

run_cts

run_routing

run_magic

run_magic_drc

run_magic_spice_export

run_klayout

run_lvs
```

---

# Magic Layout Verification

Magic is used for:

- Layout visualization
- Design Rule Checking
- SPICE extraction
- Technology-aware editing

Generated files:

- spm.mag
- spm.drc.mag

---

# KLayout Verification

KLayout is used to visualize the final physical layout.

The generated GDSII layout includes:

- Standard Cells
- Metal Layers
- Vias
- Routing
- Power Rails
- IO Pins

Unlike Magic, KLayout focuses on efficient layout visualization and inspection.

---

# DRC Verification

Magic checks the completed layout against Sky130A fabrication rules.

The DRC process verifies:

- Metal width
- Metal spacing
- Contact enclosure
- Via rules
- Diffusion spacing
- Poly spacing

**Result**

- No Design Rule Check (DRC) violations detected.
- Layout satisfies Sky130A technology design rules.

---

# LVS Verification

Netgen performs Layout Versus Schematic verification by comparing:

- Synthesized Verilog Netlist
- Extracted Layout Netlist

The verification ensures:

- Correct cell connectivity
- Matching netlist structure
- Correct pin mapping
- Functional equivalence between layout and schematic

**Result**

- LVS completed successfully.
- Layout matches the synthesized design.

---

# Layout Files

The layout directory contains:

- `spm.def` – Routed DEF layout
- `spm.odb` – OpenDB database
- `spm.gds` – Final GDSII layout
- `spm.mag` – Magic layout
- `spm.drc.mag` – Magic DRC layout

---

# Reports

The reports folder contains:

## Synthesis

- Area report
- Statistics report
- Timing summary

## Floorplan

- Floorplanning reports

## Signoff

- DRC Report
- LVS Report
- KLayout DRC XML
- SPICE feedback report

---

# Screenshots

The screenshots folder includes:

- OpenLane Signoff Flow
- Magic Layout
- KLayout Final GDS Layout
- DRC Report
- LVS Report

---

# Learning Outcomes

Through this lab, the following concepts were learned:

- ASIC Signoff Verification Flow
- Design Rule Checking (DRC)
- Layout Versus Schematic (LVS)
- Magic Layout Tool
- KLayout Visualization
- Netgen Verification
- GDSII Generation
- Manufacturing Rule Verification
- Physical Layout Validation

---

# Project Structure

```
07_DRC & LVS SPM using OpenLane
│
├── config/
├── src/
├── layout/
├── reports/
│   ├── synthesis/
│   ├── floorplan/
│   └── signoff/
├── logs/
├── screenshots/
└── README.md
```

---

# Conclusion

This lab demonstrates the complete signoff stage of the OpenLane RTL-to-GDSII flow. After completing routing, the design was successfully verified using Magic and Netgen. The layout passed Design Rule Check (DRC) without violations, and Layout Versus Schematic (LVS) confirmed that the physical implementation matches the synthesized design. Finally, the GDSII layout was generated, representing a fabrication-ready implementation of the Serial Parallel Multiplier using the Sky130A technology.
