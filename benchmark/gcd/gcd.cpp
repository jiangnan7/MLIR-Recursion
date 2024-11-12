#include <stdint.h>

int gcd(int a, int b) {
    if (b == 0) {
        // Base case: b is zero, return a as the GCD
        return a;
    } else {
        // Recursive case: recursively calculate GCD using Euclidean algorithm
        return gcd(b, a % b);
    }
}