#include <stdint.h>

void man_sum(uint32_t n, int32_t *f)
{
    const int DEPTH=512;
    
    int sp=0;
    int stack_n[DEPTH];
    int32_t *stack_f[DEPTH];
    int stack_state[DEPTH];
    
    stack_n[0]=n;
    stack_f[0]=f;
    stack_state[0]=0;
    
    while(1){
        n=stack_n[sp];
        f=stack_f[sp];
        int state=stack_state[sp];
        
        if(state==0){
            if(n<=1){
                if(sp==0){
                    break;
                }else{
                    sp--;
                }
            }else{
                stack_state[sp]=1;
                sp++;
                stack_state[sp]=0;
                stack_n[sp]=n/2;
                stack_f[sp]=f;
            }
        }else if(state==1){
            stack_state[sp]=2;
            sp++;
            stack_state[sp]=0;
            stack_n[sp]=n-n/2;
            stack_f[sp]=f+n/2;
        }else if(state==2){
            f[0]+=f[n/2];
            if(sp==0){
                break;
            }else{
                sp--;
            }
        }
    }
};
