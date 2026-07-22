# Floorplan of SPM Design using OpenLane

## Overview

This project demonstrates the **Floorplanning stage** of the RTL-to-GDSII ASIC design flow using **OpenLane** and the **Sky130 PDK**. The design used in this lab is an **SPM (Serial Parallel Multiplier)** implemented in Verilog.

Floorplanning is the first stage of physical design where the synthesized netlist is converted into a physical layout by defining the die area, core area, standard-cell rows, I/O pin placement, and Power Distribution Network (PDN). A well-planned floorplan provides the foundation for successful placement, clock tree synthesis, and routing.

---

# Project Structure

```
03_Floorplan SPM using OpenLane
│── config/
│   ├── config.json
│   ├── pin_order.cfg
│   └── spm.sdc
│
│── src/
│   └── spm.v
│
│── layout/
│   ├── spm.def
│   └── spm.odb
│
│── reports/
│
│── logs/
│
│── screenshots/
│   ├── 01_OpenLane_Flow.png
│   └── 02_Floorplan_KLayout.png
│
└── README.md
```

---

# About the SPM Design

The design implemented in this lab is a **Serial Parallel Multiplier (SPM)**.

It performs multiplication between a **32-bit input (`x`)** and a **1-bit input (`y`)** using sequential logic. Instead of using a large combinational multiplier, the design processes one bit at a time, reducing hardware complexity.

The design consists of three modules:

- **SPM** (Top Module)
- **CSADD** (Carry Save Adder)
- **TCMP** (Transition Comparator)

### Block Diagram

```
                +----------------+
                |      SPM       |
                |                |
x[31:0] ------->|                |
y ------------->|                |------> p
clk ----------->|                |
rst ----------->|                |
                +----------------+
                        |
         -------------------------------
         |                             |
      31 × CSADD                   1 × TCMP
```

---

# Module Description

## 1. SPM (Top Module)

The top module connects multiple Carry Save Adders together using a generate loop.

Inputs

- Clock (`clk`)
- Reset (`rst`)
- 32-bit input (`x`)
- 1-bit input (`y`)

Output

- Product bit (`p`)

---

## 2. CSADD (Carry Save Adder)

Each CSADD module performs addition using two half adders and stores the carry for the next clock cycle.

Functions:

- Computes partial sum
- Stores carry in a register
- Produces one stage of the serial multiplication

---

## 3. TCMP (Transition Comparator)

The TCMP module processes the final stage of the multiplication chain.

Functions:

- Stores previous state
- Detects transitions
- Produces the final propagated output

---

# Important Verilog Code

## Top Module Declaration

```verilog
module spm(clk, rst, x, y, p);
```

Defines the top-level module.

---

## Design Size

```verilog
parameter size = 32;
```

Sets the multiplier width to 32 bits.

---

## Generate Loop

```verilog
generate
for(i=1; i<size-1; i=i+1)
begin
    CSADD csa (...);
end
endgenerate
```

Automatically creates multiple CSADD instances, avoiding manual instantiation.

---

## First CSADD

```verilog
CSADD csa0(
    .x(x[0]&y),
    .y(pp[1]),
    .sum(p)
);
```

Processes the least significant bit.

---

## Final TCMP

```verilog
TCMP tcmp(
    .a(x[size-1]&y),
    .s(pp[size-1])
);
```

Processes the most significant stage.

---

## Sequential Logic

```verilog
always @(posedge clk or posedge rst)
```

All computations occur synchronously with the clock.

---

## Carry Register

```verilog
sc <= hco1 ^ hco2;
```

Stores carry information for the next clock cycle.

---

# OpenLane Configuration

Important configuration parameters used in this project:

| Parameter | Description |
|-----------|-------------|
| DESIGN_NAME | Top module name |
| VERILOG_FILES | RTL source files |
| CLOCK_PERIOD | Clock period (10 ns) |
| CLOCK_PORT | Primary clock input |
| FP_CORE_UTIL | Core utilization (45%) |
| DIE_AREA | Chip boundary |
| CORE_AREA | Standard-cell placement region |
| FP_PIN_ORDER_CFG | I/O pin placement configuration |
| FP_PDN_SKIPTRIM | Enables PDN trimming control |

---

# pin_order.cfg

The `pin_order.cfg` file specifies the location of I/O pins around the chip boundary.

```
#N
x.*

#S
rst

#E
clk

#W
p
y
```

This places:

- x[] → North
- rst → South
- clk → East
- p, y → West

---

# OpenLane Flow

### Launch OpenLane

```tcl
flow.tcl -interactive
```

### Prepare Design

```tcl
prep -design spm
```

### Run Synthesis

```tcl
run_synthesis
```

### Run Floorplan

```tcl
run_floorplan
```

---

# Floorplanning

During floorplanning OpenLane performs the following tasks:

- Defines Die Area
- Creates Core Area
- Generates Standard Cell Rows
- Places I/O Pins
- Generates Power Distribution Network (PDN)
- Produces the Floorplan DEF file

---

# Floorplan Output

The main output generated is

```
spm.def
```

It contains

- Die dimensions
- Core dimensions
- Standard-cell rows
- I/O pin locations
- Power rails
- PDN information

The DEF file can be viewed using KLayout.

---

# Results

Successfully completed:

- RTL Synthesis
- Floorplanning
- I/O Placement
- Tap Cell Insertion
- Power Distribution Network Generation

Generated outputs include:

- Floorplan DEF
- OpenDB database
- Floorplan reports
- Execution logs
- KLayout floorplan visualization

---

# Key Learning Outcomes

- Understood the role of floorplanning in the RTL-to-GDSII flow.
- Configured floorplan parameters using OpenLane.
- Learned die area and core area concepts.
- Implemented custom I/O pin placement.
- Generated and analyzed the Power Distribution Network (PDN).
- Visualized the floorplan using KLayout.
- Prepared the design for placement, CTS, and routing.

---

# Tools Used

- OpenLane
- OpenROAD
- Yosys
- OpenSTA
- KLayout
- Sky130 PDK
- Verilog HDL

---

# Conclusion

This lab successfully demonstrated the floorplanning stage of an SPM (Serial Parallel Multiplier) design using OpenLane. The synthesized design was converted into a physical floorplan by defining the die area, core area, standard-cell rows, I/O pin locations, and power distribution network. The generated DEF file was verified in KLayout, confirming that the design is correctly prepared for the next stages of physical design, including placement, clock tree synthesis, and routing.
