
#include "serial.h"
#include "util.h"

/* This will be automatically populated by the seL4CP tool. */
uintptr_t uart_base_vaddr;

/* Global UART device. */
uart_t uart = {};

void serial_write(const char *str) {
    while (*str) {
        uart_put_char(*str);
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

void notified(sel4cp_channel ch) {

}
