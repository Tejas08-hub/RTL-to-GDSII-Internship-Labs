# 02_Frequency Divider RTL to GDSII OpenLane

## 📌 Overview

This project demonstrates the complete **RTL to GDSII ASIC Design Flow** using the **OpenLane** open-source physical design toolchain. The design implemented is a **Frequency Divider**, which reduces the frequency of the input clock by generating a lower-frequency output clock using sequential logic.

The complete digital ASIC flow includes RTL synthesis, floorplanning, placement, clock tree synthesis (CTS), routing, layout generation, Design Rule Check (DRC), Layout Versus Schematic (LVS), and GDSII generation.

---

## 🎯 Objective

- Design a Frequency Divider using Verilog HDL.
- Understand the complete RTL-to-GDSII physical design flow.
- Perform logic synthesis using Yosys.
- Generate floorplan and standard cell placement.
- Execute Clock Tree Synthesis (CTS).
- Perform global and detailed routing.
- Verify the design using DRC and LVS.
- Generate the final fabrication-ready GDSII layout.

---

## 📂 Project Structure

```
02_Frequency Divider RTL to GDSII OpenLane/
│
├── config/
│   └── config.json
│
├── layout/
│   ├── fd.gds
│   └── fd.mag
│
├── reports/
│   ├── synthesis/
│   ├── floorplan/
│   ├── placement/
│   ├── routing/
│   ├── drc/
│   └── lvs/
│
├── screenshots/
│   ├── openlane_flow.png
│   ├── openlane_flow2.png
│   └── magic_layout.png
│
└── src/
    └── fd.v
```

---

## ⚙️ Design Description

The Frequency Divider is implemented using two 2-bit counters:

- **Positive-edge counter (`pos_cnt`)**
- **Negative-edge counter (`neg_cnt`)**

Both counters increment independently on opposite clock edges.

Whenever either counter reaches a count of **2**, the output clock (`clk_out`) becomes HIGH.

Since both positive and negative edges are utilized, the output frequency is reduced while maintaining a nearly symmetrical waveform.

Example:

- Input Clock = **50 MHz**
- Output Clock ≈ **16.67 MHz**

This effectively performs a **divide-by-3 frequency division**.

---

## 🔧 RTL Design

### Inputs

| Signal | Description |
|----------|-------------|
| clk | System clock |
| reset | Active-high synchronous reset |

### Output

| Signal | Description |
|----------|-------------|
| clk_out | Divided clock output |

---

## 🛠️ OpenLane Design Flow

The complete ASIC implementation follows these stages:

### 1. RTL Synthesis (Yosys)

The Verilog RTL is synthesized into a gate-level netlist using Yosys.

**Output**
- Gate-level netlist
- Area report
- Cell statistics

---

### 2. Floorplanning

Defines:

- Die Area
- Core Area
- Standard Cell Rows
- Power Distribution Network (PDN)

This stage prepares the design for placement.

---

### 3. Placement

Standard cells are legally placed inside the core area while minimizing routing congestion and wire length.

---

### 4. Clock Tree Synthesis (CTS)

Clock buffers are inserted to distribute the clock evenly across sequential elements and minimize clock skew.

---

### 5. Routing

Routing connects all placed standard cells using metal layers and vias.

Two routing stages are performed:

- Global Routing
- Detailed Routing

---

### 6. Magic Layout Generation

Magic converts the routed DEF into a complete physical layout.

Generated files:

- `.mag`
- `.gds`

---

### 7. DRC Verification

Magic checks the layout against Sky130 design rules.

Checks include:

- Metal spacing
- Minimum width
- Overlap violations
- Via rules

---

### 8. LVS Verification

Netgen compares the extracted layout with the synthesized netlist.

Successful LVS confirms:

- Connectivity matches
- No missing or extra connections

---

## 📊 Reports Included

### Synthesis

- Cell Statistics
- Area Report

### Floorplan

- Initial Core Area
- Die Area Report

### Placement

- Placement Log

### Routing

- Global Routing Log
- Detailed Routing Log
- Wire Length Report

### Signoff

- DRC Report
- LVS Report

---

## 📷 Screenshots

The repository includes:

- OpenLane flow execution
- Final Magic layout
- Physical design results

---

## 🧰 Tools Used

| Tool | Purpose |
|------|----------|
| OpenLane | Complete RTL-to-GDSII Flow |
| Yosys | RTL Synthesis |
| OpenROAD | Placement, CTS, Routing |
| Magic | Layout Generation & DRC |
| Netgen | LVS Verification |
| KLayout | Layout Visualization |
| Sky130 PDK | Standard Cell Library |

---

## 📁 Configuration

The project is configured using **config.json**, which specifies:

- Design Name
- Verilog Source Files
- Clock Port
- Die Area
- Placement Density
- PDN Parameters
- Diode Insertion Strategy

---

## 🚀 Results

- ✅ RTL successfully synthesized
- ✅ Floorplan generated
- ✅ Standard cells placed successfully
- ✅ Clock Tree Synthesis completed
- ✅ Routing completed successfully
- ✅ Magic layout generated
- ✅ GDSII generated
- ✅ DRC completed
- ✅ LVS completed

---

## 📚 Key Learning Outcomes

- Complete understanding of the RTL-to-GDSII ASIC design flow.
- Practical experience with OpenLane and Sky130 PDK.
- Understanding of synthesis, placement, CTS, routing, DRC, and LVS.
- Experience generating fabrication-ready GDSII layouts.
- Knowledge of physical implementation and verification of digital ASIC designs.
