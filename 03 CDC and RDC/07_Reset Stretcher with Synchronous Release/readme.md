# Reset Synchronization Logic

## Overview
This lab demonstrates a **reset stretcher / reset synchronization circuit** used to safely handle reset release in synchronous digital systems. In digital designs, reset is required to force flip-flops, counters, and registers into a known state during startup or fault recovery. While asserting reset asynchronously is useful because it takes effect immediately, releasing reset asynchronously can be unsafe because it may occur close to a clock edge and cause metastability or inconsistent startup across different parts of the circuit.

To solve this, the design in this lab uses an **asynchronous-assert, synchronous-deassert reset strategy**. The external reset is asserted immediately whenever needed, but its release is delayed and aligned to the clock using a small reset hold mechanism. This generates a clean synchronized reset signal for the rest of the circuit and ensures reliable startup behavior.

The lab contains:
- a **reset stretcher module** that holds reset active for two extra clock cycles after release,
- a **top module** that uses the stretched reset to control an 8-bit counter,
- and a **testbench** that applies reset at arbitrary times to verify immediate reset assertion and delayed synchronized release.

---

## Objective
The objective of this lab is to understand how reset can be safely released in a synchronous digital design. The circuit demonstrates how asynchronous reset assertion can be combined with synchronous delayed deassertion so that all sequential logic exits reset in a controlled and predictable manner.

By completing this lab, the following concepts can be understood clearly:
- why asynchronous reset deassertion is unsafe,
- how a reset stretcher improves startup reliability,
- how reset can be held for a fixed number of cycles after external release,
- and how sequential logic such as counters can be protected from unsafe reset removal.

---

## Design Description

### 1. Reset Stretcher (`reset_stretch.v`)
This module implements the main reset synchronization logic. It accepts:
- `clk` → system clock  
- `arst_n` → asynchronous active-low reset input  

and produces:
- `srst_n` → synchronized active-low reset output  

The module asserts reset immediately whenever `arst_n` becomes low. When `arst_n` returns high, reset is not removed immediately. Instead, the circuit keeps reset active for **two additional clock cycles** before releasing it on a clock edge. This creates a clean reset output that is safe for synchronous logic.

The stretcher uses two internal signals:
- **`hold`** → indicates whether reset must still remain active
- **`hold_cnt`** → counts the number of clock cycles during the reset hold period

As long as `hold = 1`, the synchronized reset remains active. Once the hold counter completes its delay, `hold` is cleared and reset is released.

---

### 2. Top Module (`reset_top.v`)
The top module instantiates the reset stretcher and connects it to an **8-bit counter**.

The counter uses the synchronized reset signal `srst_n` instead of the raw asynchronous reset. This means the counter remains in reset while the stretcher is holding reset active, even if the external asynchronous reset has already been released.

The behavior is simple:
- while `srst_n = 0`, the counter remains at `0`
- when `srst_n = 1`, the counter starts incrementing on each clock edge

This makes the counter a convenient way to observe the effect of reset stretching in simulation.

---

### 3. Testbench (`reset_top_tb.v`)
The testbench generates the system clock and applies asynchronous reset pulses at arbitrary times. The reset is intentionally asserted and deasserted off-cycle so that the difference between raw asynchronous reset and synchronized reset can be observed clearly in the waveform.

The testbench verifies three important behaviors:
1. **Immediate asynchronous reset assertion**
2. **Delayed synchronous reset release**
3. **Counter starting only after reset is safely released**

Waveforms are dumped to a VCD file and viewed in GTKWave for analysis.

---

## Working Principle

### Asynchronous Reset Assertion
The reset stretcher is sensitive to the **falling edge of `arst_n`**. This means that whenever `arst_n` becomes `0`, the reset is asserted immediately without waiting for the clock. At that moment:
- the internal hold flag is set
- the hold counter is cleared
- the synchronized reset output becomes active

This ensures that the circuit enters reset immediately when required.

---

### Synchronous Reset Deassertion
When `arst_n` returns high, the reset stretcher does **not** release reset immediately. Instead, the hold logic keeps reset active for a fixed number of clock cycles. The internal counter increments on each rising edge of the clock until the programmed delay is completed.

Only after this delay:
- the hold signal is cleared
- the synchronized reset output `srst_n` goes high
- the counter is allowed to begin operation

This guarantees that reset is removed only in sync with the clock and not at an arbitrary time.

---

## Important Logic in the Design

### Hold Counter
The hold counter is used to keep reset active for a short time after the external reset is released. This extra delay gives the system time to stabilize before normal operation begins.

When `arst_n` is low:
- `hold` is set to `1`
- `hold_cnt` is reset to `0`

When `arst_n` goes high:
- `hold_cnt` increments on each clock edge
- once the target count is reached, `hold` is cleared

---

### Reset Output Logic
The synchronized reset is generated using the hold signal:

```verilog
assign srst_n = ~hold;
```

This is the most important line in the reset stretcher.

It means:
- if `hold = 1`, then `srst_n = 0` → reset remains active
- if `hold = 0`, then `srst_n = 1` → reset is released

So the internal hold signal directly controls whether the system should remain in reset or start normal operation.

---

## Counter Operation
The top module contains an 8-bit counter driven by the synchronized reset. Its behavior is:

- if `srst_n = 0` → counter is reset to `8'h00`
- if `srst_n = 1` → counter increments on each rising edge of the clock

This allows the reset behavior to be seen very clearly:
- while reset is active, the counter is held at zero
- after reset is released, the counter begins counting

---

## Expected Waveform Behavior

When the design is simulated and viewed in GTKWave, the following sequence should be observed:

### 1. `arst_n` Assertion
When the asynchronous reset input goes low:
- `srst_n` should go low immediately
- the counter should return to zero immediately

### 2. `arst_n` Release
When the asynchronous reset input returns high:
- `srst_n` should **not** go high immediately
- it should remain low for **two more clock cycles**
- after those two cycles, `srst_n` should go high on a clock edge

### 3. Counter Start
The counter should remain at `0` while `srst_n = 0`. Once `srst_n` becomes `1`, the counter should begin incrementing with the clock.

This confirms that the design implements **asynchronous reset assertion** and **synchronous delayed reset release** correctly.

---

## Why This Lab Is Important
Reset handling is a critical topic in FPGA and ASIC design. Even if the functional logic of a circuit is correct, poor reset design can cause startup failures, metastability, or inconsistent state initialization.

A reset stretcher is useful because it:
- ensures reset is asserted immediately when needed
- prevents unsafe asynchronous reset deassertion
- guarantees that all sequential logic exits reset together
- improves startup reliability by delaying reset release until the clock domain is stable

This makes the technique highly relevant in real digital systems, especially when external reset sources are asynchronous to the system clock.

---

## Key Learnings
- **Asynchronous reset assertion** is useful because it allows the system to enter reset immediately.
- **Asynchronous reset deassertion** is unsafe because it may release reset near a clock edge.
- **Synchronous reset release** ensures that reset is removed only on a clock edge.
- **Reset stretching** keeps reset active for a small number of additional clock cycles after external reset release.
- Proper reset synchronization prevents metastability and makes startup behavior predictable.
- Even a simple counter example clearly demonstrates why reset release timing is important in synchronous digital design.

---

## Conclusion
This lab demonstrates a fundamental reset handling technique used in digital systems. By combining **immediate asynchronous reset assertion** with **delayed synchronous reset release**, the circuit ensures that the system enters reset quickly but leaves reset safely and predictably.

The reset stretcher acts as a protective interface between the external asynchronous reset source and the internal sequential logic. Although the design here is small and uses only an 8-bit counter, the same principle is widely used in real FPGA and ASIC systems to improve reset reliability, avoid metastability, and guarantee a clean startup sequence.
