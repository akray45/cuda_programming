#include <iostream>
#include <stdlib.h>
#include <string>
#include "cuda.h"
using namespace std;

__global__ void hello_cuda(){
    printf("hello threadIdx %d, blockIdx %d \n",threadIdx.x, blockIdx.x);

}

int main(){
    hello_cuda<<<1, 2>>>();
    cudaDeviceSynchronize();
    return 0;
}