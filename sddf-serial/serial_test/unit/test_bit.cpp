#include "gtest/gtest.h"

extern "C" {
#include <bit.h>
}


TEST(test_bit, should_set_bit) {
    int val = BIT(0);
    printf("val: 0x%x", val);
    val = BIT(3);
    printf("val: 0x%x", val);
}


