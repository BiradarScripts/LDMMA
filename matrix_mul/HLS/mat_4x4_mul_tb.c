// For printf instead of iostream
#include <stdio.h>
#include"mat_4x4_mul.h"
int main() {
    int A[4][4] = {{1, 2, 3, 4},
                   {5, 6, 7, 8},
                   {9, 10, 11, 12},
                   {13, 14, 15, 16}};
                   
    int B[4][4] = {{16, 15, 14, 13},
                   {12, 11, 10, 9},
                   {8, 7, 6, 5},
                   {4, 3, 2, 1}};
                   
    int C[4][4]; // Result matrix
    
    // Call the matrix multiplication function
    matrix_mult_4x4(A, B, C);
    
    // Output the result matrix
    printf("Resultant Matrix C: \n");
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}
