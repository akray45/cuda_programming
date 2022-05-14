// #include <iostream>
// #include <stdlib.h>
// #include <ctime>
#include "cuda.h"
#include <bits/stdc++.h>
using namespace std;
#include <vector>
#include <cassert>

__global__ void mat_add(int *a, int *b, int *c, int count){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid < count)
            c[tid] = a[tid] + b[tid];


}

void print_array(vector<int> &a, int count){
    for(int i = 0; i<count; i++){
        cout << "element at index "<<i<<" :- "<<a[i]<<endl;
    }
}

void generate_random(vector <int> &a, int count){
    // srand(time(NULL));

    for (int i =0; i<count; i++){
        a.push_back(rand() %100 + 1);
    }
}

void verify_result(vector <int> &a, vector <int> &b, vector <int> &c){
    for(int i = 0; i<a.size(); i++){
        assert(c[i] == a[i]+b[i]);
    }
}


int main(){
    int count = 200;
    vector<int> a;
    vector<int> b;
    vector<int> c(count);
    
    int size = sizeof(int) *count;

    int NUM_THREADS = 256;
    int NUM_BLOCKS = 1;

    generate_random(a, count);
    generate_random(b, count);

    print_array(a, 6);
    print_array(b, 6);


    int *d_a, *d_b, *d_c;
    cudaMalloc( &d_a,size );
    cudaMalloc( &d_b, size );
    cudaMalloc( &d_c, size );

    cudaMemcpy( d_a, a.data(), size, cudaMemcpyHostToDevice);
    cudaMemcpy( d_b, b.data(),size , cudaMemcpyHostToDevice);

    //kernel call
    mat_add<<< NUM_BLOCKS, NUM_THREADS >>>(d_a, d_b, d_c, count);

    cudaDeviceSynchronize();
    // writing data on cpu from gpu 
    cudaMemcpy( c.data(), d_c ,size , cudaMemcpyDeviceToHost);



    verify_result(a, b, c);
    print_array(c, 6);

    cudaFree( d_a);
    cudaFree( d_b);
    cudaFree( d_c);

    return 0;







}