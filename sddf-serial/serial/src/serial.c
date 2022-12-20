#include "serial.h"

/* This will be automatically populated with the Virtual Address that
 * corresponds to the Physical Address of the UART device by the seL4CP tool. */
uintptr_t uart_base_vaddr;

/* Global UART device. */
imx_uart_t imx_uart = {};

void serial_write(const char *str) {
    while (*str) {
//        uart_put_char(&uart, *str);
        str++;
    }
}

void init(void) {
    sel4cp_dbg_puts("\n=== START ===\n");
    sel4cp_dbg_puts("Initialising UART device...\n");

    bool is_success = imx_uart_init(
            &imx_uart,
            uart_base_vaddr,
            true
    );
    if (is_success) {
        sel4cp_dbg_puts("UART device initialisation SUCCESS.\n");
    }
    while (imx_uart_put_char(&imx_uart, '\n') == -1);
    for (int i = 0; i < 5; i++) {
        while (imx_uart_put_char(&imx_uart, 'a') == -1);
        while (imx_uart_put_char(&imx_uart, 'b') == -1);
        while (imx_uart_put_char(&imx_uart, 'c') == -1);
    }
    while (imx_uart_put_char(&imx_uart, '\n') == -1);
    sel4cp_dbg_puts("Ending UART test...\n");
    sel4cp_dbg_puts("=== END ===\n");
}

seL4_MessageInfo_t protected(sel4cp_channel ch, sel4cp_msginfo msginfo) {
    return sel4cp_msginfo_new(0, 0);
}

void notified(sel4cp_channel channel) {
//    switch(channel) {
//        case IRQ_CH:
////            signal_msg = seL4_MessageInfo_new(IRQAckIRQ, 0, 0, 0);
////            signal = (BASE_IRQ_CAP + IRQ_CH);
//            sel4cp_dbg_puts("Got something");
//            /* Acknowledge receipt of the interrupt. */
//            sel4cp_irq_ack(channel);
//            return;
//        default:
//            sel4cp_dbg_puts("eth driver: received notification on unexpected channel\n");
//            break;
//    }
}
