#include "uart.h"

bool uart_init(
        uart_t *uart,
        uintptr_t base_vaddr
) {
    if (uart == NULL) {
        return false;
    }
    /* Save `base_vaddr`. */
    uart->base_vaddr = base_vaddr;
    /* Return true for successfuly initialisation. */
    return true;
}

void uart_put_char(uint8_t ch) {
    while (!(*UART_REG(STAT) & STAT_TDRE)) {}
    *UART_REG(TRANSMIT) = ch;
}


