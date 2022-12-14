#pragma once


#include <sel4cp.h>
#include <sel4/sel4.h>
#include <stdlib.h>


#define UART_BASE 0x5000000 //0x30890000 in hardware on imx8mm.
#define UART_REG(x) ((volatile uint32_t *)(UART_BASE + (x)))
#define STAT 0x98
#define STAT_TDRE (1 << 14)
#define TRANSMIT 0x40

typedef struct uart uart_t;
struct uart {
    /* The virtual address of the uart's register. */
    uintptr_t base_vaddr;
};

/**
 * Initialises UART.
 * @param uart
 * @param base_vaddr
 * @return True if successful and false otherwise.
 */
bool uart_init(
        uart_t *uart,
        uintptr_t base_vaddr
);

void uart_put_char(uint8_t ch);




