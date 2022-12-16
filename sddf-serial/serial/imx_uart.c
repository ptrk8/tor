#include "imx_uart.h"


bool imx_uart_init(
        imx_uart_t *imx_uart,
        uintptr_t base_vaddr
) {
    if (imx_uart == NULL) {
        return false;
    }
    /* Save pointer to the registers. */
    imx_uart->regs = imx_uart_regs_init(base_vaddr);

    /* Software reset */
    imx_uart->regs->cr2 &= ~UART_CR2_SRST;
    while (!(imx_uart->regs->cr2 & UART_CR2_SRST));

    /* Line configuration */
    serial_configure(imx_uart->regs, 115200, 8, PARITY_NONE, 1);

     /* Enable the UART */
    imx_uart->regs->cr1 |= UART_CR1_UARTEN;                /* Enable The uart.                  */
    imx_uart->regs->cr2 |= UART_CR2_RXEN | UART_CR2_TXEN;  /* RX/TX enable                      */
    imx_uart->regs->cr2 |= UART_CR2_IRTS;                  /* Ignore RTS                        */
    imx_uart->regs->cr3 |= UART_CR3_RXDMUXDEL;             /* Configure the RX MUX              */
    /* Initialise the receiver interrupt.                                             */
    imx_uart->regs->cr1 &= ~UART_CR1_RRDYEN;               /* Disable recv interrupt.           */
    imx_uart->regs->fcr &= ~UART_FCR_RXTL_MASK;            /* Clear the rx trigger level value. */
    imx_uart->regs->fcr |= UART_FCR_RXTL(1);               /* Set the rx tigger level to 1.     */
    imx_uart->regs->cr1 |= UART_CR1_RRDYEN;                /* Enable recv interrupt.            */

    /* Return true for successful initialisation. */
    return true;
}




