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

    imx_uart_regs_t *regs = imx_uart_regs_get(base_vaddr);

    /* Software reset */
    regs->cr2 &= ~UART_CR2_SRST;
    while (!(regs->cr2 & UART_CR2_SRST));

    /* Line configuration */
    serial_configure(regs, 115200, 8, PARITY_NONE, 1);

//     /* Enable the UART */
//    regs->cr1 |= UART_CR1_UARTEN;                /* Enable The uart.                  */
//    regs->cr2 |= UART_CR2_RXEN | UART_CR2_TXEN;  /* RX/TX enable                      */
//    regs->cr2 |= UART_CR2_IRTS;                  /* Ignore RTS                        */
//    regs->cr3 |= UART_CR3_RXDMUXDEL;             /* Configure the RX MUX              */
//    /* Initialise the receiver interrupt.                                             */
//    regs->cr1 &= ~UART_CR1_RRDYEN;               /* Disable recv interrupt.           */
//    regs->fcr &= ~UART_FCR_RXTL_MASK;            /* Clear the rx trigger level value. */
//    regs->fcr |= UART_FCR_RXTL(1);               /* Set the rx tigger level to 1.     */
//    regs->cr1 |= UART_CR1_RRDYEN;                /* Enable recv interrupt.            */

    /* Return true for successful initialisation. */
    return true;
}

void uart_put_char(
        uart_t *uart,
        uint8_t ch
) {
    /* Lucy's code. */
//    while (!(*UART_REG(STAT) & STAT_TDRE)) {}
//    *UART_REG(UART_TRANSMIT_OFFSET) = ch;
}

//volatile uint32_t *uart_get_transmit_register(uart_t *uart) {
//    return REG_PTR(
//            uart->base_vaddr,
//            UART_TRANSMIT_OFFSET
//    );
//}
