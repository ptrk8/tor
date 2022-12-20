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
//    sel4cp_dbg_puts("Hello");
    switch(channel) {
        case 1:
//            signal_msg = seL4_MessageInfo_new(IRQAckIRQ, 0, 0, 0);
//            signal = (BASE_IRQ_CAP + IRQ_CH);
            sel4cp_dbg_puts("Got something 1");
            /* Acknowledge receipt of the interrupt. */
            sel4cp_irq_ack(channel);
            return;
        case 2:
//            signal_msg = seL4_MessageInfo_new(IRQAckIRQ, 0, 0, 0);
//            signal = (BASE_IRQ_CAP + IRQ_CH);
            sel4cp_dbg_puts("2");
            /* Acknowledge receipt of the interrupt. */
            sel4cp_irq_ack(channel);
            return;
        case 3:
//            signal_msg = seL4_MessageInfo_new(IRQAckIRQ, 0, 0, 0);
//            signal = (BASE_IRQ_CAP + IRQ_CH);
            sel4cp_dbg_puts("Got something 3");
            /* Acknowledge receipt of the interrupt. */
            sel4cp_irq_ack(channel);
            return;
        case 4:
//            signal_msg = seL4_MessageInfo_new(IRQAckIRQ, 0, 0, 0);
//            signal = (BASE_IRQ_CAP + IRQ_CH);
            sel4cp_dbg_puts("Got something 4");
            /* Acknowledge receipt of the interrupt. */
            sel4cp_irq_ack(channel);
            return;
        case 5:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 6:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 7:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 8:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 9:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 10:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 11:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 12:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 13:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 14:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 15:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 16:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 17:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 18:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 19:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 20:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 21:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 22:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 23:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 24:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 25:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 26:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 27:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 28:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 29:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 30:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 31:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 32:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 33:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 34:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 35:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 36:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 37:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 38:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 39:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 40:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 41:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 42:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 43:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 44:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 45:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 46:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 47:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 48:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 49:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 50:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 51:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 52:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 53:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 54:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 55:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 56:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 57:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 58:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;
        case 59:
            sel4cp_dbg_puts("Got something 4");
            sel4cp_irq_ack(channel);
            return;


        case 60:
            sel4cp_dbg_puts("TwentySix");
            sel4cp_irq_ack(channel);
            return;
        case 61:
            sel4cp_dbg_puts("TwentySeven");
            sel4cp_irq_ack(channel);
            return;
        case 62:
            sel4cp_dbg_puts("TwentyEight");
            sel4cp_irq_ack(channel);
            return;
        case 63:
            sel4cp_dbg_puts("TwentyNine");
            sel4cp_irq_ack(channel);
            return;
        default:
            sel4cp_dbg_puts("eth driver: received notification on unexpected channel\n");
            break;
    }
}
