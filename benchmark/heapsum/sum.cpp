#include <stdint.h>
void r_sum(uint32_t n, int32_t *f)
{
    if(n<=1){
        return;
    }else{
        r_sum(n/2, f);
        r_sum(n-(n/2), f+n/2);
        f[0] += f[n/2];
    }
};

void sum(uint32_t n, int32_t *f) {
    if(n<=1){
        return;
    }else{
        for(uint32_t i = 1; i < n; i *= 2) {
            for(uint32_t j = 0; j < n-i; j += 2*i) {
                f[j] += f[j+i];
            }
        }
    }
}
