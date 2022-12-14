#pragma once


#include <sel4cp.h>
#include <sel4/sel4.h>


#define UART_REG(x) ((volatile uint32_t *)(UART_BASE + (x)))
#define UART_BASE 0x5000000 //0x30890000 in hardware on imx8mm.
#define STAT 0x98
#define STAT_TDRE (1 << 14)
#define TRANSMIT 0x40

/* This will be automatically populated by the seL4CP tool. */

void uart_put_char(uint8_t ch);
