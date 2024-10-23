module test_systolic_matrix_mul_2x2();
  // Inputs
    reg clk;
    reg rst;
    reg [31:0] a00, a01, a10, a11;
    reg [31:0] b00, b01, b10, b11;

    // Outputs
    wire [31:0] c00, c01, c10, c11;

    // Instantiate the systolic matrix multiplication module
    systolic_matrix_mul_2x2 uut (
        .clk(clk),
        .rst(rst),
        .a00(a00),
        .a01(a01),
        .b00(b00),
        .b01(b01),
        .c00(c00),
        .c01(c01),
        .c10(c10),
        .c11(c11)
    );

    // Clock generation
    always #5 clk = ~clk;  // Clock with 10-time unit period

    // Test stimulus
    initial begin
        // Initialize the inputs
        clk = 0;
        rst = 1;
        
        // Hold reset for a few cycles
        #10;
        rst = 0;
        
        // Set inputs for Matrix A
        a00 = 32'd1;  // A(0,0) = 1
        a01 = 32'd2;  // A(0,1) = 2
        a10 = 32'd0;  // A(1,0) = 0
        a11 = 32'd2;  // A(1,1) = 2

        // Set inputs for Matrix B
        b00 = 32'd1;  // B(0,0) = 1
        b01 = 32'd2;  // B(0,1) = 2
        b10 = 32'd0;  // B(1,0) = 0
        b11 = 32'd2;  // B(1,1) = 2

        // Wait for a few cycles to observe the results
        #50;

        // Display the results
        $display("C(0,0) = %d", c00);
        $display("C(0,1) = %d", c01);
        $display("C(1,0) = %d", c10);
        $display("C(1,1) = %d", c11);
        
        // End the simulation
        $stop;
    end

endmodule
