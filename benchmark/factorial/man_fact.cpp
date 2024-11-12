#include <cstdint>
#include <iostream>
uint32_t factorial(uint32_t n) {
    if (n <= 1) {
        return 1;
    }

    uint32_t result = 1;
    for (uint32_t i = 2; i <= n; i++) {
        result *= i;
    }

    return result;
}
