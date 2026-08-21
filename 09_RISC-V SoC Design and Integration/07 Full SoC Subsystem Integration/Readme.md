# 07 Full SoC Subsystem Integration

## Overview

This lab integrates the major components of the PicoRV32-based SoC into a complete subsystem.

The design combines:

- PicoRV32 RISC-V processor
- ROM
- SRAM
- AXI-Lite interconnect
- AXI address decoder
- AXI-Lite UART peripheral
- UART transmitter
- UART receiver
- Testbench for complete SoC verification

The purpose of this lab is to verify the complete hardware data path from the RISC-V processor through the AXI-Lite infrastructure to the UART peripheral.

---

## Objective

The main objectives of this lab are:

- Integrate the PicoRV32 processor with memory and peripherals.
- Connect the processor's native memory interface to the AXI-Lite system.
- Integrate the AXI-Lite UART peripheral.
- Understand the complete CPU-to-AXI-to-UART communication path.
- Verify UART transmission from the RISC-V SoC.
- Verify UART reception and echo functionality.
- Perform complete functional verification using a Verilog testbench.
- Analyze the SoC behavior using GTKWave.

---

## SoC Architecture

The complete subsystem follows this architecture:

```text
                  +------------------+
                  |     PicoRV32     |
                  |    RISC-V CPU    |
                  +--------+---------+
                           |
                           | Native Memory Bus
                           |
                    +------v------+
                    | AXI-Lite    |
                    |   Bridge    |
                    +------+------+
                           |
                           | AXI-Lite
                           |
                  +--------v---------+
                  | AXI-Lite         |
                  | Interconnect     |
                  +---+----------+---+
                      |          |
                +-----v----+     |
                |   ROM    |     |
                +----------+     |
                                 |
                +----------+     |
                |   SRAM   |     |
                +----------+     |
                                 |
                         +-------v-------+
                         |   AXI UART    |
                         +-------+-------+
                                 |
                    +------------+------------+
                    |                         |
              +-----v-----+             +-----v-----+
              | UART TX   |             | UART RX   |
              +-----------+             +-----------+
                    |                         |
                  TX Line                  RX Line
```

---

## Main Components

### PicoRV32

PicoRV32 is the RISC-V processor core used as the CPU of the SoC.

It generates memory transactions for:

- Instruction fetches
- Data reads
- Data writes
- Peripheral accesses

### ROM

ROM stores the program instructions executed by PicoRV32.

The processor fetches instructions from ROM during program execution.

### SRAM

SRAM provides data memory for the processor.

It is used for:

- Stack
- Runtime data
- Temporary variables

### AXI-Lite Interconnect

The AXI-Lite interconnect connects the CPU-side AXI master to the available AXI-Lite slaves.

It handles the AXI-Lite:

- Write address channel
- Write data channel
- Write response channel
- Read address channel
- Read data channel

### AXI Address Decoder

The address decoder determines which peripheral responds to a particular AXI address.

The UART occupies the address region beginning at:

```
0x1000_0000
```

### AXI-Lite UART

The UART peripheral is connected as an AXI-Lite slave.

UART registers are mapped as:

| Address       | Register    |
|---------------|-------------|
| `0x1000_0000` | TX Data     |
| `0x1000_0004` | RX Data     |
| `0x1000_0008` | UART Status |

A write to the TX register causes a byte to be transmitted through the UART transmitter.

Received UART data can be accessed through the RX register.

---

## Complete Data Flow

The complete communication path is:

```text
RISC-V SoC
    |
    | Memory Access
    v
PicoRV32
    |
    | Native Memory Interface
    v
AXI-Lite Bridge
    |
    | AXI-Lite Transaction
    v
AXI Interconnect
    |
    | Address Decode
    v
AXI UART
    |
    +---------> UART TX
    |
    +<--------- UART RX
```

This demonstrates how a RISC-V processor can communicate with a UART peripheral through the AXI-Lite subsystem.

---

## UART Communication

During simulation, the SoC transmits the greeting message:

```
Hello Deepak from Nielit!
```

The testbench monitors the UART output and counts the received greeting messages.

After the greeting phase, the testbench sends:

```
PING
```

The SoC receives the characters and echoes them back.

Expected echo:

```
PING
```

---

## Simulation

### Simulation Command

From the PicoRV32 SoC project directory:

```bash
cd ~/Desktop/bootcamp-files/picorv32_soc_new
make soc
```

The `make soc` target runs the complete **PicoRV32 + UART + AXI** simulation.

### Simulation Result

The simulation successfully produced the UART greeting:

```
Hello Deepak from Nielit!
```

The testbench reported:

```
[TB] Greeting message count = 10
```

The verification result was:

```
10 GREETING MESSAGES RECEIVED
UART OUTPUT VERIFIED
```

The testbench then performed the PING echo test:

```
[TB] FIFO flushed - sending command : PING

[TB] RX byte: P
[TB] RX byte: I
[TB] RX byte: N
[TB] RX byte: G
```

Final result:

```
TEST PASSED
Echo received : PING
```

---

## Verification Summary

| Test                      | Result |
|----------------------------|--------|
| PicoRV32 execution         | PASS   |
| UART transmission          | PASS   |
| Greeting message           | PASS   |
| 10 greeting messages       | PASS   |
| UART output verification   | PASS   |
| PING reception              | PASS   |
| PING echo                  | PASS   |
| Complete SoC integration   | PASS   |

---

## Waveform

The waveform generated by the complete SoC simulation is:

```
tb_top.vcd
```

Open the waveform using:

```bash
gtkwave tb_top.vcd &
```

The waveform can be used to analyze the interaction between the processor, AXI-Lite infrastructure, and UART.

The exact internal signals available in GTKWave depend on the signals dumped by `tb_top.v`.

---

## Project Structure

```
07 Full SoC Subsystem Integration/
│
├── rtl/
│   ├── picorv32.v
│   ├── rom.v
│   ├── sram.v
│   ├── axi_lite_interconnect.v
│   ├── axi_decoder.v
│   ├── uart_axi.v
│   ├── uart_tx.v
│   ├── uart_rx.v
│   └── top.v
│
├── tb/
│   ├── tb_top.v
│   └── tb_debug.v
│
└── results/
    └── Simulation and waveform results
```

---

## Key Learning

This lab demonstrates the transition from individual RTL modules to a complete RISC-V SoC subsystem.

The major integration path is:

```text
RISC-V CPU
    ↓
Native Memory Interface
    ↓
AXI-Lite Bridge
    ↓
AXI Interconnect
    ↓
Address Decoder
    ↓
AXI UART
    ↓
UART TX/RX
```

The successful UART communication and PING echo demonstrate that the complete SoC subsystem is functionally integrated and verified.

---

## Final Result

The complete PicoRV32 SoC integration was successfully simulated.

The verification demonstrated:

- Successful RISC-V processor execution
- Successful UART transmission
- Ten greeting messages received
- UART output verified
- Successful PING reception
- Successful PING echo
- Complete SoC test passed

```
========================================
       FULL SOC VERIFICATION
========================================

10 GREETING MESSAGES RECEIVED
UART OUTPUT VERIFIED

TEST PASSED
Echo received : PING

========================================
```
