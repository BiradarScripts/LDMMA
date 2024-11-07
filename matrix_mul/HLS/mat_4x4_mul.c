#include "matrix_mult.h"

void matrix_mult_4x4(int A[4][4], int B[4][4], int C[4][4]) {
    #pragma HLS array_partition variable=A complete
    #pragma HLS array_partition variable=B complete
    #pragma HLS array_partition variable=C complete
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            C[i][j] = 0;
            for (int k = 0; k < 4; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}
