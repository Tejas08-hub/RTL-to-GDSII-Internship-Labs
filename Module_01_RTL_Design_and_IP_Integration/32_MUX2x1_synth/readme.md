# 32_MUX2x1_synth

## Overview

This project demonstrates the RTL synthesis of a **2:1 Multiplexer (MUX)** using **Yosys**, an open-source synthesis tool. The Verilog RTL design is synthesized, optimized, and mapped to the **OSU018 standard cell library**, producing a gate-level netlist and a synthesized circuit schematic.

This lab is part of the **RTL Design and IP Integration** module of the **RTL-to-GDSII Internship**.

---

## Objective

- Design a 2:1 Multiplexer using Verilog HDL.
- Perform RTL synthesis using Yosys.
- Optimize the RTL design.
- Map the design to the OSU018 standard cell library.
- Generate the synthesized gate-level netlist.
- Visualize the synthesized hardware schematic.

---

## Tools Used

- **Yosys** – RTL Synthesis
- **GVim** – Verilog Code Editor
- **Graphviz / xdot** – Schematic Visualization
- **OSU018 Standard Cell Library**
- **Ubuntu Linux**

---

## Project Structure

```
32_MUX2x1_synth/
├── mux2x1.v
├── mux2x1.ys
├── mux2x1_synth.v
├── mux2x1_schematic.dot
└── README.md
```

---

## File Description

| File | Description |
|------|-------------|
| `mux2x1.v` | RTL Verilog design of the 2:1 Multiplexer |
| `mux2x1.ys` | Yosys synthesis script |
| `mux2x1_synth.v` | Synthesized gate-level Verilog netlist |
| `mux2x1_schematic.dot` | Graphviz schematic generated after synthesis |
| `README.md` | Project documentation |

---

## RTL Design

```verilog
module mux2x1(
    input a,
    input b,
    input sel,
    output out
);

assign out = sel ? b : a;

endmodule
```

---

## Yosys Synthesis Script

```tcl
read_verilog mux2x1.v
hierarchy -check -top mux2x1
proc
opt
techmap
opt
dfflibmap -liberty /home/lab-user/Desktop/bootcamp-files/Tech-pdks/osu018/osu018_stdcells.lib
abc -liberty /home/lab-user/Desktop/bootcamp-files/Tech-pdks/osu018/osu018_stdcells.lib
clean
write_verilog mux2x1_synth.v
show -prefix mux2x1
```

---

## Synthesis Flow

```
Verilog RTL
      │
      ▼
Read Verilog
      │
      ▼
Hierarchy Check
      │
      ▼
RTL Optimization
      │
      ▼
Technology Mapping
      │
      ▼
Standard Cell Mapping
      │
      ▼
Gate-Level Netlist
      │
      ▼
Graphical Schematic
```

---

## Standard Cell Utilization

After synthesis, the design was mapped into the following standard cells:

| Cell | Count |
|------|------:|
| INVX1 | 1 |
| NAND2X1 | 1 |
| OAI21X1 | 1 |

---

## Synthesis Results

- RTL synthesis completed successfully.
- Logic optimization performed.
- Technology mapping completed.
- Standard cell mapping completed using the OSU018 library.
- Gate-level Verilog netlist generated successfully.
- Graphical schematic generated using Graphviz.

---

## Applications

- Data Selection
- Signal Routing
- Digital Control Logic
- Embedded Systems
- FPGA Design
- ASIC Design
- Digital System Design

---

## Key Learning Outcomes

- RTL Design using Verilog HDL
- RTL Synthesis using Yosys
- Logic Optimization
- Technology Mapping
- Standard Cell Mapping
- Gate-Level Netlist Generation
- Circuit Visualization

---

## Conclusion

The RTL description of the **2:1 Multiplexer** was successfully synthesized using **Yosys**. The design was optimized and mapped to the **OSU018 standard cell library**, producing a gate-level implementation consisting of **INVX1**, **NAND2X1**, and **OAI21X1** standard cells. The synthesized netlist and generated schematic verify the correct functionality of the multiplexer and demonstrate the complete RTL synthesis flow.

**BE – Electronics and Communication Engineering**

**RTL-to-GDSII Internship**
