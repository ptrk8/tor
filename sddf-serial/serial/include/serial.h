#pragma once

#include <sel4cp.h>
#include <sel4/sel4.h>
//#include <assert.h>

#include "uart.h"
#include "imx_uart_regs.h"

void serial_write(const char *s);
