# Multi Clock Domain Demonstration

## Overview

This project demonstrates two fundamental clock-management techniques used in digital systems and System-on-Chip (SoC) designs:

1. **Clock Division** – Generating a slower clock from a higher-frequency clock.
2. **Clock Multiplexing** – Selecting between multiple clock sources.

The design is implemented in Verilog HDL and verified using Verilator and GTKWave. The generated waveforms provide a visual understanding of clock frequency division and clock source switching.

---

## Objective

* Understand how clock dividers generate lower-frequency clocks.
* Learn how clock multiplexers switch between different clock sources.
* Observe multiple clock domains in simulation.
* Analyze clock behavior using GTKWave.
* Gain practical exposure to clock-management techniques used in modern SoCs.

---

## Theory

### Multiple Clock Domains

Modern digital systems often operate using multiple clocks. Different modules may require different frequencies depending on performance, power consumption, and timing requirements.

Examples include:

* CPU Core Clock
* Peripheral Clock
* Memory Clock
* Communication Interface Clock

Managing multiple clock domains efficiently is an important aspect of digital design.

---

### Clock Divider

A clock divider generates a lower-frequency clock from a higher-frequency input clock.

In this project:

* Input Clock = `clk_fast`
* Output Clock = `clk_div4`

A 2-bit counter is used to divide the incoming clock frequency.

Benefits:

* Reduces switching activity
* Saves power
* Provides clocks for slower peripherals

---

### Clock Multiplexer

A clock multiplexer selects one of several clock sources based on a control signal.

In this project:

```text
sel = 0 → clk_fast
sel = 1 → clk_slow
```

The selected clock is routed to the output `muxed_clk`.

**Note:** This implementation uses a simple combinational mux and is intended for educational purposes. Real ASIC and FPGA designs typically use glitch-free clock multiplexers.

---

## Project Structure

```text
22_multi_clk_demo/
│
├── clk_mux.v
├── clk_divider.v
├── multi_clk_tb.v
├── run.sh
├── waveform.png
└── README.md
```

---

## RTL Modules

### 1. Clock Multiplexer (clk_mux.v)

Function:

* Selects between two clock sources.
* Uses the select signal `sel`.
* Outputs either `clk_fast` or `clk_slow`.

Truth Table:

| sel | clk_out  |
| --- | -------- |
| 0   | clk_fast |
| 1   | clk_slow |

---

### 2. Clock Divider (clk_divider.v)

Function:

* Uses a 2-bit counter.
* Toggles output after every four input clock cycles.
* Produces a slower clock signal.

Features:

* Divide-by-4 clock generation
* Sequential logic implementation
* Suitable for low-speed subsystems

---

## Testbench

The testbench performs the following:

### Clock Generation

Fast Clock:

```verilog
always #5 clk_fast = ~clk_fast;
```

Period:

```text
10 ns
```

Slow Clock:

```verilog
always #10 clk_slow = ~clk_slow;
```

Period:

```text
20 ns
```

---

### Reset Operation

The divider is initially reset and later released:

```verilog
#15 rst = 0;
```

---

### Clock Source Switching

Clock source selection changes during simulation:

```verilog
#60 sel = 1;
#60 sel = 0;
```

This demonstrates switching between fast and slow clock domains.

---

## Simulation Flow

### Make Script Executable

```bash
chmod +x run.sh
```

### Run Simulation

```bash
./run.sh
```

The script:

1. Compiles Verilog files using Verilator.
2. Generates simulation executable.
3. Runs simulation.
4. Creates VCD waveform file.
5. Launches GTKWave.

---

## Waveform Analysis

Signals Observed:

| Signal    | Description            |
| --------- | ---------------------- |
| clk_fast  | Fast clock source      |
| clk_slow  | Slow clock source      |
| clk_div4  | Divided clock output   |
| sel       | Clock selection signal |
| muxed_clk | Selected clock output  |

---

### Observation 1: Clock Frequencies

* `clk_fast` has a 10 ns period.
* `clk_slow` has a 20 ns period.

This confirms the existence of two independent clock domains.

---

### Observation 2: Clock Divider

The divider generates a significantly slower clock from `clk_fast`.

Characteristics:

* Lower frequency
* Reduced toggle rate
* Suitable for peripheral logic

---

### Observation 3: Clock Multiplexer

When:

```text
sel = 0
```

Output follows:

```text
clk_fast
```

When:

```text
sel = 1
```

Output follows:

```text
clk_slow
```

The waveform clearly shows the frequency change when the clock source is switched.

---

## Results

* Successfully implemented a clock divider.
* Successfully implemented a clock multiplexer.
* Verified clock source selection functionality.
* Observed frequency division through simulation.
* Analyzed multiple clock domain behavior using GTKWave.

---

## Applications

Clock management techniques are widely used in:

* Microprocessors
* FPGAs
* ASICs
* Communication systems
* Embedded controllers
* Low-power digital systems
* System-on-Chip (SoC) architectures

---

## Key Learnings

| Concept                | Learning Outcome                            |
| ---------------------- | ------------------------------------------- |
| Clock Divider          | Generate slower clocks from faster sources  |
| Clock Multiplexer      | Select between multiple clock sources       |
| Multiple Clock Domains | Understand clock management techniques      |
| Verilator              | Compile and simulate RTL designs            |
| GTKWave                | Analyze timing and frequency relationships  |
| SoC Design             | Learn practical clock distribution concepts |

---

## Conclusion

This project demonstrates the fundamental concepts of clock division and clock multiplexing in digital design. Through simulation and waveform analysis, the behavior of multiple clock domains, frequency scaling, and clock source selection was successfully verified. These techniques form the foundation of clock management systems used in modern FPGA and ASIC-based SoC designs.
