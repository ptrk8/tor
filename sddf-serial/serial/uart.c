#include "uart.h"

void uart_put_char(uint8_t ch) {
    while (!(*UART_REG(STAT) & STAT_TDRE)) {}
    *UART_REG(TRANSMIT) = ch;
}