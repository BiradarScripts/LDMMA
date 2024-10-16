#include <stdio.h>
#include <math.h>
#include "karatsuba.h"

// Function to multiply two numbers
long long multiply(long long a, long long b) {
    return a * b; // Regular multiplication for base case
}

// Iterative Karatsuba multiplication
long long karatsuba(long long x, long long y) {
    // Handle base case when one of the numbers is less than 10
    if (x < 10 || y < 10) {
        return multiply(x, y);
    }

    long long result = 0;
    long long a, b, c, d;
    int half_n;

    while (x >= 10 && y >= 10) {
        // Calculate the number of digits
        int n = fmax(log10(x) + 1, log10(y) + 1);
        half_n = n / 2;

        // Split x and y into two halves
        a = x / (long long)pow(10, half_n);
        b = x % (long long)pow(10, half_n);
        c = y / (long long)pow(10, half_n);
        d = y % (long long)pow(10, half_n);

        // Calculate products
        long long ac = multiply(a, c);
        long long bd = multiply(b, d);
        long long abcd = multiply(a + b, c + d) -ac-bd;

        // Combine results
        result = ac * (long long)pow(10, 2 * half_n) + (abcd - ac - bd) * (long long)pow(10, half_n) + bd;

        // Update x and y to use the result for further processing
        x = result;
//        y = 0; // We no longer need y for the next iteration
    }
    return multiply(x, y); // Handle case when one of them is < 10
}
