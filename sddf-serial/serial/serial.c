/*
 * Copyright 2022, UNSW
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <sel4cp.h>
#include <sel4/sel4.h>
#include "serial.h"
#include "util.h"

uintptr_t uart_base;

void init(void)
{
    sel4cp_dbg_puts("Hello world.\n");
}

seL4_MessageInfo_t
protected(sel4cp_channel ch, sel4cp_msginfo msginfo)
{
    return sel4cp_msginfo_new(0, 0);
}

void notified(sel4cp_channel ch)
{

}
