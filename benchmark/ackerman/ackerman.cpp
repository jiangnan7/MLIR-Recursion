#include <stdint.h>

uint32_t r_ackerman(uint32_t m, uint32_t n)
{
    if(m==0){
        return n+1;
    }else if(m>0 && n==0){
        return r_ackerman(m-1, 1);
    }else{
        n=r_ackerman(m,n-1);
        return r_ackerman(m-1,n);
    }
}
