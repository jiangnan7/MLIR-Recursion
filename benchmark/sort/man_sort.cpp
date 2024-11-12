#include <stdint.h>


void man_sort(uint32_t *a, int n)
{
    //printf("sort(%d)\n", n);
    
    const unsigned DEPTH=512;
    
    int sp=0;
    uint32_t *stack_a[DEPTH];
    int stack_n[DEPTH];
    int stack_split[DEPTH];
    int stack_state[DEPTH];
    
    stack_a[0]=a;
    stack_n[0]=n;
    stack_state[0]=0;
    
    while(1){
        a=stack_a[sp];
        n=stack_n[sp];
        int split=stack_split[sp];
        int state=stack_state[sp];
        
        /*for(int i=0;i<sp;i++){
            printf("  ");
        }
        printf("n=%d",n);*/
        
        if(state==0){
            if( n < 32 ){
                //printf(" leaf\n");
                // From Rosetta Code
                // http://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#C
                /*fprintf(stderr, "n=%d\n", n);
                for(int ii=0; ii<n;ii++){
                    fprintf(stderr, " %.5f", a[ii]);
                }
                fprintf(stderr, "\n");*/
                int i, j;
                uint32_t t;
                for (i = 1; i < n; i++) {
                    t = a[i];
                    for (j = i; j > 0 && t < a[j - 1]; j--) {
                        a[j] = a[j - 1];
                    }
                    a[j] = t;
                    /*for(int ii=0; ii<n;ii++){
                        fprintf(stderr, " %.5f", a[ii]);
                    }
                    fprintf(stderr, "\n");*/
                }
                if(sp==0){
                    break;
                }else{
                    sp--;
                }
            }else{
                //printf(" branch-0\n");
                // This is taken from Rosetta Code
                // http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#C
                uint32_t pivot=a[n/2];
                int i,j;
                for(i=0, j=n-1;; i++, j--){
                    while(a[i]<pivot)
                        i++;
                    while(pivot<a[j])
                        j--;
                    if(i>=j)
                        break;
                    uint32_t tmp=a[i];
                    a[i]=a[j];
                    a[j]=tmp;
                }
                split=i;
                
                stack_split[sp]=split;
                stack_state[sp]=1;
                // call r_sort(a, split)
                sp++;
                stack_state[sp]=0;
                stack_a[sp]=a;
                stack_n[sp]=split;
            }
        }else if(state==1){
            //printf(" branch-1\n");
            // complete  r_sort(a,       split);
            // call r_sort(a+split, n-split);
            stack_state[sp]=2;
            sp++;
            stack_state[sp]=0;
            stack_a[sp]=a+split;
            stack_n[sp]=n-split;
        }else if(state==2){
            //printf(" branch-2\n");
            if(sp==0){
                break;
            }else{
                sp--;
            }
        }
    }
}