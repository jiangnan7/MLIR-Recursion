void decimalToBase(int decimal, int base, int result[], int& index) {
    if (decimal == 0) {
        // Base case: decimal is 0, stop recursion
        return;
    } else {
        // Recursive case: convert quotient to base and calculate remainder
        int quotient = decimal / base;
        int remainder = decimal % base;

        // Recursively call decimalToBase function
        decimalToBase(quotient, base, result, index);

        // Store the remainder in the result array
        result[index++] = remainder;
    }
}