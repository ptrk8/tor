
#include <sel4cp.h>
#include <sel4/sel4.h>
#include "serial.h"
#include "util.h"
#include "uart.h"

uintptr_t uart_base;

void serial_write(const char *str) {
    while (*str) {
        uart_put_char(*str);
        str++;
    }
}

void init(void) {
    serial_write("Hello world.\n");
//    sel4cp_dbg_puts("Hello world.\n");
}

seL4_MessageInfo_t protected(sel4cp_channel ch, sel4cp_msginfo msginfo) {
    return sel4cp_msginfo_new(0, 0);
}

void notified(sel4cp_channel ch) {

}
