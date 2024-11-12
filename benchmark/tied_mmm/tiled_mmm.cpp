#include <stdint.h>

void r_tiled_mmm(int n, int stride, float *dst, const float *a, const float *b)
{//error:loc("../test_files/tiled_mmm.cpp":7:23): error: operand #0 does not dominate this use
    auto sub = [&](int v,int h) -> int
    { return v*stride*n/2+h*n/2; };

    if( n<=16 ){
        for(int r=0; r<n; r++){
            for(int c=0; c<n; c++){
                float acc=dst[r*stride+c];
                for(int i=0; i<n; i++){
                    acc += a[r*stride+i] * b[i*stride+c];
                }
                dst[r*stride+c]=acc;
            }
        }
    }else{

        r_tiled_mmm(n/2, stride, dst+sub(0,0), a+sub(0,0), b+sub(0,0));
        r_tiled_mmm(n/2, stride, dst+sub(0,1), a+sub(0,0), b+sub(0,1));
        r_tiled_mmm(n/2, stride, dst+sub(1,0), a+sub(1,0), b+sub(0,0));
        r_tiled_mmm(n/2, stride, dst+sub(1,1), a+sub(1,0), b+sub(0,1));

        r_tiled_mmm(n/2, stride, dst+sub(0,0), a+sub(0,1), b+sub(1,0));
        r_tiled_mmm(n/2, stride, dst+sub(0,1), a+sub(0,1), b+sub(1,1));
        r_tiled_mmm(n/2, stride, dst+sub(1,0), a+sub(1,1), b+sub(1,0));
        r_tiled_mmm(n/2, stride, dst+sub(1,1), a+sub(1,1), b+sub(1,1));
    }
}