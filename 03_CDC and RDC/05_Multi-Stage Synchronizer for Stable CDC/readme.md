# Multi-Stage Synchronizer for Clock Domain Crossing (CDC)

## Overview

This project demonstrates the implementation and verification of **2-stage** and **3-stage flip-flop synchronizers** used in Clock Domain Crossing (CDC) applications. Synchronizers are essential digital design structures that reduce the probability of metastability when asynchronous signals are transferred between different clock domains.

The project includes Verilog RTL implementations, a testbench for simulation, waveform analysis using GTKWave, and automated execution through a shell script.

---

## Objective

* Understand the challenges associated with Clock Domain Crossing (CDC).
* Learn how metastability occurs when asynchronous signals are sampled.
* Implement and compare 2-stage and 3-stage synchronizers.
* Analyze synchronization delay and reliability using simulation waveforms.
* Gain hands-on experience with Verilator and GTKWave.

---

## Theory

### Clock Domain Crossing (CDC)

When a signal generated in one clock domain is sampled by another clock domain, the signal may violate setup or hold time requirements of a flip-flop. This can result in a metastable state where the output is temporarily neither logic '0' nor logic '1'.

### Metastability

Metastability is an unstable intermediate state that can propagate incorrect values through digital logic and lead to unpredictable system behavior.

### Synchronizer Solution

A common solution is to pass the asynchronous signal through multiple flip-flops clocked by the destination clock.

#### 2-Stage Synchronizer

```text
Async Input
     |
     V
+---------+
|   FF1   |
+---------+
     |
     V
+---------+
|   FF2   |
+---------+
     |
 Sync Out
```

* Industry-standard CDC solution.
* Provides excellent metastability protection.
* Introduces approximately two clock-cycle latency.

#### 3-Stage Synchronizer

```text
Async Input
     |
     V
+---------+
|   FF1   |
+---------+
     |
     V
+---------+
|   FF2   |
+---------+
     |
     V
+---------+
|   FF3   |
+---------+
     |
 Sync Out
```

* Used in high-reliability and safety-critical systems.
* Further reduces metastability probability.
* Adds one additional clock-cycle delay.

---

## Project Structure

```text
20_multi_stage_sync/
│
├── sync2_stage.v
├── sync3_stage.v
├── sync_tb.v
├── run.sh
├── waveform.png
└── README.md
```

---

## RTL Description

### sync2_stage.v

Implements a two flip-flop synchronizer.

Features:

* Two cascaded flip-flops.
* Reduces metastability propagation.
* Standard CDC implementation.

### sync3_stage.v

Implements a three flip-flop synchronizer.

Features:

* Three cascaded flip-flops.
* Higher robustness against metastability.
* Suitable for critical applications.

---

## Testbench

The testbench:

* Generates a clock with a 10 ns period.
* Produces asynchronous input transitions at non-clock aligned times.
* Instantiates both synchronizers.
* Dumps simulation results into a VCD file for waveform analysis.

Asynchronous input transitions:

```text
7 ns  -> 1
20 ns -> 0
28 ns -> 1
40 ns -> 0
```

These transitions intentionally occur between clock edges to emulate CDC conditions.

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

1. Compiles the Verilog design using Verilator.
2. Builds the simulation executable.
3. Runs the simulation.
4. Generates a VCD waveform file.
5. Opens GTKWave for analysis.

---

## Waveform Analysis

Signals observed:

| Signal    | Description                    |
| --------- | ------------------------------ |
| clk       | System clock                   |
| async_in  | Asynchronous input signal      |
| sync_out2 | Output of 2-stage synchronizer |
| sync_out3 | Output of 3-stage synchronizer |

### Observations

* `sync_out2` follows the asynchronous input after approximately two synchronization stages.
* `sync_out3` follows the asynchronous input after approximately three synchronization stages.
* The 3-stage synchronizer introduces additional latency but offers increased protection against metastability.

---

## Results

* Successful implementation of 2-stage and 3-stage CDC synchronizers.
* Verified synchronization behavior through simulation.
* Observed expected synchronization delay in waveform analysis.
* Demonstrated the trade-off between reliability and latency.

---

## Key Learnings

| Concept               | Learning Outcome                              |
| --------------------- | --------------------------------------------- |
| Clock Domain Crossing | Understanding asynchronous signal transfer    |
| Metastability         | Causes and impact on digital systems          |
| 2-Stage Synchronizer  | Standard metastability mitigation technique   |
| 3-Stage Synchronizer  | Enhanced reliability through additional stage |
| Verilator             | RTL simulation and verification               |
| GTKWave               | Waveform visualization and debugging          |

---

## Applications

* FPGA designs
* ASIC designs
* Processor interfaces
* Communication protocols
* Multi-clock systems
* Safety-critical embedded systems
* High-reliability SoCs

---

## Conclusion

This experiment demonstrates the importance of synchronizers in Clock Domain Crossing applications. By comparing 2-stage and 3-stage synchronizers, the design illustrates how additional synchronization stages improve metastability protection at the cost of increased latency. The project provides practical exposure to CDC concepts, RTL implementation, simulation, and waveform-based verification.
