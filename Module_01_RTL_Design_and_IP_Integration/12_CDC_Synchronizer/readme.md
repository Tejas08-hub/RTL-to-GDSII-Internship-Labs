# Clock Domain Crossing (CDC) Synchronizer Using Two Flip-Flops in Verilog

## Overview

This project implements a **2-Flip-Flop Clock Domain Crossing (CDC) Synchronizer** in Verilog HDL. The design is used to safely transfer a single-bit asynchronous signal into a synchronous clock domain while significantly reducing the probability of metastability.

In digital systems, signals originating from external devices, sensors, push buttons, communication interfaces, or different clock domains may not be synchronized with the system clock. Directly sampling such signals can lead to metastability, causing unreliable circuit behavior.

The 2-Flip-Flop Synchronizer is the most commonly used industry solution for handling single-bit asynchronous signals.

---

# Objective

* Understand Clock Domain Crossing (CDC).
* Learn the concept of metastability.
* Implement a two-stage synchronizer.
* Observe how synchronization reduces metastability risk.
* Analyze waveform behavior using GTKWave.
* Learn industry-standard synchronization techniques used in FPGA and ASIC designs.

---

# Background Theory

## What is a Clock Domain?

A clock domain is a group of sequential elements driven by the same clock signal.

Example:

```text
Clock Domain A
    |
    ├── Flip-Flop
    ├── Counter
    └── Register

Clock Domain B
    |
    ├── Flip-Flop
    ├── State Machine
    └── Register
```

Signals moving between different clock domains require special handling.

---

# What is Clock Domain Crossing (CDC)?

Clock Domain Crossing occurs when a signal generated in one clock domain is sampled by another clock domain.

Example:

```text
Domain A                Domain B

Signal -----> Synchronizer -----> Logic
```

If synchronization is not performed correctly, metastability may occur.

---

# What is Metastability?

A flip-flop requires its input to remain stable for a certain period before and after the clock edge.

These requirements are known as:

* Setup Time
* Hold Time

If these timing requirements are violated, the flip-flop may enter an undefined intermediate state called metastability.

Instead of immediately becoming:

```text
0
or
1
```

the output may temporarily remain in an unstable condition.

---

# Why Metastability is Dangerous

Metastability can cause:

* Incorrect logic decisions
* Unpredictable outputs
* State machine failures
* Data corruption
* Timing violations
* System instability

Therefore, asynchronous signals should never be directly connected to critical synchronous logic.

---

# Design Description

The design consists of two cascaded D Flip-Flops.

## Verilog Code

```verilog
module cdc_synchronizer(
    input clk,
    input async_in,
    output reg synced
);

reg stage1;

always @(posedge clk)
begin
    stage1 <= async_in;
    synced <= stage1;
end

endmodule
```

---

# Module Interface

## Inputs

| Signal   | Width | Description               |
| -------- | ----- | ------------------------- |
| clk      | 1     | System clock              |
| async_in | 1     | Asynchronous input signal |

## Outputs

| Signal | Width | Description                |
| ------ | ----- | -------------------------- |
| synced | 1     | Synchronized output signal |

---

# Internal Registers

## stage1

```verilog
reg stage1;
```

Purpose:

* First synchronization stage.
* Directly samples the asynchronous signal.
* May temporarily become metastable.

---

## synced

```verilog
output reg synced;
```

Purpose:

* Second synchronization stage.
* Receives data from stage1.
* Provides stable output to the rest of the system.

---

# Hardware Architecture

The design can be represented as:

```text
               +--------+
async_in ----->| FF1    |
               +--------+
                    |
                    v
               +--------+
               | FF2    |
               +--------+
                    |
                    v
                 synced
```

Where:

* FF1 = First synchronization stage
* FF2 = Second synchronization stage

---

# Working Principle

## Step 1: Sampling Asynchronous Input

At the first clock edge:

```verilog
stage1 <= async_in;
```

The asynchronous input is captured by FF1.

If the input changes near the clock edge:

```text
Possible Metastability
```

may occur in FF1.

---

## Step 2: Resolution Time

After FF1 samples the signal, it is given an entire clock cycle to settle.

During this period:

```text
Metastable State
       ↓
       ↓
Settles to 0 or 1
```

The probability of remaining metastable decreases rapidly with time.

---

## Step 3: Sampling by Second Flip-Flop

At the next clock edge:

```verilog
synced <= stage1;
```

FF2 samples the already-settled output of FF1.

As a result:

```text
Stable Output
```

is produced.

---

# Why Two Flip-Flops?

Using only one flip-flop:

```text
async_in
    |
    v
  FF1
    |
Output
```

allows metastability to propagate directly into the system.

Using two flip-flops:

```text
async_in
    |
    v
  FF1
    |
    v
  FF2
    |
Output
```

provides additional settling time, dramatically reducing the probability of metastability affecting the design.

---

# Testbench Description

The testbench generates:

* System clock
* Asynchronous input transitions
* Waveform dump file

The asynchronous input intentionally changes at times unrelated to the clock to simulate real-world conditions.

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
async_in = 0;
```

---

## Transition 1

```verilog
#12 async_in = 1;
```

Input changes asynchronously.

---

## Transition 2

```verilog
#7 async_in = 0;
```

Input changes independently of clock.

---

## Transition 3

```verilog
#6 async_in = 1;
```

Occurs close to a clock edge.

Potential metastability condition.

---

## Transition 4

```verilog
#9 async_in = 0;
```

Another asynchronous transition.

---

# Expected Waveform Behavior

```text
clk

_|‾|_|‾|_|‾|_|‾|_|‾|_

async_in

_____|‾‾‾|_____|‾|____

stage1

_________|‾‾‾|_____|‾|

synced

______________|‾‾‾|____
```

Observation:

* async_in changes at arbitrary times.
* stage1 captures async_in at clock edges.
* synced follows stage1 one clock cycle later.
* Output becomes synchronized with the system clock.

---

# Waveform Signals to Observe

Monitor:

```text
clk
async_in
stage1
synced
```

Key observations:

* Asynchronous input transitions.
* Delay introduced by synchronization stages.
* Stable synchronized output generation.

---

# Simulation Procedure

## Compile

```bash
iverilog -o sim cdc_synchronizer.v cdc_sync_tb.v
```

## Run Simulation

```bash
vvp sim
```

## Open GTKWave

```bash
gtkwave dump.vcd
```

---

# Applications

CDC Synchronizers are used extensively in:

* UART receivers
* SPI interfaces
* I2C interfaces
* Push-button debouncing circuits
* External interrupt handling
* FPGA input synchronization
* Sensor interfaces
* Multi-clock digital systems

---

# Limitations

This synchronizer is suitable only for:

```text
Single-Bit Signals
```

Examples:

* Enable signals
* Interrupt signals
* Control signals
* Status flags

It is NOT suitable for:

```text
Multi-Bit Data Transfer
```

For multi-bit CDC, techniques such as:

* Asynchronous FIFO
* Handshake Synchronizer
* Gray Code Synchronizer

are commonly used.

---

# Comparison with Metastability Demonstration Lab

| Feature                  | Metastability Lab   | CDC Synchronizer Lab |
| ------------------------ | ------------------- | -------------------- |
| Flip-Flops Used          | 1                   | 2                    |
| Purpose                  | Demonstrate problem | Demonstrate solution |
| Metastability Protection | No                  | Yes                  |
| CDC Safe                 | No                  | Yes                  |
| Industry Usage           | Educational         | Practical Design     |

---

# Learning Outcomes

After completing this project, the following concepts can be understood:

* Clock Domain Crossing (CDC)
* Metastability
* Setup and Hold Time
* Synchronizer Design
* Two-Flip-Flop Synchronizer
* Digital Timing Concepts
* FPGA and ASIC Design Practices
* Waveform Analysis Using GTKWave

---

# Conclusion

This project demonstrates the implementation of a 2-Flip-Flop Clock Domain Crossing (CDC) Synchronizer in Verilog HDL. The design captures an asynchronous input signal and safely transfers it into a synchronous clock domain. By providing additional settling time through a second flip-flop stage, the probability of metastability propagating through the system is greatly reduced. This technique is widely used in FPGA and ASIC designs and forms the foundation of reliable clock domain crossing methodologies.
