# Introduction to AXI-Lite

## 1. Overview

This lab introduces the AXI4-Lite communication protocol and demonstrates its VALID/READY handshake mechanism using a standalone Verilog testbench.

The lab performs both AXI-Lite write and read transactions and verifies that the data written to a register can be correctly read back.

The simulation was performed using Verilator, and the resulting waveforms were analyzed using GTKWave.

---

## 2. Objectives

- Understand the AXI4-Lite protocol.
- Understand the five AXI-Lite channels.
- Understand the VALID/READY handshake mechanism.
- Analyze AXI-Lite write transactions.
- Analyze AXI-Lite read transactions.
- Verify AXI-Lite response signals.
- Analyze AXI-Lite transactions using GTKWave.

---

## 3. AXI-Lite Channels

AXI4-Lite uses five independent channels:

| Channel | Direction        | Purpose        |
|---------|-------------------|----------------|
| AW      | Master → Slave    | Write address  |
| W       | Master → Slave    | Write data     |
| B       | Slave → Master    | Write response |
| AR      | Master → Slave    | Read address   |
| R       | Slave → Master    | Read data      |

---

### Write Transaction

The AXI-Lite write operation follows:

```text
AW → W → B
```

- **AW (Write Address channel):** Master drives the write address along with `AWVALID`; the slave asserts `AWREADY` when it can accept the address.
- **W (Write Data channel):** Master drives the write data and strobe along with `WVALID`; the slave asserts `WREADY` when it can accept the data.
- **B (Write Response channel):** Once the write is complete, the slave drives a response (`BRESP`) along with `BVALID`; the master asserts `BREADY` to accept it.

### Read Transaction

The AXI-Lite read operation follows:

```text
AR → R
```

- **AR (Read Address channel):** Master drives the read address along with `ARVALID`; the slave asserts `ARREADY` when it can accept the address.
- **R (Read Data channel):** Slave drives the read data along with the response (`RRESP`) and `RVALID`; the master asserts `RREADY` to accept it.

---

## 4. VALID/READY Handshake

Every AXI-Lite channel uses a two-way VALID/READY handshake:

- The source asserts `VALID` when the data/address on the channel is stable and valid.
- The destination asserts `READY` when it is able to accept the transfer.
- The transfer occurs on the clock edge where **both** `VALID` and `READY` are high.
- Either signal may be held high while waiting for the other; a transfer must not be de-asserted before it completes.

---

## 5. Simulation Setup

- **Language:** Verilog (standalone testbench, no external verification framework)
- **Simulator:** Verilator
- **Waveform viewer:** GTKWave

---

## 6. Result

The testbench performed an AXI-Lite write transaction followed by a read transaction to the same address, and confirmed that the read data matched the previously written data — verifying correct handshake and register behavior.
