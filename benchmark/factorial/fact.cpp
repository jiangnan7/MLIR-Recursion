#include <stdint.h>

uint32_t factorial(uint32_t n)
{
    if(n<=1){
        return 1;
    }else{
        return factorial(n-1)*n;
    }
}
