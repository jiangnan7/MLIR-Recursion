#include <stdint.h>

uint32_t r_fib(uint32_t n)
{
    if(n<=2){
        return 1;
    }else{
        return r_fib(n-1)+r_fib(n-2);
    }
}