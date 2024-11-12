#include <stdint.h>

uint32_t man_ackerman(uint32_t m, uint32_t n)
{
    const unsigned DEPTH=512;

    unsigned sp=0;
    uint32_t stack_n[DEPTH];
    uint32_t stack_m[DEPTH];
    int stack_state[DEPTH];
    uint32_t retval;

    stack_n[sp]=n;
    stack_m[sp]=m;
    stack_state[sp]=0;

    while(1){
        int state=stack_state[sp];
        n=stack_n[sp];
        m=stack_m[sp];
        if(state==0){
            if(m==0){
                retval=n+1;
                if(sp==0){
                    break;
                }else{
                    sp--;
                }
            }else if(m>0 && n==0){
                stack_state[sp]=1;
                sp++;
                stack_state[sp]=0;
                stack_m[sp]=m-1;
                stack_n[sp]=1;
            }else{
                //printf("branchB-0\n");

                //n=r_ackerman(m,n-1);
                //return r_ackerman(m-1,n);
                // call ackerman(m,n-1)
                stack_state[sp]=2;
                sp++;
                stack_state[sp]=0;
                stack_m[sp]=m;
                stack_n[sp]=n-1;
            } 
        }else if(state==1){
            //printf("branchA-1\n");
            // complete r_ackerman(m-1,1)
            // propagate retval back
            if(sp==0){
                break;
            }else{
                sp--;
            }
        }else if(state==2){
            //printf("branchB-2\n");
            // complete n=ackerman(m,n-1)
            n=retval;
            stack_n[sp]=n;
            // call ackerman(m,n-1)
            stack_state[sp]=3;
            sp++;
            stack_state[sp]=0;
            stack_m[sp]=m-1;
            stack_n[sp]=n;
        }else if(state==3){
            //printf("branchB-3\n");
            // complete ackerman(m-1,n)
            if(sp==0){
                break;
            }else{
                sp--;
            }
        }
    }
    return retval;
}
