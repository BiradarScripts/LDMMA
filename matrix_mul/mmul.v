module matrix_mul_4x4 (
    input [15:0] A [15:0], // Flattened 4x4 matrix A, 16 elements of 16-bit each
    input [15:0] B [15:0], // Flattened 4x4 matrix B, 16 elements of 16-bit each
    output [15:0] C [15:0] // Flattened 4x4 matrix C, 16 elements of 16-bit each
);
    integer i, j, k;
    reg [31:0] temp; // Temporary register for multiplication

    // Matrix multiplication logic
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                temp = 32'b0; // Initialize temp to 0
                for (k = 0; k < 4; k = k + 1) begin
                    // Accumulate the product for C[i][j]
                    temp = temp + A[i*4+k] * B[k*4+j];
                end
                C[i*4+j] = temp[15:0]; // Store the result as a 16-bit value
            end
        end
    end
endmodule
