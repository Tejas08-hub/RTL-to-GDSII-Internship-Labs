# Fundamentals of RISC-V ISA — PicoRV32 Instruction Execution

## 1. Overview

This lab introduces the fundamentals of the RISC-V Instruction Set Architecture (ISA) using the PicoRV32 processor.

The standalone PicoRV32 design was simulated using Verilator to observe instruction execution and the processor's native memory interface. GTKWave was used to analyze the memory transactions and processor behavior.

## 2. Objectives

* Understand the basic RV32I RISC-V instruction set architecture.
* Understand the 32 general-purpose registers used by RV32I.
* Understand the basic RISC-V instruction formats.
* Observe PicoRV32 instruction fetching and memory transactions.
* Understand the `mem_valid` / `mem_ready` native memory handshake.
* Analyze PicoRV32 simulation waveforms using GTKWave.
* Verify the expected processor trap behavior.

## 3. PicoRV32 Architecture

PicoRV32 is a small, configurable RISC-V processor core implemented in synthesizable Verilog.

For this standalone simulation, the processor communicates with a simple memory through its native memory interface.

### Native Memory Interface

| Signal      | Direction    | Width | Description                                       |
| ----------- | ------------ | ----: | ------------------------------------------------- |
| `mem_valid` | CPU → Memory |     1 | Indicates that a memory transaction is valid      |
| `mem_instr` | CPU → Memory |     1 | Indicates an instruction fetch                    |
| `mem_ready` | Memory → CPU |     1 | Indicates that the memory transaction is complete |
| `mem_addr`  | CPU → Memory |    32 | Memory address                                    |
| `mem_wdata` | CPU → Memory |    32 | Data written during a store                       |
| `mem_wstrb` | CPU → Memory |     4 | Byte write strobes                                |
| `mem_rdata` | Memory → CPU |    32 | Data returned by memory                           |

The CPU asserts `mem_valid` when it needs to access memory. The memory responds by asserting `mem_ready`. For instruction fetches, `mem_instr` is asserted.

## 4. Instruction Execution

The simulation demonstrates sequential instruction fetching through the PicoRV32 native memory interface.

The observed instruction addresses include:

```text
0x00000000
0x00000004
0x00000008
0x0000000C
0x00000010
```

The address progression demonstrates sequential instruction fetching with 32-bit (4-byte) instructions.

The simulation also includes a memory write transaction:

```text
Address : 0x00000024
Data    : 0x00000007
WSTRB   : 0xF
```

A `WSTRB` value of `0xF` indicates a full 32-bit word write.

## 5. Files

### RTL

* `rtl/picorv32.v` — PicoRV32 processor RTL.
* `rtl/Memory.v` — Memory model used by the standalone simulation.
* `rtl/top.v` — Top-level wrapper connecting PicoRV32 and memory.

### Testbench

* `tb/tb_processor.v` — Verilator testbench used to simulate and verify the PicoRV32 processor.

### Results

* `results/Simulation_Result.png` — Terminal output showing the successful simulation result.
* `results/waveform.png` — GTKWave waveform showing the processor's memory interface activity.

## 6. Simulation

The provided Makefile was used to run the standalone PicoRV32 simulation.

### Command

```bash
make pico
```

The simulation was compiled and executed using Verilator.

The simulation generated the waveform file:

```text
tb_picorv32.vcd
```

GTKWave was then used to inspect the simulation signals.

## 7. Waveform Verification

The following signals were observed in GTKWave:

```text
clk
reset_n
mem_valid
mem_instr
mem_ready
mem_addr[31:0]
mem_rdata[31:0]
mem_wstrb[3:0]
mem_wdata[31:0]
trap
```

### Important Observations

#### Instruction Fetch

When:

```text
mem_valid = 1
mem_instr = 1
```

the processor is performing an instruction fetch.

The `mem_addr` signal progresses through instruction addresses, demonstrating sequential instruction execution.

#### Memory Write

A write transaction was observed with:

```text
mem_valid = 1
mem_instr = 0
mem_wstrb = 4'hF
mem_wdata = 32'h00000007
```

This represents a full 32-bit store operation.

#### Trap

The `trap` signal eventually becomes active. This matches the expected behavior reported by the testbench.

## 8. Simulation Result

The simulation completed successfully.

```text
SIMULATION PASSED — processor trapped as expected
Total cycles run: 39
```

The processor trap occurred at cycle 20 as expected by the testbench.

## 9. Conclusion

This lab provided hands-on exposure to the RISC-V RV32I architecture and PicoRV32 processor execution.

The simulation demonstrated:

* RISC-V instruction fetching.
* Sequential program-counter progression.
* PicoRV32 native memory transactions.
* Instruction and data memory accesses.
* Store operation using byte write strobes.
* `mem_valid` / `mem_ready` handshake behavior.
* Processor trap detection.
* Waveform-based verification using GTKWave.

This lab establishes the foundation for the subsequent RISC-V SoC integration labs involving AXI4-Lite, UART, memory-mapped peripherals, and complete SoC integration.
