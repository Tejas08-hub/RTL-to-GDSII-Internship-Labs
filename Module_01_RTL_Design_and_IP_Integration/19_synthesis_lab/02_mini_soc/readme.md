# Mini SoC Synthesis using Yosys

## Overview

This project demonstrates the synthesis of a simple Mini System-on-Chip (Mini SoC) using Verilog HDL and the Yosys Open Synthesis Suite. The design integrates multiple reusable IP blocks into a single top-level module.

## Design Components

### 1. Counter IP

A 4-bit synchronous up-counter with reset functionality.

**File:** `counter.v`

### 2. ALU IP

A 2-bit Arithmetic Logic Unit capable of performing:

* Addition
* Subtraction

**File:** `alu.v`

### 3. Multiplexer IP

A 2-bit 2:1 Multiplexer used for output selection.

**File:** `mux2x1.v`

### 4. Top-Level Mini SoC

Integrates the Counter, ALU, and Multiplexer into a complete system.

**File:** `mini_soc.v`

---

## Project Files

* `counter.v` – Counter IP
* `alu.v` – ALU IP
* `mux2x1.v` – Multiplexer IP
* `mini_soc.v` – Top-level Mini SoC design
* `mini_soc.ys` – Yosys synthesis script
* `mini_soc_netlist.v` – Synthesized gate-level netlist
* `mini_soc.png` – Synthesized schematic

---

## Architecture

```text
Counter
   │
   ▼
  ALU
   │
   ▼
Multiplexer
   │
   ▼
 SoC Output
```

---

## Synthesis Flow

1. Create individual IP blocks.
2. Integrate all IPs in the top-level module.
3. Create a Yosys synthesis script.
4. Run synthesis using Yosys.
5. Generate the gate-level netlist.
6. Visualize the synthesized hardware structure.

---

## Results

* Successfully synthesized the Mini SoC design using Yosys.
* Generated a gate-level netlist (`mini_soc_netlist.v`).
* Verified hierarchical IP integration.
* Observed synthesized hardware representation through Graphviz.

---

## Learning Outcomes

* Modular RTL design methodology
* IP-based hardware integration
* Hierarchical design synthesis
* Gate-level netlist generation
* Yosys synthesis flow
* Basic SoC design concepts

## Tools Used

* Verilog HDL
* Yosys Open Synthesis Suite
* GVim Editor
* Graphviz / Dot Viewer
