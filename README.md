STM32F4 Bare-Metal Tick-Timer & GPIO Simulation (Renode)
This project demonstrates a professional Bare-Metal embedded software development workflow. It focuses on hardware timers, interrupt handling, and low-level register manipulation on an ARM Cortex-M4 (STM32F4 Discovery) MCU, all within the Renode simulation environment.

🚀 Overview
The goal is to toggle a GPIO pin (onboard LED) using the SysTick Timer interrupt without using any high-level libraries (No HAL, No LL). The project uses a remote Linux environment for compilation and simulation.
Target: STM32F4 Discovery (Cortex-M4)
Toolchain: arm-none-eabi-gcc, GNU Make
Simulation: Renode
Key Concepts: Linker Scripts, Startup Assembly, Vector Tables, Memory-Mapped I/O.

🛠️ Project Structure
main.c: Core logic, RCC clock configuration, and SysTick ISR.
startup.s: Full vector table (15+ slots) and reset handler.
linker.ld: Custom memory map (Flash/RAM) and stack definitions.
Makefile: Optimized build system with obj/ and bin/ separation.
run.resc: Renode script for platform setup and ELF loading.

⚙️ Hardware Configuration (Register Level)
RCC_AHB1ENR: Peripheral clock gating for GPIOD.
GPIOD_MODER: Configures Pin 12 as a General Purpose Output.
SysTick (STK): Set for periodic interrupts (Interrupt priority #15 in Vector Table).

📥 Build & Run
Compile the project:
make

Launch Simulation (Headless):
renode --disable-gui --plain run.resc

🔍 Verification & Debugging (Telnet)
Since the simulation runs on a remote server, verification is performed via the Renode Monitor (Telnet). This allows real-time inspection of the virtual hardware state.

Connect to Monitor:
telnet localhost 1234

Critical Verification Commands:
Check Program Counter (PC): Ensure the CPU is not stuck at 0x0.
(machine-0) sysbus.cpu PC
# Expected: 0x0800XXXX (Code address)

Inspect GPIO State: Read the Output Data Register (ODR) to verify the toggle.
(machine-0) sysbus ReadDoubleWord 0x40020C14
# Values will alternate between 0x00001000 (LED ON) and 0x00000000 (LED OFF)

Monitor Virtual Time:
(machine-0) emulation GetTimeSourceInfo

## 🧪 Live Verification Example
During simulation, the following values were captured via Telnet Monitor, proving the SysTick ISR is correctly toggling the GPIO:


| Command | Output | State |
|---------|--------|-------|
| `sysbus ReadDoubleWord 0x40020C14` | `0x00000000` | LED OFF |
| `sysbus ReadDoubleWord 0x40020C14` | `0x00001000` | LED ON |

🎯 Key Learning Outcomes
Successfully implemented a full vector table for Cortex-M.
Managed slower-than-real-time simulation timing.
Verified hardware logic using memory-mapped I/O inspection.
Established a remote-SSH development environment for embedded systems.