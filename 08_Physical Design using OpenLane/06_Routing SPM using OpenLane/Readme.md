# 06_Routing SPM using OpenLane

## Overview

This lab demonstrates the **Routing** stage of the RTL-to-GDSII physical design flow using **OpenLane**. After synthesis, floorplanning, placement, and Clock Tree Synthesis (CTS), the routing stage creates all physical interconnections required for the design. It connects signal nets, clock nets, and power nets while following the design rules of the Sky130 technology.

Routing is one of the most critical stages in ASIC implementation because it determines the physical wiring of the chip and directly impacts timing, power, manufacturability, and reliability.

---

# Objectives

- Understand the role of routing in the RTL-to-GDSII flow.
- Perform global and detailed routing using OpenLane.
- Connect all signal, clock, and power nets.
- Analyze metal layer utilization and via insertion.
- Verify routing quality using KLayout.
- Prepare the design for physical verification and GDSII generation.

---

# Design Used

**Design Name:** Serial Parallel Multiplier (SPM)

The Serial Parallel Multiplier (SPM) is a sequential arithmetic circuit that performs multiplication by processing one operand serially while the other operand is available in parallel.

The design consists of:

- Top Module (`spm`)
- Carry Save Adder (`CSADD`)
- Transition Comparator (`TCMP`)

---

# Tools Used

- OpenLane
- OpenROAD
- TritonRoute
- Yosys
- KLayout
- Sky130 PDK

---

# Project Structure

```
06_Routing SPM using OpenLane
│
├── config
│   ├── config.json
│   ├── pin_order.cfg
│   └── spm.sdc
│
├── src
│   └── spm.v
│
├── layout
│   ├── spm.def
│   └── spm.odb
│
├── logs
│
├── reports
│
└── screenshots
```

---

# OpenLane Flow

The complete physical design flow executed is:

```
flow.tcl -interactive
prep -design spm
run_synthesis
run_floorplan
run_placement
run_cts
run_routing
```

The routing stage is executed using:

```
run_routing
```

During routing, OpenLane performs:

- Global Routing
- Routing Optimization
- Antenna Repair
- Fill Cell Insertion
- Detailed Routing
- Final Routing Checks

---

# Routing Stages

## 1. Global Routing

Global routing determines an approximate routing path for every net without creating exact metal geometries.

Its objectives are:

- Reduce congestion
- Select routing layers
- Estimate wire lengths
- Prepare the design for detailed routing

---

## 2. Detailed Routing

Detailed routing converts the global routing solution into actual metal wires and vias.

During this stage:

- Exact wire geometries are created.
- Metal layers are assigned.
- Vias are inserted.
- Design Rule Checks (DRC) are satisfied.
- Pin-to-pin connectivity is completed.

---

# Metal Layers Used

The Sky130 standard cell library provides multiple routing layers.

Common routing layers include:

| Layer | Preferred Direction |
|--------|---------------------|
| Metal1 | Horizontal |
| Metal2 | Vertical |
| Metal3 | Horizontal |
| Metal4 | Vertical |
| Metal5 | Horizontal |

Routing alternates horizontal and vertical layers to reduce congestion and improve routing efficiency.

---

# Routing Outputs

After successful routing, OpenLane generates:

- Routed DEF file
- Routed ODB database
- Routing logs
- Routing reports
- Updated netlist
- Timing reports

---

# Viewing Routed Layout

The routed layout can be viewed in KLayout using:

```
klayout spm.def merged.nom.lef
```

The routed DEF contains:

- Signal routing
- Clock routing
- Power routing
- Metal layers
- Vias
- Standard cells

---

# Clock Tree after Routing

After routing, the complete clock tree becomes visible because the CTS-generated clock network has now been physically routed.

By disabling all layers except **Metal2** and **Metal3**, the routed clock tree can be clearly observed.

This helps visualize:

- Clock buffers
- Clock branches
- Clock distribution network
- Routed clock wires

---

# Results

Routing completed successfully with:

- Successful Global Routing
- Successful Detailed Routing
- Clock Routing Completed
- Power Routing Completed
- Via Insertion Completed
- No Open Nets
- No Disconnected Pins
- No DRC Violations after Detailed Routing

---

# Screenshots

The repository contains screenshots of:

- OpenLane Routing Flow
- Routed Layout
- Zoomed Routed Layout
- Metal Layer Routing
- Routed Clock Tree (M2 & M3)

---

# Learning Outcomes

After completing this lab, I learned:

- Difference between Global Routing and Detailed Routing.
- How OpenLane performs routing automatically.
- Metal layer assignment strategy.
- Via insertion between routing layers.
- Routing congestion concepts.
- Clock routing after CTS.
- Viewing routed layouts using KLayout.
- Understanding routed DEF files.

---

# Conclusion

In this lab, the **Routing** stage of the RTL-to-GDSII flow was successfully completed using OpenLane. The router connected all signal, clock, and power nets while satisfying the Sky130 design rules. Both global and detailed routing were completed successfully, and the final routed layout was verified using KLayout.

The routed design showed proper metal layer utilization, via insertion, clock distribution, and clean connectivity with no reported DRC violations after detailed routing. This routed database is now ready for the remaining backend stages such as physical verification, GDSII generation, and signoff.
