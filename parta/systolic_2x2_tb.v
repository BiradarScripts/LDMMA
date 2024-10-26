//module test_systolic_matrix_mul_2x2();
//  // Inputs
//  reg clk;
//  reg rst;
//  reg [31:0] a00, a01;
//  reg [31:0] b00, b01;

//  // Outputs
//  wire [31:0] c00, c01, c10, c11;

//  // Instantiate the systolic matrix multiplication module
//  systolic_matrix_mul_2x2 uut (
//    .clk(clk),
//    .rst(rst)
//  );

//  // Clock generation
//  always #5 clk = ~clk;  // Clock with 10-time unit period

//  // Test stimulus
//  initial begin
//    // Initialize the inputs
//    clk = 0;
//    rst = 1;

//    // Hold reset for a few cycles
//    #10;
//    rst = 0;

//    // Test Case 1
//    a00 = 32'd1;  a01 = 32'd0;
//    b00 = 32'd1;  b01 = 32'd0;

//    #10
//    // Test Case 2
//    a00 = 32'd2;  a01 = 32'd1;
//    b00 = 32'd2;  b01 = 32'd1;

//    #10
//    // Test Case 3
//    a00 = 32'd0;  a01 = 32'd2;
//    b00 = 32'd0;  b01 = 32'd2;
//    #10
//     a00 = 32'd0;  a01 = 32'd0;
//    b00 = 32'd0;  b01 = 32'd0;
    

//    // Wait and display final results
//    #50;
//    $display("Final Results:");
//    $display("C(0,0) = %d", c00);
//    $display("C(0,1) = %d", c01);
//    $display("C(1,0) = %d", c10);
//    $display("C(1,1) = %d", c11);

//    // End the simulation
//    $stop;
//  end

//endmodule