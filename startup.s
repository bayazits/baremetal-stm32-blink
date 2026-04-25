.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global Reset_Handler
.extern _stack_top
.extern sys_tick_handler

.section .isr_vector
vtable:
    .word _stack_top          /* 0: Initial Stack Pointer */
    .word Reset_Handler       /* 1: Reset Handler */
    .word 0                   /* 2: NMI */
    .word 0                   /* 3: Hard Fault */
    .word 0                   /* 4: MemManage Fault */
    .word 0                   /* 5: Bus Fault */
    .word 0                   /* 6: Usage Fault */
    .word 0                   /* 7: Reserved */
    .word 0                   /* 8: Reserved */
    .word 0                   /* 9: Reserved */
    .word 0                   /* 10: Reserved */
    .word 0                   /* 11: SVCall */
    .word 0                   /* 12: Debug Monitor */
    .word 0                   /* 13: Reserved */
    .word 0                   /* 14: PendSV */
    .word sys_tick_handler    /* 15: SysTick Handler (ÖNEMLİ) */

.section .text
Reset_Handler:
    /* Set the stack pointer (some toolchains need this manually) */
    ldr r0, =_stack_top
    mov sp, r0
    
    /* Jump to main */
    bl main
loop:
    b loop