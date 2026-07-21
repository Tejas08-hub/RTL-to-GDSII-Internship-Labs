# UART Receiver Design in Verilog

## Overview

This project implements a **UART (Universal Asynchronous Receiver/Transmitter) Receiver** in Verilog HDL. The receiver accepts serial data on a single input line, reconstructs the received bits into an 8-bit parallel data word, and indicates when a valid byte has been received.

The design is based on a **Finite State Machine (FSM)** and includes synchronization logic to safely capture asynchronous serial data. A comprehensive testbench is also provided to verify functionality through simulation.

---

# Objectives

* Understand UART serial communication.
* Implement a UART receiver using Verilog HDL.
* Learn FSM-based digital design.
* Practice serial-to-parallel data conversion.
* Verify functionality using simulation and waveform analysis.

---

# UART Communication Basics

UART is an asynchronous communication protocol that transfers data one bit at a time over a single wire.

A standard UART frame consists of:

| Field     | Bits |
| --------- | ---- |
| Start Bit | 1    |
| Data Bits | 8    |
| Stop Bit  | 1    |

Example UART frame for data `8'h3C`:

```text
Idle  Start  Data Bits (LSB First)      Stop
 1      0    0 0 1 1 1 1 0 0            1
```

Important characteristics:

* Idle line remains HIGH.
* Transmission begins with a LOW start bit.
* Data bits are transmitted LSB first.
* Stop bit is HIGH.
* No separate clock signal is transmitted.

---

# Design Features

* Parameterized baud rate timing using `CLKS_PER_BIT`.
* Four-state FSM architecture.
* Two-stage synchronizer for metastability protection.
* Start bit validation.
* 8-bit serial-to-parallel conversion.
* Data ready pulse generation.
* Fully synthesizable Verilog design.
* Self-checking testbench.

---

# Module Interface

## Inputs

| Signal    | Width | Description       |
| --------- | ----- | ----------------- |
| clk       | 1     | System clock      |
| rst_n     | 1     | Active-low reset  |
| serial_in | 1     | UART serial input |

## Outputs

| Signal     | Width | Description                   |
| ---------- | ----- | ----------------------------- |
| data_out   | 8     | Received parallel byte        |
| data_ready | 1     | Indicates valid received byte |

---

# Parameter Description

```verilog
parameter integer CLKS_PER_BIT = 217;
```

This parameter defines the number of system clock cycles contained in one UART bit period.

Formula:

```text
CLKS_PER_BIT = Clock Frequency / Baud Rate
```

Example:

```text
Clock Frequency = 50 MHz
Baud Rate       = 230400

CLKS_PER_BIT = 50,000,000 / 230,400
              ≈ 217
```

---

# Internal Architecture

The receiver consists of:

1. Input Synchronizer
2. Finite State Machine
3. Bit Timing Counter
4. Bit Position Counter
5. Data Buffer
6. Output Register

---

# Input Synchronizer

## Purpose

UART data arrives asynchronously with respect to the system clock.

Directly sampling asynchronous data can lead to metastability.

To reduce this risk, a two-flop synchronizer is used.

```verilog
always @(posedge clk)
begin
 rx_meta <= serial_in;
 rx_sync <= rx_meta;
end
```

Data path:

```text
serial_in
    │
    ▼
 rx_meta
    │
    ▼
 rx_sync
```

Benefits:

* Improves reliability.
* Reduces metastability issues.
* Common practice in FPGA and ASIC designs.

---

# Finite State Machine

The UART receiver is controlled by a four-state FSM.

```verilog
IDLE
START
RECV
STOP
```

---

## State 1: IDLE

Purpose:

* Wait for start bit detection.
* UART line remains HIGH during idle.

Operation:

```verilog
if(rx_sync == 1'b0)
 state <= START;
```

Transition:

```text
IDLE → START
```

when a LOW level is detected.

---

## State 2: START

Purpose:

* Validate the start bit.
* Reject noise glitches.

Operation:

The receiver waits for half a bit period.

```verilog
if(clk_count == (CLKS_PER_BIT >> 1))
```

Then checks:

```verilog
if(rx_sync == 1'b0)
```

If still LOW:

```text
Valid Start Bit
```

Otherwise:

```text
Noise Detected
```

Transition:

```text
START → RECV
```

or

```text
START → IDLE
```

---

## State 3: RECV

Purpose:

* Receive eight data bits.

Operation:

The receiver waits one full bit period and samples the incoming data.

```verilog
data_buf[bit_index] <= rx_sync;
```

Bits are stored in:

```text
data_buf[0]
data_buf[1]
...
data_buf[7]
```

UART sends bits:

```text
LSB First
```

Example:

```text
Data = 8'h3C

Binary = 00111100

Received Order:

0
0
1
1
1
1
0
0
```

Transition:

```text
RECV → STOP
```

after receiving all eight bits.

---

## State 4: STOP

Purpose:

* Receive stop bit.
* Transfer data to output.

Operation:

After one bit period:

```verilog
data_out <= data_buf;
data_ready <= 1'b1;
```

The received byte becomes available on the output.

Transition:

```text
STOP → IDLE
```

---

# State Transition Diagram

```text
           +------+
           | IDLE |
           +------+
               |
               | Start Bit
               ▼
          +---------+
          | START   |
          +---------+
               |
               | Valid Start
               ▼
          +---------+
          | RECV    |
          +---------+
               |
               | 8 Bits Received
               ▼
          +---------+
          | STOP    |
          +---------+
               |
               ▼
           +------+
           | IDLE |
           +------+
```

---

# Data Reception Flow

```text
Idle Line Detected
        │
        ▼
Start Bit Detected
        │
        ▼
Validate Start Bit
        │
        ▼
Receive 8 Data Bits
        │
        ▼
Receive Stop Bit
        │
        ▼
Store Byte in data_out
        │
        ▼
Generate data_ready Pulse
        │
        ▼
Return to IDLE
```

---

# Testbench Description

The testbench verifies receiver functionality by acting as a UART transmitter.

Features:

* Generates system clock.
* Applies reset.
* Sends UART frames.
* Displays received data.
* Generates waveform file.
* Checks received byte count.

---

# UART Frame Generation Task

```verilog
task send_uart_frame(input [7:0] payload);
```

Operation:

1. Send Start Bit
2. Send 8 Data Bits
3. Send Stop Bit

Frame structure:

```text
Start → Data[0] → Data[1] → ... → Data[7] → Stop
```

---

# Test Sequence

### Frame 1

```verilog
send_uart_frame(8'h3C);
```

Expected:

```text
00111100
```

---

### Frame 2

```verilog
send_uart_frame(8'h2F);
```

Expected:

```text
00101111
```

---

# Expected Simulation Output

```text
RX[1] = 3C
RX[2] = 2F

PASS: Two bytes received successfully
```

---

# Waveform Signals to Observe

Important signals:

```text
clk
rst_n
serial_in
state
clk_count
bit_index
data_buf
data_out
data_ready
```

Recommended waveform analysis:

1. Verify start bit detection.
2. Observe FSM transitions.
3. Check bit sampling locations.
4. Monitor data buffer updates.
5. Confirm data_ready pulse generation.

---

# Applications

UART receivers are widely used in:

* FPGA development boards
* Microcontrollers
* Embedded systems
* Sensor interfaces
* Bluetooth modules
* GPS modules
* Serial debugging interfaces
* Computer communication systems

---

# Learning Outcomes

After completing this project, the following concepts can be understood:

* UART communication protocol
* Finite State Machine design
* Serial-to-parallel conversion
* Synchronization of asynchronous signals
* Bit timing and baud rate calculation
* Verilog HDL implementation
* Testbench development
* Digital system verification

---

# Conclusion

This project demonstrates the implementation of a UART Receiver using Verilog HDL. The design uses a finite state machine to detect the start bit, receive eight serial data bits, validate the stop bit, and generate a parallel output byte. The included testbench verifies correct operation by transmitting multiple UART frames and checking successful reception.

The project provides practical experience with UART communication, FSM design, synchronization techniques, and digital verification, making it a valuable foundation for FPGA, ASIC, and embedded system development.
