# Bare-Metal Microcontroller Architecture ⚙️

## Overview
This repository serves as a portfolio of low-level, bare-metal programming across different 8-bit microcontroller architectures (AVR and PIC). All projects are written entirely in **Assembly language** to demonstrate a foundational understanding of hardware-software interfaces, memory boundaries, and hardware interrupts.

While modern embedded development is primarily done in C/C++ or using RTOS (like Zephyr or FreeRTOS), I believe that deeply understanding the underlying CPU architecture—how the stack works, how interrupts hijack the program counter, and how memory paging operates—is crucial for writing safe, optimized, and highly reliable high-level code.

## Repository Structure

This repository is divided into two distinct architectural explorations:

### 1. [ATmega2560: Memory Management & CTC Timers](./ATmega2560-BareMetal-Memory-Timers)
* **Focus:** 24-bit physical memory addressing, page boundary crossing, and non-blocking delays.
* **Key Achievements:** * Safely navigated Flash memory exceeding 64KB using manual manipulation of the `RAMPZ` register and the `Z` pointer.
  * Replaced blocking software delays with precise 10ms hardware interrupts using Timer1 in CTC mode.

### 2. [PIC18F45K22: Interrupt-Driven Hardware Multiplexer](./PIC18-BareMetal-Interrupt-Multiplexer)
* **Focus:** Harvard architecture, Memory Banking (BSR), and concurrent peripheral management.
* **Key Achievements:**
  * Driven a 4-digit 7-segment display entirely via background interrupts (Timer0 and Timer1), leaving the main CPU loop completely empty.
  * Demonstrated core RTOS concepts: context switching, non-blocking execution, and hardware-level state machines.

## Key Skills Demonstrated
* **Microcontroller Architectures:** AVR (ATmega2560) and PIC (PIC18F45K22).
* **Memory Management:** Direct manipulation of SRAM, Flash/ROM, and Special Function Registers (SFRs).
* **Interrupts & Timers:** Interrupt Service Routines (ISRs), CTC Mode, Prescalers, and Context Saving.
* **Non-Blocking Logic:** Designing systems that react to hardware events rather than being trapped in polling loops.
