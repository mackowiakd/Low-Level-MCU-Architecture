# Bare-Metal ATmega2560: Advanced Memory Management & CTC Timers

## Overview
This repository contains a bare-metal Assembly program for the AVR ATmega2560 microcontroller. The project demonstrates low-level memory management, specifically handling 24-bit physical addressing for Flash memory exceeding 64KB, alongside precise hardware timing using interrupts. 

The core task involves copying structured data from Program Memory (ROM/Flash) to Data Memory (SRAM) using a circular buffer, while driving hardware outputs (LEDs) based on strict, non-blocking timing sequences.

## Engineering Highlights
* **Advanced Flash Memory Addressing (>64KB):** Implemented a 24-bit addressing model using the `Z` pointer (`ZH:ZL`) and the `RAMPZ` register to securely access the full 256KB Flash space.
* **Safe Pointer Arithmetic (Zero Flag Fix):** Avoided the use of standard adiw instructions. Instead, implemented manual 16-bit incrementation using subi/sbci. Engineered a robust page-boundary crossing mechanism by monitoring the Zero (Z) flag (rather than the Carry flag) to safely increment RAMPZ strictly when the 16-bit word rolls over (e.g., 0xFFFF -> 0x0000).
* **Data Parity Logic: Utilized a "Dummy Read:** technique with manual pointer increments to securely filter and copy only bytes located at even addresses, preventing pointer misalignment across page boundaries.
* **Circular Buffer Implementation:** Designed a robust SRAM circular buffer that compares full 16-bit physical addresses (YH:YL) rather than relying on simple 8-bit index counters, allowing seamless memory wrap-around.
* **Non-Blocking Interrupt Timers (CTC Mode):** Configured Timer1 in CTC (Clear Timer on Compare) mode with a 64 prescaler to generate strict 10ms hardware interrupts. This allowed for precise 750ms and 500ms delays without freezing the CPU with blocking software loops, simulating RTOS-like task scheduling.
* **Hardware Debouncing:** Implemented software debouncing logic to ensure reliable physical button reads.

## Why Assembly?
Developing this in pure Assembly forced a deep understanding of the AVR ALU, Status Register flags, and physical memory boundaries. This low-level approach directly translates to writing highly optimized, memory-safe C/C++ firmware for constrained embedded systems.