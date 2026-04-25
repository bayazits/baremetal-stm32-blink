#include <stdint.h>

/* Peripheral Base Addresses */
#define RCC_AHB1ENR   (*(volatile uint32_t*)(0x40023830))
#define GPIOD_MODER   (*(volatile uint32_t*)(0x40020C00))
#define GPIOD_ODR     (*(volatile uint32_t*)(0x40020C14))

/* SysTick Register Addresses (Cortex-M Private Peripheral) */
#define STK_CTRL      (*(volatile uint32_t*)(0xE000E010))
#define STK_LOAD      (*(volatile uint32_t*)(0xE000E014))
#define STK_VAL       (*(volatile uint32_t*)(0xE000E018))

/* Interrupt Service Routine for SysTick */
void sys_tick_handler(void) {
    /* Toggle GPIOD Pin 12 (Onboard Green LED) */
    GPIOD_ODR ^= (1 << 12);
}

int main(void) {
    /* 1. Enable Clock for GPIOD (Bit 3 in AHB1ENR) */
    RCC_AHB1ENR |= (1 << 3);

    /* 2. Configure Pin 12 as Output (Bits 25:24 in MODER) */
    GPIOD_MODER &= ~(3 << 24); /* Clear mode bits */
    GPIOD_MODER |= (1 << 24);  /* Set to General Purpose Output */

    /* 3. Configure SysTick for 1 second intervals */
    /* Assuming 16MHz internal clock */
    STK_LOAD = 100000 - 1; 
    STK_VAL = 0;               /* Clear current value */
    STK_CTRL = 0x07;           /* Enable SysTick, Enable Interrupt, Use Processor Clock */

    while(1) {
        /* Wait For Interrupt (Save power while idling) */
        __asm__("wfi");
    }
}
