# Lab 4 — Memory-Mapped Interface (MMI) with UART

## Course
**PicoRV32 SoC Subsystem with AXI-Lite & UART Integration**

---

## 1. Title

**Memory-Mapped Interface (MMI) — Connecting PicoRV32 to UART Without AXI**

---

## 2. Objective

The objective of this lab is to understand how a RISC-V processor communicates with a peripheral using a direct memory-mapped interface without using AXI-Lite.

By completing this lab, the following concepts were studied:

- Memory-Mapped I/O (MMIO)
- PicoRV32 native memory interface
- CPU memory read/write transactions
- Address decoding
- UART register mapping
- Firmware-driven peripheral access
- UART status polling
- CPU-to-UART communication
- UART echo operation
- Verification using Verilator and GTKWave

---

## 3. Theory

### 3.1 Memory-Mapped I/O

Memory-Mapped I/O allows peripherals to appear as normal memory locations in the processor address space.

Instead of using special instructions to communicate with UART, the CPU performs normal load and store operations to predefined addresses.

For example:

| Address | Register | Operation |
|---|---|---|
| `0x10000000` | UART_TX | Write a byte to transmit |
| `0x10000004` | UART_RX | Read received byte |
| `0x10000008` | UART_STATUS | Read UART status |

The CPU does not need to know that these addresses belong to a UART. It simply performs a normal memory access.

---

### 3.2 PicoRV32 Native Memory Interface

PicoRV32 generates a memory request using signals such as:

- `mem_valid`
- `mem_ready`
- `mem_addr`
- `mem_wdata`
- `mem_wstrb`
- `mem_rdata`

For a UART write, the CPU generates a transaction such as:

```text
mem_valid = 1
mem_addr  = 0x10000000
mem_wstrb  = 4'b0001
mem_wdata  = transmitted byte
```

The address decoder detects the UART address and routes the transaction to the UART peripheral.

---

## 4. UART Memory Map

The UART peripheral is mapped into the processor address space as follows:

| Address | Register | Description |
|---|---|---|
| `0x10000000` | UART_TX | Write byte to transmit |
| `0x10000004` | UART_RX | Read received byte |
| `0x10000008` | UART_STATUS | UART status / RX ready |

The firmware accesses these registers using volatile pointers:

```c
#define UART_TX     (*(volatile char*)0x10000000)
#define UART_RX     (*(volatile char*)0x10000004)
#define UART_STATUS (*(volatile int*)0x10000008)
```

The `volatile` keyword ensures that the compiler does not optimize away hardware register accesses.

---

## 5. System Memory Map

| Address Range | Peripheral | Interface |
|---|---|---|
| `0x0000_0000 – 0x0000_7FFF` | ROM | Native memory bus |
| `0x0001_0000 – 0x0001_FFFF` | SRAM | Native memory bus |
| `0x1000_0000 – 0x1000_000F` | UART | Native memory bus |

---

## 6. Architecture

The basic architecture is:

```text
                 +----------------+
                 |    PicoRV32    |
                 |      CPU       |
                 +-------+--------+
                         |
                 Native Memory Bus
                         |
              +----------+----------+
              |   Address Decoder   |
              +----+-----------+----+
                   |           |
                  ROM         SRAM
                              
                   |
                   v
             +-----------+
             |    UART   |
             | Peripheral|
             +-----+-----+
                   |
                  TX/RX
```

Unlike the AXI-Lite lab, this design uses the PicoRV32 native memory interface directly.

---

## 7. CPU-to-UART Communication

When firmware executes:

```c
UART_TX = 'H';
```

the following sequence occurs:

```text
Firmware
   |
   v
Store instruction
   |
   v
PicoRV32 mem_valid = 1
mem_addr = 0x10000000
mem_wstrb = 4'b0001
mem_wdata = 0x48
   |
   v
Address Decoder
   |
   v
UART selected
   |
   v
UART TX triggered
   |
   v
Serial transmission
```

Therefore, a normal CPU memory write becomes a UART transmission.

---

## 8. Firmware

The firmware contains UART transmit and receive functions.

### UART Transmit

```c
static void uart_putc(char c) {
    UART_TX = c;
}
```

### UART String Transmission

```c
static void uart_puts(const char *s) {
    while (*s)
        uart_putc(*s++);
}
```

### UART Receive

```c
static char uart_getc(void) {
    while (!(UART_STATUS & 0x2));
    return UART_RX;
}
```

The receiver continuously checks the status register until the RX-ready bit becomes active.

The firmware also implements an echo loop:

```c
while (1)
    uart_putc(uart_getc());
```

---

## 9. Files Used

```text
04_Memory-Mapped Interface with UART/
├── README.md
├── rtl/
│   ├── top.v
│   ├── uart_mem.v
│   ├── mem_rom.v
│   └── mem_sram.v
├── fw/
│   ├── main.c
│   ├── crt0.S
│   └── link.ld
├── tb/
│   └── tb_mem_soc.v
└── results/
    ├── Simulation_Result.png
    └── waveform.png
```

### File Roles

| File | Role |
|---|---|
| `rtl/top.v` | Top-level MMI SoC |
| `rtl/uart_mem.v` | Memory-mapped UART peripheral |
| `rtl/mem_rom.v` | ROM memory interface |
| `rtl/mem_sram.v` | SRAM memory interface |
| `fw/main.c` | UART firmware |
| `fw/crt0.S` | Startup code |
| `fw/link.ld` | Linker script |
| `tb/tb_mem_soc.v` | SoC simulation testbench |
| `results/Simulation_Result.png` | Simulation output |
| `results/waveform.png` | GTKWave waveform |

---

## 10. Simulation

The complete MMI SoC was simulated using **Verilator**.

The simulation verifies:

1. CPU instruction execution
2. Memory-mapped UART writes
3. UART serial transmission
4. UART monitor reception
5. Repeated greeting messages
6. UART receive operation
7. PING command
8. Echo functionality

---

## 11. Simulation Result

The simulation successfully produced:

```text
[TB] Greeting message count = 10

10 GREETING MESSAGES RECEIVED
UART OUTPUT VERIFIED

[TB] FIFO flushed - sending command : PING

[TB] RX byte: P
[TB] RX byte: I
[TB] RX byte: N
[TB] RX byte: G

TEST PASSED
Echo received : PING
```

### Final Verification

```text
Greeting messages received = 10
UART output verification   = PASS
PING echo                  = PASS
Overall simulation         = TEST PASSED
```

The complete simulation result is saved in:

```text
results/Simulation_Result.png
```

---

## 12. Waveform Verification

The GTKWave waveform was used to observe the CPU-to-UART memory-mapped transaction.

### Important Signals

```text
clk
reset
cpu_mem_valid
cpu_mem_ready
cpu_mem_instr
cpu_mem_addr[31:0]
cpu_mem_wstrb[3:0]
cpu_mem_wdata[31:0]
cpu_mem_rdata[31:0]
uart_sel
uart_mem.tx_valid
uart_mem.tx_data
uart_mem.rx_data_valid
uart_mem.rx_data
uart_tx
```

### Important Observation

During a UART transmit operation, the waveform should show:

```text
cpu_mem_valid = 1
cpu_mem_addr  = 0x10000000
cpu_mem_wstrb = 0001
cpu_mem_wdata = UART data
uart_sel      = 1
uart_mem.tx_valid = 1
```

This demonstrates that the CPU is accessing the UART through a normal memory transaction.

The resulting UART TX signal then produces the serial bitstream.

The waveform screenshot is saved in:

```text
results/waveform.png
```

---

## 13. Verification Flow

```text
RISC-V Firmware
       |
       v
PicoRV32 CPU
       |
       v
Native Memory Interface
       |
       v
Address Decoder
       |
       +--------> ROM
       |
       +--------> SRAM
       |
       +--------> UART
                    |
                    v
                 UART TX
                    |
                    v
              Testbench Monitor
```

For received data:

```text
External/Testbench UART RX
          |
          v
      UART Peripheral
          |
          v
      RX Data Register
          |
          v
      PicoRV32 CPU
          |
          v
      Firmware
          |
          v
       UART TX
```

---

## 14. Common Debugging Points

### UART output is missing

Check:

- Firmware is correctly compiled.
- ROM contains the generated firmware.
- CPU reaches the UART transmit function.
- UART address decoding is correct.
- UART TX address is `0x10000000`.

### Status polling hangs

Check:

- UART status register address.
- RX-ready bit mapping.
- RX valid signal.
- UART RX data register.

### Echo data is incorrect

Check:

- RX register contents.
- RX valid flag.
- Firmware polling logic.
- UART RX-to-TX path.

### Simulation timeout

Check:

- CPU memory handshake.
- ROM initialization.
- Linker script.
- Firmware execution.
- UART status polling loop.

---

## 15. Key Concepts Learned

| Concept | Key Point |
|---|---|
| MMIO | Peripherals are accessed using memory addresses |
| Native memory bus | PicoRV32 communicates directly without AXI |
| Address decoding | Determines which peripheral receives a transaction |
| UART_TX | Writing to `0x10000000` transmits a byte |
| UART_RX | Reading `0x10000004` returns received data |
| UART_STATUS | Used to check RX availability |
| `volatile` | Prevents compiler optimization of hardware accesses |
| Polling | Firmware waits for RX-ready status |
| Echo | Received data is transmitted back |
| Verification | CPU ↔ UART communication verified in simulation |

---

## 16. Conclusion

This lab demonstrated how a RISC-V processor can communicate with a UART peripheral using a direct Memory-Mapped Interface without AXI-Lite.

The PicoRV32 generates normal memory transactions, while address decoding identifies UART registers and converts memory accesses into UART operations.

The simulation successfully verified:

- 10 UART greeting messages
- UART output
- PING reception
- PING echo
- CPU-to-UART memory-mapped communication

**Final Result: TEST PASSED**
