#pragma once

#include <stdbool.h>

#include "imx_uart_regs.h"

typedef struct imx_uart imx_uart_t;
volatile struct imx_uart {
    volatile imx_uart_regs_t *regs;
};

/**
 * Initialises the IMX Uart device.
 * @param imx_uart
 * @param base_vaddr
 * @return
 */
bool imx_uart_init(
        imx_uart_t *imx_uart,
        uintptr_t base_vaddr
);

/**
 * Prints out a character using the imx uart device.
 * @param imx_uart
 * @param c
 * @return
 */
int imx_uart_put_char(
        imx_uart_t *imx_uart,
        int c
);

/**
 * Gets character from UART device.
 * @param imx_uart
 * @return
 */
int imx_uart_get_char(
        imx_uart_t *imx_uart
);
