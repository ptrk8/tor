
#include <sel4cp.h>
#include <sel4/sel4.h>
#include "serial.h"
#include "util.h"

uintptr_t uart_base;

void put_char(uint8_t ch) {
    while (!(*UART_REG(STAT) & STAT_TDRE)) {}
    *UART_REG(TRANSMIT) = ch;
}

void print(const char *s) {
    while (*s) {
        put_char(*s);
        s++;
    }
}

void init(void) {
    print("Hello world again.\n");
    sel4cp_dbg_puts("Hello world.\n");
}

seL4_MessageInfo_t protected(sel4cp_channel ch, sel4cp_msginfo msginfo) {
    return sel4cp_msginfo_new(0, 0);
}

void notified(sel4cp_channel ch) {

}
