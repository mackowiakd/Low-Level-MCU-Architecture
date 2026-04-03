# Bare-Metal PIC18F45K22: Interrupt-Driven Hardware Multiplexer

![Microcontroller](https://img.shields.io/badge/Microcontroller-PIC18F45K22-blue)
![Language](https://img.shields.io/badge/Language-Assembly-red)
![Architecture](https://img.shields.io/badge/Architecture-8--bit-green)

## Overview
This repository showcases a bare-metal Assembly program for the PIC18F45K22 microcontroller. The project controls a multiplexed 7-segment display purely through hardware interrupts, executing an automated segment animation sequence. 

By offloading the timing and display logic to independent hardware timers, the main CPU loop remains completely unblocked and available for other tasks—a fundamental concept for RTOS and responsive embedded systems.

> **Note:** [Insert a GIF or image of your working EasyPIC v7 board here]

## Hardware & Toolchain
* **Development Board:** MikroElektronika EasyPIC v7
* **Microcontroller:** PIC18F45K22 (8-bit)
* **Assembler:** MPASM
* **Programmer:** mikroProg Suite for PIC

## Engineering Highlights

* **Finite State Machines (FSM):** Implemented dual concurrent state machines (`FAZA` and `DISP_FLAG`) to manage animation frames and digit multiplexing without mutual interference.
* **Harvard Architecture & Memory Banking:** Managed strict separation between Flash program memory (`.ORG`) and SRAM data memory (`.CBLOCK`). Handled PIC-specific memory banking, actively switching between the Access Bank (for rapid variable access) and the Bank Select Register (BSR) to configure Special Function Registers (SFRs) like `ANSELx`.
* **Dual Independent Hardware Timers:**
  * **Timer0 (Fast Interrupts - 1:2 Prescaler):** Configured to generate frequent, high-speed interrupts responsible for multiplexing the display. This leverages human eye persistence to create the illusion of simultaneous illumination across digits.
  * **Timer1 (Slow Interrupts - 1:8 Prescaler):** Calculated precise hardware reload values (`65536 - 15625 = 49911`) to trigger animation state changes exactly every 0.5 seconds.
* **Zero Software Blocking Delays:** Eliminated all software `_delay()` loops. The system relies entirely on the Interrupt Service Routine (ISR) dispatcher, which checks the source flags (`TMR0IF`, `TMR1IF`) and triggers the appropriate context logic.
* **Direct Hardware Configuration:** Handled low-level MCU initialization, including configuring the internal oscillator and disabling the Watchdog Timer directly via `CONFIG` bits.

## Configuration Bits Setup
When flashing this code, ensure the following configuration bits are strictly set (especially if your programmer overrides the HEX configuration words):
* **Oscillator:** Internal RC oscillator
* **Watchdog Timer (WDT):** Disabled
* **MCLR Enable Bit:** Disabled (Internal Reset)
* **Low Voltage Programming (LVP):** Disabled

*(See `images/programmer_config.jpg` for mikroProg Suite setup).*

## Technical Focus & Learning Outcomes
This project serves as a practical demonstration of handling concurrent hardware peripherals. Operating multiple timers and managing an ISR dispatcher in Assembly builds the exact architectural foundation required to understand RTOS context switching, thread management, and bare-metal C driver development.