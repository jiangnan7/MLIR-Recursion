#include <stdint.h>

void r_sort(uint32_t *a, int n)
{
    int split=0;
    if( n < 32 ){
        int i, j;
        uint32_t t;
        for (i = 1; i < n; i++) {
            t = a[i];
            for (j = i; j > 0 && t < a[j - 1]; j--) {
                a[j] = a[j - 1];
            }
            a[j] = t;
        }
    }else{
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
        r_sort(a,       split);
        r_sort(a+split, n-split);
    }
}