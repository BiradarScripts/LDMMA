#include <iostream>
#include "matrix_mult.h"

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
    std::cout << "Resultant Matrix C: " << std::endl;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            std::cout << C[i][j] << " ";
        }
        std::cout << std::endl;
    }

    return 0;
}
