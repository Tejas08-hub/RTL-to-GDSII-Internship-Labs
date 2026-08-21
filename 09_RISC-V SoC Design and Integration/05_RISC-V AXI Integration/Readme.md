# RISC-V AXI Integration

**Course:** PicoRV32 SoC Subsystem with AXI-Lite & UART Integration

## 1. Title

**RISC-V AXI Integration — Bridging PicoRV32 Native Bus to AXI-Lite Protocol**

---

## 2. Objective

The objective of this lab is to understand how a PicoRV32 processor's native memory interface can be connected to an AXI-Lite based peripheral system using a protocol bridge.

By completing this lab, the following concepts are demonstrated:

- Understand why a protocol bridge is required between PicoRV32 and AXI-Lite.
- Understand the PicoRV32 `mem_valid` / `mem_ready` interface.
- Understand the five AXI-Lite channels.
- Understand AXI-Lite VALID/READY handshaking.
- Trace AXI-Lite write and read transactions.
- Understand the CPU-to-AXI bridge FSM.
- Verify write and read transactions using simulation and GTKWave.

---

## 3. Background

PicoRV32 uses a simple native memory interface:

```text
CPU
 │
 │ mem_valid
 │ mem_addr
 │ mem_wdata
 │ mem_wstrb
 ▼
Memory / Peripheral
 │
 │ mem_ready
 │ mem_rdata
 ▼
CPU
```

AXI-Lite, on the other hand, uses five independent channels:

### Write Channels

- **AW** — Write Address
- **W** — Write Data
- **B** — Write Response

### Read Channels

- **AR** — Read Address
- **R** — Read Data

Therefore, PicoRV32 cannot be directly connected to an AXI-Lite peripheral.

A bridge is required to translate:

```text
PicoRV32 Native Bus
        │
        ▼
+-------------------+
|   AXI-Lite Bridge |
+-------------------+
        │
        ▼
   AXI-Lite Bus
        │
        ▼
   AXI Peripheral
```

The CPU does not need to understand AXI-Lite. The bridge handles the protocol conversion.

---

## 4. PicoRV32 Native Interface

The important CPU-side signals are:

| Signal | Description |
|---|---|
| `cpu_mem_valid` | Indicates that the CPU has a memory request |
| `cpu_mem_addr[31:0]` | Address of the memory access |
| `cpu_mem_wdata[31:0]` | Write data |
| `cpu_mem_wstrb[3:0]` | Write byte enables |
| `cpu_mem_ready` | Indicates that the transaction is complete |
| `cpu_mem_rdata[31:0]` | Read data returned to the CPU |
| `cpu_mem_instr` | Indicates an instruction fetch |

### Read vs Write

A write is identified by:

```verilog
|cpu_mem_wstrb != 0
```

A read is identified by:

```verilog
|cpu_mem_wstrb == 0
```

---

## 5. AXI-Lite Channels

### 5.1 Write Address Channel — AW

Master sends the address to the slave.

Important signals:

```text
AWADDR
AWVALID
AWREADY
```

Handshake occurs when:

```text
AWVALID && AWREADY = 1
```

---

### 5.2 Write Data Channel — W

Master sends the data and byte enables.

Important signals:

```text
WDATA
WSTRB
WVALID
WREADY
```

Handshake occurs when:

```text
WVALID && WREADY = 1
```

---

### 5.3 Write Response Channel — B

Slave informs the master that the write has completed.

Important signals:

```text
BRESP
BVALID
BREADY
```

Handshake occurs when:

```text
BVALID && BREADY = 1
```

---

### 5.4 Read Address Channel — AR

Master sends the address that it wants to read.

Important signals:

```text
ARADDR
ARVALID
ARREADY
```

Handshake occurs when:

```text
ARVALID && ARREADY = 1
```

---

### 5.5 Read Data Channel — R

Slave returns the requested data.

Important signals:

```text
RDATA
RRESP
RVALID
RREADY
```

Handshake occurs when:

```text
RVALID && RREADY = 1
```

---

## 6. VALID / READY Handshake

The fundamental AXI-Lite rule is:

> A transfer occurs on the rising clock edge when both VALID and READY are HIGH.

For example:

```text
VALID  = 1
READY  = 1
----------------
TRANSFER OCCURS
```

The master may assert `VALID` without waiting for `READY`.

The slave may assert `READY` before `VALID`.

The master must keep `VALID` asserted until the handshake occurs.

---

## 7. Bridge FSM

The CPU-to-AXI bridge is implemented using a finite state machine.

### FSM States

| State | Value | Function |
|---|---:|---|
| `ST_IDLE` | 0 | Wait for CPU memory request |
| `ST_WR_AW` | 1 | Issue AXI write address/data |
| `ST_WR_B` | 2 | Wait for write response |
| `ST_RD_AR` | 3 | Issue AXI read address |
| `ST_RD_R` | 4 | Wait for read data |

### State Flow

Write:

```text
ST_IDLE
   │
   │ CPU Write Request
   ▼
ST_WR_AW
   │
   │ AW/W Handshake
   ▼
ST_WR_B
   │
   │ B Handshake
   ▼
ST_IDLE
```

Read:

```text
ST_IDLE
   │
   │ CPU Read Request
   ▼
ST_RD_AR
   │
   │ AR Handshake
   ▼
ST_RD_R
   │
   │ R Handshake
   ▼
ST_IDLE
```

---

## 8. Write Transaction

A PicoRV32 write is converted into an AXI-Lite write transaction.

### Step 1 — CPU Request

The CPU asserts:

```text
cpu_mem_valid = 1
cpu_mem_wstrb != 0
```

The bridge identifies this as a write.

---

### Step 2 — AW Channel

The bridge presents:

```text
m_axi_awaddr
m_axi_awvalid
```

The slave responds with:

```text
m_axi_awready
```

The address transfer occurs when:

```text
m_axi_awvalid && m_axi_awready
```

---

### Step 3 — W Channel

The bridge presents:

```text
m_axi_wdata
m_axi_wstrb
m_axi_wvalid
```

The slave responds with:

```text
m_axi_wready
```

The data transfer occurs when:

```text
m_axi_wvalid && m_axi_wready
```

---

### Step 4 — B Channel

After the write is accepted, the slave generates:

```text
m_axi_bvalid = 1
```

The bridge responds:

```text
m_axi_bready = 1
```

The write response completes when:

```text
m_axi_bvalid && m_axi_bready
```

The bridge then asserts:

```text
cpu_mem_ready = 1
```

to indicate that the CPU transaction is complete.

---

## 9. Read Transaction

A PicoRV32 read is converted into an AXI-Lite read transaction.

### Step 1 — CPU Request

The CPU asserts:

```text
cpu_mem_valid = 1
cpu_mem_wstrb = 0
```

The bridge identifies this as a read.

---

### Step 2 — AR Channel

The bridge presents:

```text
m_axi_araddr
m_axi_arvalid
```

The slave responds:

```text
m_axi_arready
```

The address handshake occurs when:

```text
m_axi_arvalid && m_axi_arready
```

---

### Step 3 — R Channel

The slave returns:

```text
m_axi_rdata
m_axi_rvalid
```

The bridge asserts:

```text
m_axi_rready
```

The read completes when:

```text
m_axi_rvalid && m_axi_rready
```

The bridge captures:

```text
rdata_r <= m_axi_rdata
```

and asserts:

```text
cpu_mem_ready = 1
```

The CPU receives the returned data through:

```text
cpu_mem_rdata
```

---

## 10. Testbench

The standalone testbench is:

```text
tb/tb_riscv_axi_lite.v
```

The testbench demonstrates:

1. AXI-Lite write transaction.
2. AW handshake.
3. W handshake.
4. B response.
5. AXI-Lite read transaction.
6. AR handshake.
7. R response.
8. Data comparison.

The test writes:

```text
Address = 0x10000000
Data    = 0x000000A5
```

and then reads the same address.

Expected result:

```text
Write Data = 0x000000A5
Read Data  = 0x000000A5
```

---

## 11. Simulation

The simulation is executed using:

```bash
make riscv_axi
```

The testbench generates:

```text
tb_riscv_axi_lite.vcd
```

GTKWave can be opened using:

```bash
gtkwave tb_riscv_axi_lite.vcd &
```

---

## 12. Expected Simulation Result

The expected transaction sequence is:

```text
AXI WRITE TRANSACTION

AWADDR  = 0x10000000
WDATA   = 0x000000A5

AWVALID = 1
AWREADY = 1
→ Address Handshake

WVALID  = 1
WREADY  = 1
→ Data Handshake

BVALID  = 1
BREADY  = 1
→ Write Response
```

Then:

```text
AXI READ TRANSACTION

ARADDR  = 0x10000000

ARVALID = 1
ARREADY = 1
→ Address Handshake

RDATA   = 0x000000A5
RVALID  = 1
RREADY  = 1
→ Read Data Handshake
```

Final verification:

```text
Write = Success
Read  = Success
```

The read data must match the previously written value:

```text
0x000000A5
```

---

## 13. Waveform Signals

The following signals were added to GTKWave for verification:

### Clock and Reset

```text
clk
reset
```

### AXI Write Address

```text
m_awaddr[31:0]
m_awvalid
s_awready
```

### AXI Write Data

```text
m_wdata[31:0]
m_wvalid
s_wready
```

### AXI Write Response

```text
s_bvalid
m_bready
```

### AXI Read Address

```text
m_araddr[31:0]
m_arvalid
s_arready
```

### AXI Read Data

```text
s_rdata[31:0]
s_rvalid
m_rready
```

---

## 14. Waveform Verification

### Write Verification

Check the following sequence:

```text
m_awvalid = 1
s_awready = 1
```

This indicates the AW handshake.

Then verify:

```text
m_wvalid = 1
s_wready = 1
```

This indicates the W handshake.

Finally:

```text
s_bvalid = 1
m_bready = 1
```

This indicates the B response handshake.

---

### Read Verification

First check:

```text
m_arvalid = 1
s_arready = 1
```

This indicates the AR handshake.

Then check:

```text
s_rvalid = 1
m_rready = 1
```

At this moment verify:

```text
s_rdata = 0x000000A5
```

This confirms correct read-data transfer.

---

## 15. Bridge FSM Verification

When observing the complete SoC, the bridge FSM can be monitored using:

```text
b_state[2:0]
```

State encoding:

| Value | State | Description |
|---:|---|---|
| `3'd0` | `ST_IDLE` | Waiting for CPU request |
| `3'd1` | `ST_WR_AW` | Write address/data transaction |
| `3'd2` | `ST_WR_B` | Waiting for write response |
| `3'd3` | `ST_RD_AR` | Read address transaction |
| `3'd4` | `ST_RD_R` | Waiting for read data |

Expected write sequence:

```text
ST_IDLE → ST_WR_AW → ST_WR_B → ST_IDLE
```

Expected read sequence:

```text
ST_IDLE → ST_RD_AR → ST_RD_R → ST_IDLE
```

---

## 16. Files

```text
05_RISC-V AXI Integration/
│
├── rtl/
│   ├── top.v
│   ├── axi_lite_interconnect.v
│   └── axi_decoder.v
│
├── tb/
│   └── tb_riscv_axi_lite.v
│
├── results/
│   ├── Simulation_Result.png
│   └── waveform.png
│
└── README.md
```

### File Description

| File | Purpose |
|---|---|
| `rtl/top.v` | Contains the PicoRV32-to-AXI-Lite bridge FSM |
| `rtl/axi_lite_interconnect.v` | AXI-Lite interconnect |
| `rtl/axi_decoder.v` | AXI address decoding |
| `tb/tb_riscv_axi_lite.v` | Standalone AXI-Lite verification testbench |
| `results/Simulation_Result.png` | Simulation terminal output |
| `results/waveform.png` | GTKWave waveform showing AXI transactions |

---

## 17. Common Debugging Issues

| Issue | Possible Cause | Debug Method |
|---|---|---|
| Bridge stuck in `ST_WR_AW` | `AWREADY` not asserted | Check AXI interconnect |
| Bridge stuck in `ST_RD_R` | `RVALID` not asserted | Check AXI slave read response |
| `cpu_mem_ready` never asserts | FSM does not complete | Monitor `b_state` |
| Wrong read data | Data captured at wrong time | Check `RVALID && RREADY` |
| No waveform activity | Wrong VCD file | Check generated `.vcd` file |
| AW handshake missing | VALID/READY mismatch | Check `AWVALID` and `AWREADY` |
| W handshake missing | Data channel not accepted | Check `WVALID` and `WREADY` |
| B response missing | Write transaction incomplete | Check AW/W handshakes |
| R response missing | Read request not completed | Check AR handshake |

---

## 18. AXI-Lite Protocol Checklist

Before considering the design verified:

- [x] AWVALID remains asserted until AWREADY.
- [x] WVALID remains asserted until WREADY.
- [x] BREADY accepts the write response.
- [x] ARVALID remains asserted until ARREADY.
- [x] RREADY accepts returned read data.
- [x] Write data reaches the AXI slave.
- [x] Read data matches the previously written data.
- [x] CPU receives `mem_ready`.
- [x] Bridge returns correct `mem_rdata`.
- [x] FSM returns to `ST_IDLE`.

---

## 19. Key Learning

This lab demonstrates the important role of a protocol bridge in a SoC.

The PicoRV32 processor uses:

```text
mem_valid / mem_ready
```

while AXI-Lite uses:

```text
AW
W
B
AR
R
```

The bridge translates between these two interfaces.

```text
PicoRV32
   │
   │ Native Memory Bus
   ▼
+--------------------+
|   AXI-Lite Bridge  |
|                    |
| ST_IDLE            |
| ST_WR_AW           |
| ST_WR_B            |
| ST_RD_AR           |
| ST_RD_R            |
+--------------------+
   │
   │ AXI-Lite
   ▼
AXI Interconnect
   │
   ▼
AXI Peripheral
```

This allows the RISC-V processor to communicate with AXI-Lite peripherals without requiring the CPU itself to understand the AXI-Lite protocol.

---

## 20. Lab Result

The standalone AXI-Lite testbench successfully demonstrated:

```text
Write Address : 0x10000000
Write Data    : 0x000000A5

Read Address  : 0x10000000
Read Data     : 0x000000A5
```

Therefore:

```text
WRITE → PASS
READ  → PASS
```

The AXI-Lite bridge and handshake behavior were verified using simulation and GTKWave.

---

## 21. Conclusion

This lab establishes the connection between the RISC-V processor and the AXI-Lite peripheral subsystem.

The key concept is:

```text
PicoRV32 Native Bus
        ↓
   AXI-Lite Bridge
        ↓
    AXI-Lite Bus
        ↓
 AXI Peripheral
```

The bridge converts simple CPU memory requests into valid AXI-Lite transactions and converts AXI responses back into PicoRV32 `mem_ready` and `mem_rdata` signals.

This forms the foundation for integrating UART and other memory-mapped peripherals into the complete RISC-V SoC.
