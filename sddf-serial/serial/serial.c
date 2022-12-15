
#include "serial.h"
#include "util.h"

//#define IRQ_CH 1
//
/* This will be automatically populated by the seL4CP tool. */
uintptr_t uart_base_vaddr;

/* Global UART device. */
uart_t uart = {};

void serial_write(const char *str) {
    while (*str) {
        uart_put_char(&uart, *str);
        str++;
    }
}

void init(void) {
    sel4cp_dbg_puts("Starting serial.c.\n");
    serial_write("Hello world.\n");

    bool is_success = uart_init(&uart, uart_base_vaddr);
//    assert(is_success);
    sel4cp_dbg_puts("Successfully initialise uart device.\n");
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
