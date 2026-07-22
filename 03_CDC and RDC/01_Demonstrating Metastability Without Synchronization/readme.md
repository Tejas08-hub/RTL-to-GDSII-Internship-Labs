# Metastability Demonstration Using Asynchronous Input Sampling in Verilog

## Overview

This project demonstrates the concept of **metastability** in digital systems by sampling an asynchronous input signal using a clocked flip-flop. The design intentionally uses an input that is not synchronized to the system clock, allowing observation of how asynchronous signals interact with synchronous digital circuits.

The purpose of this experiment is educational: to understand why metastability occurs, how setup and hold time violations can happen, and why synchronizers are required in practical FPGA and ASIC designs.

---

# Objective

* Understand the concept of metastability.
* Learn the difference between synchronous and asynchronous signals.
* Observe how a flip-flop samples an asynchronous input.
* Understand setup and hold time requirements.
* Learn why synchronizers are used in digital systems.
* Analyze simulation waveforms using GTKWave.

---

# Background Theory

## What is Metastability?

Digital circuits operate using logic levels:

```text
Logic 0
Logic 1
```

A flip-flop samples its input only at the active clock edge.

For reliable operation, the input signal must remain stable for a specific duration before and after the clock edge.

These requirements are called:

* Setup Time (Tsetup)
* Hold Time (Thold)

If these timing requirements are violated, the flip-flop may enter an unstable condition known as **metastability**.

In this state, the output may not immediately resolve to a valid logic level.

---

# Setup and Hold Time

## Setup Time

The minimum time the input must remain stable before the clock edge.

```text
          Setup Time
              |
Input --------|------ Stable ------|
              |
              ↓
Clock ________|↑__________________
```

---

## Hold Time

The minimum time the input must remain stable after the clock edge.

```text
Clock ________↑__________________
                 |
                 |
Input ----------|------ Stable ----
                 |
              Hold Time
```

---

## Violation Condition

If the input changes very close to the clock edge:

```text
Input ----0----1----
               ↑
Clock ---------↑----
```

the flip-flop may not determine whether the input is 0 or 1.

This condition is called metastability.

---

# Why Metastability Matters

Metastability can cause:

* Unpredictable circuit behavior
* Incorrect data sampling
* Timing failures
* Functional errors
* Reliability issues

In practical systems, metastability must be minimized using synchronization techniques.

---

# Project Description

The design contains a single D Flip-Flop that samples an asynchronous input signal.

The asynchronous input changes independently of the clock, creating the possibility of setup and hold time violations.

This project is intended to demonstrate the problem before introducing synchronization solutions.

---

# Design Module

## Verilog Code

```verilog
module metastability(
    input clk,
    input asyn_in,
    output reg sampled
);

always @(posedge clk)
begin
    sampled <= asyn_in;
end

endmodule
```

---

# Module Interface

## Inputs

| Signal  | Width | Description               |
| ------- | ----- | ------------------------- |
| clk     | 1     | System clock              |
| asyn_in | 1     | Asynchronous input signal |

## Outputs

| Signal  | Width | Description           |
| ------- | ----- | --------------------- |
| sampled | 1     | Sampled output signal |

---

# Hardware Interpretation

The design represents a single D Flip-Flop.

```text
                +---------+
asyn_in ------->| D     Q |-------> sampled
                |         |
clk ----------->|>        |
                +---------+
```

Operation:

* Input is continuously applied to the D terminal.
* On every positive clock edge, the input value is captured.
* Output updates after the clock edge.

---

# Working Principle

At every rising edge of the clock:

```verilog
sampled <= asyn_in;
```

The current value of the asynchronous input is stored in the flip-flop.

If the input changes sufficiently away from the clock edge:

```text
Reliable Sampling
```

If the input changes very close to the clock edge:

```text
Possible Metastability
```

---

# Testbench Description

The testbench generates:

* System clock
* Asynchronous input transitions
* Waveform dump file

The objective is to create input transitions at times unrelated to the clock.

---

# Clock Generation

```verilog
always #5 clk = ~clk;
```

Clock period:

```text
10 ns
```

Clock frequency:

```text
100 MHz
```

Clock edges occur at:

```text
5 ns
15 ns
25 ns
35 ns
45 ns
55 ns
...
```

---

# Input Stimulus

Initial Conditions:

```verilog
clk = 0;
asyn_in = 0;
```

---

## Event 1

```verilog
#12 asyn_in = 1;
```

Time:

```text
12 ns
```

Input changes before the next clock edge.

Clock samples at:

```text
15 ns
```

Result:

```text
sampled = 1
```

---

## Event 2

```verilog
#7 asyn_in = 0;
```

Time:

```text
19 ns
```

Clock samples at:

```text
25 ns
```

Result:

```text
sampled = 0
```

---

## Event 3

```verilog
#6 asyn_in = 1;
```

Time:

```text
25 ns
```

Notice:

```text
Input changes exactly when clock edge occurs.
```

This represents a potential setup and hold time violation.

In real hardware, this may lead to metastability.

---

## Event 4

```verilog
#9 asyn_in = 0;
```

Time:

```text
34 ns
```

Next clock edge:

```text
35 ns
```

Again, the input changes very close to the sampling edge.

This creates another metastability risk condition.

---

# Expected Waveform Behavior

```text
clk

____|‾‾‾|____|‾‾‾|____|‾‾‾|____

asyn_in

_____‾‾‾‾‾____‾‾______

sampled

_________‾‾‾____‾‾____
```

Observation:

* Output changes only at clock edges.
* Input can change at any time.
* Sampling occurs synchronously.

---

# Waveform Signals to Observe

During simulation, monitor:

```text
clk
asyn_in
sampled
```

Focus on:

* Input transitions
* Clock edges
* Output updates

Observe whether the input changes close to clock transitions.

---

# Simulation Procedure

## Compile

```bash
iverilog -o sim metastability.v metastability_tb.v
```

## Run

```bash
vvp sim
```

## Open Waveform

```bash
gtkwave dump.vcd
```

---

# Real Hardware Considerations

Although simulation may show clean transitions, actual hardware can exhibit metastability.

Reasons:

* Physical transistor delays
* Process variations
* Noise
* Timing uncertainties

Therefore, asynchronous signals should not be directly sampled in critical designs.

---

# Common Sources of Asynchronous Signals

Examples include:

* Push buttons
* Mechanical switches
* UART RX inputs
* SPI external devices
* I2C devices
* Sensor outputs
* External interrupts
* Signals crossing clock domains

---

# Industry Solution: Synchronizers

To reduce metastability probability, designers use a multi-stage synchronizer.

Example:

```verilog
reg sync1;
reg sync2;

always @(posedge clk)
begin
    sync1 <= asyn_in;
    sync2 <= sync1;
end
```

Hardware:

```text
asyn_in
    │
    ▼
+--------+
| FF1    |
+--------+
    │
    ▼
+--------+
| FF2    |
+--------+
    │
    ▼
Synchronized Output
```

Benefits:

* Significantly reduces metastability probability.
* Standard industry practice.
* Widely used in FPGA and ASIC designs.

---

# Applications

Metastability analysis is important in:

* FPGA designs
* ASIC development
* Communication interfaces
* Embedded systems
* Clock domain crossing (CDC) circuits
* High-speed digital systems

---

# Learning Outcomes

After completing this project, the following concepts can be understood:

* Asynchronous and synchronous signals
* D Flip-Flop operation
* Setup and hold time
* Metastability
* Clock-domain interaction
* Signal synchronization
* Digital timing concepts
* Waveform analysis using GTKWave

---

# Conclusion

This project demonstrates the effect of sampling an asynchronous input using a clocked flip-flop. While simulations may not accurately reproduce metastability, the design illustrates the conditions under which metastability can occur in real hardware. The experiment serves as a foundation for understanding synchronization techniques and highlights the importance of proper handling of asynchronous signals in FPGA and ASIC designs.
