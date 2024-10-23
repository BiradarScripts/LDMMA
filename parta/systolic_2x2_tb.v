module test_systolic_matrix_mul_2x2();
  // Inputs
  reg clk;
  reg rst;
  reg [31:0] a00, a01;
  reg [31:0] b00, b01;

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

    // Test Case 1: First row inputs for A (a11, a12, 0)
    a00 = 32'd1;  // A(1,1) = 1
    a01 = 32'd0;  // A(1,2) = 2

    // First column inputs for B (b11, b21, 0)
    b00 = 32'd1;  // B(1,1) = 1
    b01 = 32'd0;  // B(2,1) = 2

    #20
    // Test Case 2: Second row inputs for A (0, a21, a22)
    a00 = 32'd2;  // A(0,1) = 0
    a01 = 32'd1;  // A(2,2) = 3

    // Second column inputs for B (0, b21, b22)
    b00 = 32'd2;  // B(0,1) = 0
    b01 = 32'd1;  // B(2,2) = 3

    #30
    // Test Case 3: Mixed input values to verify systolic array
    a00 = 32'd0;
    a01 = 32'd2;

    b00 = 32'd0;
    b01 = 32'd2;

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
