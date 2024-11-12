#include <stdint.h>

void reverseArray(int arr[], int start, int end) {
    const int DEPTH = 512;

    unsigned sp=0;
    int32_t * stack_arr[DEPTH];
    uint32_t stack_start[DEPTH];
    uint32_t stack_end[DEPTH];

    int stack_state[DEPTH];


    stack_arr[0]=arr;
    stack_start[0]=start;
    stack_end[0]=end;
    stack_state[0]=0;

    while (1) {
        arr=stack_arr[sp];
        start=stack_start[sp];
        end=stack_end[sp];

        int state=stack_state[sp];

        if(state==0){
            if(start >= end){
                if(sp==0){
                    break;
                }else{
                    sp--;
                }
            }else{
                int temp = arr[start];
                arr[start] = arr[end];
                arr[end] = temp;

                stack_state[sp]=1;
                sp++;
                stack_state[sp]=0;
                stack_arr[sp]=arr;
                stack_start[sp]=start+1;
                stack_end[sp]=end-1;
         
            }
        }else if(state==1){
            if(sp==0){
                break;
            }else{
                sp--;
            }
        }
    }
}