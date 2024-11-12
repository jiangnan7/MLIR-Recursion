void decimalToBase(int decimal, int base, int result[], int& index) {
    int quotient = decimal;
    int stack[512];
    int top = -1;

    while (quotient > 0) {
        int remainder = quotient % base;
        quotient /= base;

        stack[++top] = remainder;
    }

    while (top >= 0) {
        result[index++] = stack[top--];
    }
}
