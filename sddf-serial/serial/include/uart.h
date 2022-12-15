#pragma once


#include <sel4cp.h>
#include <sel4/sel4.h>
#include <stdlib.h>


#define UART_BASE 0x5000000 //0x30890000 in hardware on imx8mm.
#define UART_REG(x) ((volatile uint32_t *)(UART_BASE + (x)))
#define STAT 0x98
#define STAT_TDRE (1 << 14)
//
//#define BIT(n) (1ul<<(n))
//
//#define UINTP       0x0030 /* interrupt pending */
//#define UINTSP      0x0034 /* interrupt source pending */
//#define UINTM       0x0038 /* interrupt mask *//* INTP, INTSP, INTM */
//
//#define INT_MODEM BIT(3)
//#define INT_TX    BIT(2)
//#define INT_ERR   BIT(1)
//#define INT_RX    BIT(0)
//
//#define REG_PTR(base, offset) ((volatile uint32_t *)((base) + (offset)))

//#define REG_PTR(base, offset) ((volatile uint32_t *)((base) + (offset)))
#define UART_TRANSMIT_OFFSET 0x40

typedef struct uart uart_t;
struct uart {
    /* The virtual address of the uart's register. */
    uintptr_t base_vaddr;
};

/**
 * Initialises UART device.
 * @param uart
 * @param base_vaddr
 * @return True if successful and false otherwise.
 */
bool uart_init(
        uart_t *uart,
        uintptr_t base_vaddr
);

/**
 * Sends a character to UART device.
 * @param uart
 * @param ch
 */
void uart_put_char(
        uart_t *uart,
        uint8_t ch
);

///**
// * Returns the transmit register.
// * @param uart
// * @return
// */
//volatile uint32_t *uart_get_transmit_register(uart_t *uart);


