#include "serial_driver.h"

/* This will be automatically populated with the Virtual Address that
 * corresponds to the Physical Address of the UART device by the seL4CP tool. */
uintptr_t uart_base_vaddr;

serial_driver_t global_serial_driver = {};

/**
 * Initialises the serial driver. Called by this PD's `init` function.
 * @param serial_driver
 * @param imx_uart_base_vaddr
 * @param auto_insert_carriage_return
 * @return
 */
static int serial_driver_init(
        serial_driver_t *serial_driver,
        uintptr_t imx_uart_base_vaddr,
        bool auto_insert_carriage_return
);

//void serial_write(const char *str) {
//    while (*str) {
////        uart_put_char(&uart, *str);
//        str++;
//    }
//}

static int serial_driver_init(
        serial_driver_t *serial_driver,
        uintptr_t imx_uart_base_vaddr,
        bool auto_insert_carriage_return
) {
    bool is_success = imx_uart_init(
            &serial_driver->imx_uart,
            imx_uart_base_vaddr,
            auto_insert_carriage_return
    );
    if (is_success) {
        return 0;
    }
    return -1;
}

void serial_driver_put_char(serial_driver_t *serial_driver, int ch) {
    /* Keep trying to send the character to the UART device until it is successful. */
    while (imx_uart_put_char(&serial_driver->imx_uart, ch) < 0);
}

void init(void) {
    sel4cp_dbg_puts("\n=== START ===\n");
    sel4cp_dbg_puts("Initialising UART device...\n");
    serial_driver_t *serial_driver = &global_serial_driver; /* Local reference to global serial driver for our convenience. */
    int ret_serial_driver_init = serial_driver_init(
            serial_driver,
            uart_base_vaddr,
            true
    );
    if (ret_serial_driver_init < 0) {
        sel4cp_dbg_puts("UART device initialisation FAILED.\n");
        return;
    }
    sel4cp_dbg_puts("UART device initialisation SUCCESS.\n");
    serial_driver_put_char(serial_driver, '\n');
    for (int i = 0; i < 5; i++) {
        serial_driver_put_char(serial_driver, 'a');
        serial_driver_put_char(serial_driver, 'b');
        serial_driver_put_char(serial_driver, 'c');
    }
    serial_driver_put_char(serial_driver, '\n');
    sel4cp_dbg_puts("Ending UART test...\n");
    sel4cp_dbg_puts("=== END ===\n");
}

seL4_MessageInfo_t protected(sel4cp_channel ch, sel4cp_msginfo msginfo) {
    return sel4cp_msginfo_new(0, 0);
}

void notified(sel4cp_channel channel) {
    serial_driver_t *serial_driver = &global_serial_driver; /* Local reference to global serial driver for our convenience. */
    switch(channel) {
        case IRQ_59_CHANNEL: {
            int c = imx_uart_get_char(&global_serial_driver.imx_uart);
            if (c != -1) {
                serial_driver_put_char(serial_driver, c);
            }
            /* Acknowledge receipt of the interrupt. */
            sel4cp_irq_ack(channel);
            return;
        }
        default:
            sel4cp_dbg_puts("Serial driver: received notification on unexpected channel\n");
            break;
    }
}
