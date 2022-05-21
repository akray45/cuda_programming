#include <iostream>
#include <stdlib.h>
#include <ctime>
#include <cassert>
#include <vector>
#include "cuda.h"
#include "ERROR.h"

using namespace std;

__global__ void transpose(int *a, int *b, int size){
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    int j = threadIdx.y + blockDim.y * blockIdx.y;
    b[i*size + j] = b[j*size + i];
}

void generate_random(vector<vector<int>>&a, int size){
    srand(time(NULL));
    for(int i = 0; i<size; i++)
    {   vector<int> temp;
        for (int j = 0; j<size; j++){
        temp.push_back(rand() %size +1);
    }
    a.push_back(temp);
}


}
void verify_result(vector<vector<int>> &a, vector<vector<int>> &b){
    for(int i=0; i<a.size();i++){
        for(int j = 0; j<a.size(); j++){
            assert(b[i][j] == a[j][i]);
        }
    }
    printf("result verified.....\n");
}



void device(vector<vector<int>>&a, vector<vector<int>> &b, int size){
    int *d_a, *d_b;
    int total_size = size*sizeof(int)*size;
    HANDLER_ERROR_ERR(cudaMalloc( &d_a, total_size ));
    HANDLER_ERROR_ERR(cudaMalloc( &d_b, total_size ));

    cudaMemcpy( d_a,a.data() ,total_size , cudaMemcpyHostToDevice);
    cudaMemcpy( d_b,b.data() ,total_size , cudaMemcpyHostToDevice);
    dim3 GridBlocks(4, 4);
    dim3 ThreadsBlocks(16, 16);

    //kernel launch
    transpose <<< GridBlocks,ThreadsBlocks >>>(d_a, d_b, size);
    cudaDeviceSynchronize();

    cudaMemcpy( b.data(),d_b ,total_size , cudaMemcpyDeviceToHost);
    HANDLER_ERROR_ERR(cudaFree( d_a));
    HANDLER_ERROR_ERR(cudaFree( d_b));


}

void host(){
    int size = 1000;
    vector<vector<int>> a;
    vector<vector<int>> b;
    device(a, b, size);
    verify_result(a, b);


}

int main(){
    host();
    return 0;
}