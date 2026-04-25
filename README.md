# STM32F4 Bare-Metal Tick-Timer & GPIO Simulation
This project demonstrates a professional **Bare-Metal** embedded software development workflow. It focuses on hardware timers, interrupt handling, and low-level register manipulation on an ARM Cortex-M4 (STM32F4 Discovery) MCU, all within the **Renode** simulation environment.

## 🚀 Overview
The goal is to toggle a GPIO pin (onboard LED) using the **SysTick Timer** interrupt without using any high-level libraries (No HAL, No LL). 

- **Target Hardware:** STM32F4 Discovery (Cortex-M4)
- **Environment:** Remote Linux Server (VS Code Remote-SSH)
- **Key Concepts:** Linker Scripts, Startup Assembly, Vector Tables, Memory-Mapped I/O.

---

## 🛠️ Project Structure

| File | Description |
| :--- | :--- |
| `main.c` | Core logic, RCC clock configuration, and SysTick ISR. |
| `startup.s` | Full vector table (15+ slots) and reset handler. |
| `linker.ld` | Custom memory map (Flash/RAM) and stack definitions. |
| `Makefile` | Optimized build system with `obj/` and `bin/` separation. |
| `run.resc` | Renode script for platform setup and ELF loading. |

---

## ⚙️ Hardware Configuration (Register Level)
- **RCC_AHB1ENR**: Peripheral clock gating for GPIOD.
- **GPIOD_MODER**: Configures Pin 12 as a General Purpose Output.
- **SysTick (STK)**: Set for periodic interrupts (Interrupt priority #15 in Vector Table).

---

## 📥 Build & Run

### 1. Compilation
Use the provided Makefile to compile the firmware:
```bash
make
```

### 2. Launch Simulation
Run Renode in headless mode to start the simulation:
```bash
renode --disable-gui --plain run.resc
```

---

## 🔍 Verification & Debugging (Telnet)
Since the simulation runs on a remote server, verification is performed via the **Renode Monitor (Telnet)**.

### Connect to Monitor
```bash
telnet localhost 1234
```

### Critical Verification Commands

#### A. Check Program Counter (PC)
Ensure the CPU is not stuck at `0x0`:
```bash
(machine-0) sysbus.cpu PC
# Expected: 0x0800XXXX (Code entry point)
```

#### B. Inspect GPIO State
Read the **Output Data Register (ODR)** to verify the toggle:
```bash
(machine-0) sysbus ReadDoubleWord 0x40020C14
```

#### 🧪 Live Verification Results

| Command | Output | State |
| :--- | :--- | :--- |
| `sysbus ReadDoubleWord 0x40020C14` | `0x00000000` | **LED OFF** |
| `sysbus ReadDoubleWord 0x40020C14` | `0x00001000` | **LED ON** |

---

## 🎯 Key Learning Outcomes
- [x] Successfully implemented a **full vector table** for Cortex-M.
- [x] Managed **virtual vs host time** synchronization in simulation.
- [x] Verified hardware logic using **memory-mapped I/O** inspection.
- [x] Established a robust **Remote-SSH development environment**.
