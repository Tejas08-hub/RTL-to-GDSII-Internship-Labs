# Lab 6 — AXI4-Lite UART Integration

## Course

**PicoRV32 SoC Subsystem with AXI-Lite & UART Integration**

## Title

**AXI4-Lite UART Integration — UART Peripheral as an AXI-Lite Slave**

---

## 1. Objective

The objective of this lab is to understand how a UART peripheral can be integrated into an AXI4-Lite based SoC.

By completing this lab, the following concepts were studied:

- AXI4-Lite slave interface
- UART TX and RX integration
- AXI write transaction to UART TX
- AXI read transaction from UART RX
- UART register mapping
- AXI VALID/READY handshaking
- TX buffering and backpressure
- WSTRB byte selection
- UART 8N1 serial transmission
- AXI-to-UART data flow
- Functional verification using Verilator and GTKWave

---

## 2. Introduction

UART communicates using a serial bitstream, while AXI4-Lite communicates using parallel register-based transactions.

Therefore, an adapter is required to connect the two interfaces.

In this design, `uart_axi.v` acts as an **AXI4-Lite slave peripheral** and provides register access to the UART transmitter and receiver.

### Basic Data Flow

```text
             AXI4-Lite
                |
                v
        +----------------+
        |    uart_axi    |
        |                |
        | AXI Controller |
        | TX Buffer      |
        | RX Buffer      |
        +-------+--------+
                |
        +-------+-------+
        |               |
        v               v
     uart_tx         uart_rx
        |               |
        v               ^
      TX OUT          RX IN
```

The AXI master writes a byte to the UART TX register.  
The `uart_axi` module stores the byte and sends it to the UART transmitter.

For reception, the UART receiver captures a serial byte and stores it in an RX buffer. The AXI master can then read the received byte through the AXI interface.

---

## 3. UART AXI Register Map

The UART peripheral is mapped into the AXI address space.

| AXI Address | Access | Description |
|-------------|--------|-------------|
| `0x10000000` | Write | UART TX data |
| `0x10000004` | Read | UART RX data |
| `0x10000008` | Read | UART status |

### TX Register

```text
Address = 0x10000000
```

Writing a byte to this address starts UART transmission.

Example:

```text
Write 0x48 → ASCII 'H'
```

### RX Register

```text
Address = 0x10000004
```

Reading this address returns the received UART byte.

The returned data format is:

```text
[31:9]    [8]       [7:0]
   0     rx_valid   rx_data
```

### Status Register

```text
Address = 0x10000008
```

Status format:

```text
[31:2]    [1]      [0]
   0     rx_valid   0
```

Bit 1 indicates whether a received byte is available.

---

## 4. AXI Write → UART TX Path

A UART transmit operation follows this sequence:

```text
AXI Master
    |
    | AWVALID + AWADDR
    v
AXI Write Address
    |
    | AWREADY
    v
uart_axi
    |
    | WVALID + WDATA + WSTRB
    v
AXI Write Data
    |
    | WREADY
    v
TX Buffer
    |
    | buf_valid
    v
uart_tx
    |
    v
Serial TX Output
```

For example, writing:

```text
Address = 0x10000000
Data    = 0x00000048
WSTRB   = 4'b0001
```

causes the UART to transmit:

```text
'H' = 0x48
```

The UART then serializes the byte using the 8N1 frame format.

---

## 5. UART TX Frame

The UART transmitter uses an **8N1 frame**:

```text
Idle | Start | D0 D1 D2 D3 D4 D5 D6 D7 | Stop | Idle
  1     0       Data bits, LSB first       1      1
```

For the byte:

```text
0x48 = 01001000
```

the least significant bit is transmitted first.

At:

```text
CLK_FREQ  = 50 MHz
BAUD_RATE = 115200
```

the number of clock cycles per bit is approximately:

```text
CLKS_PER_BIT = 50,000,000 / 115,200
             = 434 cycles/bit
```

Therefore, each UART bit lasts approximately:

```text
434 × 20 ns = 8.68 µs
```

---

## 6. UART RX → AXI Read Path

The receive path works in the opposite direction:

```text
UART RX Input
      |
      v
   uart_rx
      |
      | data_valid
      v
 RX Buffer
      |
      | rx_buf_valid
      v
   uart_axi
      |
      | AXI Read
      v
 AXI Master
```

When the UART receiver successfully receives a byte:

```text
rx_buf_valid = 1
rx_buf_data  = received byte
```

The AXI master can then read:

```text
0x10000004
```

to retrieve the received data.

---

## 7. TX Buffer and Backpressure

The UART peripheral contains a one-byte TX buffer.

The AXI interface prevents another write from being accepted while the buffer is full.

The ready signals are controlled using:

```verilog
assign s_axi_awready = !aw_got && !buf_valid;
assign s_axi_wready  = !w_got && !buf_valid;
```

Therefore:

```text
buf_valid = 0
    |
    +--> AWREADY = 1
    +--> WREADY  = 1
```

When the buffer becomes full:

```text
buf_valid = 1
    |
    +--> AWREADY = 0
    +--> WREADY  = 0
```

This creates **backpressure** and prevents silent loss of UART transmit data.

Once the UART transmitter becomes available:

```text
TX buffer drained
      |
      v
buf_valid = 0
      |
      v
AWREADY/WREADY become active again
```

---

## 8. WSTRB Byte Selection

`WSTRB` determines which byte of the 32-bit AXI write data is valid.

For example:

```text
WSTRB = 4'b0001
```

selects:

```text
WDATA[7:0]
```

The implementation supports byte selection:

```text
WSTRB[0] → WDATA[7:0]
WSTRB[1] → WDATA[15:8]
WSTRB[2] → WDATA[23:16]
WSTRB[3] → WDATA[31:24]
```

This is important because an 8-bit firmware store may generate:

```text
WSTRB = 4'h1
```

even though AXI uses a 32-bit data bus.

---

## 9. RTL Files

The main files used in this lab are:

```text
06_AXI4-Lite UART Integration/
│
├── rtl/
│   ├── uart_axi.v
│   ├── uart_tx.v
│   └── uart_rx.v
│
├── tb/
│   ├── tb_axi_lite.v
│   └── tb_axi_lite_master.v
│
└── results/
    └── tb_axi_lite.vcd
```

### File Description

| File | Description |
|------|-------------|
| `uart_axi.v` | AXI4-Lite UART peripheral |
| `uart_tx.v` | UART transmitter |
| `uart_rx.v` | UART receiver |
| `tb_axi_lite.v` | AXI-UART integration testbench |
| `tb_axi_lite_master.v` | Reusable AXI master testbench |
| `tb_axi_lite.vcd` | Simulation waveform |

---

## 10. Important Signals

### AXI Write Channel

```text
s_axi_awaddr
s_axi_awvalid
s_axi_awready

s_axi_wdata
s_axi_wstrb
s_axi_wvalid
s_axi_wready

s_axi_bvalid
s_axi_bready
s_axi_bresp
```

### AXI Read Channel

```text
s_axi_araddr
s_axi_arvalid
s_axi_arready

s_axi_rdata
s_axi_rvalid
s_axi_rready
s_axi_rresp
```

### UART TX

```text
u_tx.tx
u_tx.state
u_tx.clk_cnt
u_tx.shift_reg
u_tx.bit_cnt
```

### UART Buffers

```text
uart_axi.buf_valid
uart_axi.aw_got
uart_axi.w_got
uart_axi.rx_buf_valid
```

---

## 11. Simulation

The AXI-UART integration was verified using the standalone testbench.

### Run the Simulation

```bash
cd ~/Desktop/bootcamp-files/picorv32_soc_new
make axi_uart
```

The simulation compiles the UART and AXI modules, executes the testbench, generates a VCD waveform, and opens GTKWave.

---

## 12. Verification Result

The AXI4-Lite UART testbench completed successfully.

### Final Result

```text
SIMULATION SUMMARY (AXI-Lite UART Testbench)

Tests run    : 17
Tests passed : 17
Tests failed : 0

*** ALL TESTS PASSED ✓ ***
```

A representative AXI write transaction was:

```text
Address : 0x10000000
Data    : 0x48000000
WSTRB   : 1000
Byte    : 'H' (0x48)
BRESP   : 00 (OKAY)
```

The UART TX line detected the start bit and serialized the transmitted byte.

---

## 13. Waveform Verification

The generated waveform can be opened using:

```bash
gtkwave tb_axi_lite.vcd &
```

### AXI Write Verification

Check the following sequence:

```text
AWVALID = 1
AWREADY = 1
       ↓
AW Handshake

WVALID = 1
WREADY = 1
       ↓
W Handshake

BVALID = 1
BREADY = 1
       ↓
Write Response
```

### UART Transmission

After the AXI write is accepted:

```text
buf_valid
    ↓
uart_tx.valid
    ↓
UART TX start bit
    ↓
8 data bits
    ↓
stop bit
```

The TX signal should return to the idle HIGH state after transmission.

---

## 14. RX Verification

The receive path should show:

```text
UART RX
   ↓
uart_rx
   ↓
data_valid
   ↓
rx_buf_valid
   ↓
AXI read 0x10000004
   ↓
received byte
```

The status register at:

```text
0x10000008
```

indicates whether RX data is available.

---

## 15. Common Issues and Debugging

| Problem | Possible Cause | Debug |
|---------|----------------|-------|
| UART TX does not transmit | AW/W handshake incomplete | Check `AWVALID/AWREADY` and `WVALID/WREADY` |
| TX sends wrong byte | Incorrect WSTRB lane | Check `s_axi_wstrb` |
| AXI write stalls | TX buffer full | Check `buf_valid` and `tx_ready` |
| AWREADY remains LOW | `aw_got` stuck | Check B-channel completion |
| RX data is incorrect | Loopback connection issue | Check UART RX/TX connection |
| Status remains 0 | RX byte not received yet | Allow enough UART transmission time |
| No waveform transitions | Wrong VCD file | Check generated `.vcd` file |
| Yosys naming collision | UART output naming conflict | Use `tx_out` instead of `uart_tx` |

---

## 16. Key Design Considerations

### 1. AXI Handshake

A transfer occurs only when:

```text
VALID && READY = 1
```

at the active clock edge.

### 2. Backpressure

The UART TX buffer can temporarily prevent new AXI writes.

### 3. WSTRB

Byte enables ensure that an 8-bit UART character is extracted correctly from a 32-bit AXI transaction.

### 4. Buffering

The TX buffer prevents data from being lost while the UART transmitter is busy.

### 5. UART Serialization

The parallel AXI data is converted into an 8N1 serial stream by `uart_tx`.

---

## 17. End-to-End Data Path

The complete hardware data path is:

```text
CPU / AXI Master
       |
       | AXI4-Lite Write
       v
AXI Interconnect
       |
       v
uart_axi
       |
       | TX Buffer
       v
uart_tx
       |
       | 8N1 Serial Data
       v
    UART TX
```

Receive direction:

```text
UART RX
   |
   | Serial Data
   v
uart_rx
   |
   | Received Byte
   v
RX Buffer
   |
   | AXI4-Lite Read
   v
uart_axi
   |
   v
AXI Interconnect
   |
   v
CPU / AXI Master
```

---

## 18. What I Learned

This lab demonstrated how a standard peripheral can be integrated into an AXI4-Lite based SoC.

Key concepts learned:

- AXI4-Lite slave design
- AXI write and read channels
- VALID/READY handshaking
- UART TX/RX integration
- Memory-mapped UART registers
- WSTRB byte selection
- TX buffering
- AXI backpressure
- UART 8N1 serialization
- AXI-to-UART and UART-to-AXI data paths
- RTL simulation and waveform-based verification
- Functional verification using Verilator and GTKWave

---

## 19. Conclusion

The AXI4-Lite UART peripheral was successfully implemented and verified.

The testbench executed:

```text
17 tests
17 passed
0 failed
```

The successful transaction demonstrated the complete path:

```text
AXI Write
    ↓
UART AXI Slave
    ↓
TX Buffer
    ↓
UART TX
    ↓
Serial Bitstream
```

and the receive path:

```text
UART RX
    ↓
RX Buffer
    ↓
AXI Read
    ↓
Received Data
```

Therefore, the AXI4-Lite UART peripheral integration is **functionally verified**.
