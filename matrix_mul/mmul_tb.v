module test_matrix_mul_4x4;
    reg [15:0] A [15:0];  // Flattened 4x4 matrix A, 16 elements of 16-bit each
    reg [15:0] B [15:0];  // Flattened 4x4 matrix B, 16 elements of 16-bit each
    wire [15:0] C [15:0]; // Flattened 4x4 matrix C, 16 elements of 16-bit each

    // Instantiate the matrix multiplication module
    matrix_mul_4x4 uut (
        .A(A),
        .B(B),
        .C(C)
    );

    initial begin
        // Test 1: Identity matrix multiplied by a sample matrix
        A[0] = 16'd1; A[1] = 16'd0; A[2] = 16'd0; A[3] = 16'd0;
        A[4] = 16'd0; A[5] = 16'd1; A[6] = 16'd0; A[7] = 16'd0;
        A[8] = 16'd0; A[9] = 16'd0; A[10] = 16'd1; A[11] = 16'd0;
        A[12] = 16'd0; A[13] = 16'd0; A[14] = 16'd0; A[15] = 16'd1;

        B[0] = 16'd5; B[1] = 16'd10; B[2] = 16'd15; B[3] = 16'd20;
        B[4] = 16'd6; B[5] = 16'd11; B[6] = 16'd16; B[7] = 16'd21;
        B[8] = 16'd7; B[9] = 16'd12; B[10] = 16'd17; B[11] = 16'd22;
        B[12] = 16'd8; B[13] = 16'd13; B[14] = 16'd18; B[15] = 16'd23;

        #10; // Wait for the multiplication to complete

        $display("Test 1: Identity matrix multiplied by a sample matrix");
        $display("Matrix A: ");
        $display("A[0] = %d A[1] = %d A[2] = %d A[3] = %d", A[0], A[1], A[2], A[3]);
        $display("A[4] = %d A[5] = %d A[6] = %d A[7] = %d", A[4], A[5], A[6], A[7]);
        $display("A[8] = %d A[9] = %d A[10] = %d A[11] = %d", A[8], A[9], A[10], A[11]);
        $display("A[12] = %d A[13] = %d A[14] = %d A[15] = %d", A[12], A[13], A[14], A[15]);

        $display("Matrix B: ");
        $display("B[0] = %d B[1] = %d B[2] = %d B[3] = %d", B[0], B[1], B[2], B[3]);
        $display("B[4] = %d B[5] = %d B[6] = %d B[7] = %d", B[4], B[5], B[6], B[7]);
        $display("B[8] = %d B[9] = %d B[10] = %d B[11] = %d", B[8], B[9], B[10], B[11]);
        $display("B[12] = %d B[13] = %d B[14] = %d B[15] = %d", B[12], B[13], B[14], B[15]);

        $display("Matrix C (Result): ");
        $display("C[0] = %d C[1] = %d C[2] = %d C[3] = %d", C[0], C[1], C[2], C[3]);
        $display("C[4] = %d C[5] = %d C[6] = %d C[7] = %d", C[4], C[5], C[6], C[7]);
        $display("C[8] = %d C[9] = %d C[10] = %d C[11] = %d", C[8], C[9], C[10], C[11]);
        $display("C[12] = %d C[13] = %d C[14] = %d C[15] = %d", C[12], C[13], C[14], C[15]);

        // Finish the simulation
        $finish;
    end
endmodule
