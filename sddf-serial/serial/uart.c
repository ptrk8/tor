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

    /* Enable RX IRQ */
//    *REG_PTR(uart->base_vaddr, UINTM) = ~INT_RX;
//    *REG_PTR(uart->base_vaddr, UINTP) = INT_RX | INT_TX | INT_ERR | INT_MODEM;

    /* Return true for successful initialisation. */
    return true;
}

void uart_put_char(
        uart_t *uart,
        uint8_t ch
) {
    while (!(*UART_REG(STAT) & STAT_TDRE)) {}
    *UART_REG(UART_TRANSMIT_OFFSET) = ch;
}

//volatile uint32_t *uart_get_transmit_register(uart_t *uart) {
//    return REG_PTR(
//            uart->base_vaddr,
//            UART_TRANSMIT_OFFSET
//    );
//}
