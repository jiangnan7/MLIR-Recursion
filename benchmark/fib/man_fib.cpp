#include <stdint.h>

uint32_t man_fib(uint32_t n)
{
    const unsigned DEPTH=512;

    unsigned sp=0;
    uint32_t stack_n[DEPTH];
    uint32_t stack_r1[DEPTH];
    int stack_state[DEPTH];
    uint32_t retval;

    stack_n[sp]=n;
    stack_state[sp]=0;

    while(1){
        int state=stack_state[sp];
        uint32_t n=stack_n[sp];

        if(state==0){
            if(n<=2){
                //  return 1;
                retval=1;
                if(sp==0){
                    break;
                }else{
                    sp--;
                }
            }else{
                // call fib(n-1);
                stack_state[sp]=1;
                sp++;
                stack_state[sp]=0;
                stack_n[sp]=n-1;
            }
        }else if(state==1){
            // completed r_fib(n-1)
            stack_r1[sp]=retval;
            // call fib(n-2);
            stack_state[sp]=2;
            sp++;
            stack_state[sp]=0;
            stack_n[sp]=n-2;

        }else if(state==2){
            // completed r_fib(n-2)
            retval=stack_r1[sp]+retval;
            // return
            if(sp==0){
                break;
            }else{
                sp--;
            }
        }
    }
    return retval;
}