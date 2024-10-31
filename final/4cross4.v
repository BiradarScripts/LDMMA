module systolic_matrix_mul_4x4 (
    input wire clk,                      // Clock signal
    input wire rst,
    input wire [31:0] a,                // Input for first matrix
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    
    input wire [31:0] e,                // Input for second matrix
    input wire [31:0] f,
    input wire [31:0] g,
    input wire [31:0] h,

    output wire [31:0] i,                // Output for result matrix
    output wire [31:0] j,
    output wire [31:0] k,
    output wire [31:0] l,
    output wire [31:0] m,
    output wire [31:0] n,
    output wire [31:0] o,
    output wire [31:0] p,
    output wire [31:0] q,
    output wire [31:0] r,
    output wire [31:0] s,
    output wire [31:0] t,
    output wire [31:0] u,
    output wire [31:0] v,
    output wire [31:0] w,
    output wire [31:0] x
);

    wire [31:0] a_reg[0:3][0:3];  // Register array for first matrix
    wire [31:0] b_reg[0:3][0:3];  // Register array for second matrix
    wire [31:0] c_reg[0:3][0:3];  // Register array for output matrix

    // Assign inputs to registers for matrix A (first matrix)
    assign a_reg[0][0] = a;
    assign a_reg[0][1] = b;
    assign a_reg[0][2] = c;
    assign a_reg[0][3] = d;

    // Assign inputs to registers for matrix B (second matrix)
    assign b_reg[0][0] = e;
    assign b_reg[0][1] = f;
    assign b_reg[0][2] = g;
    assign b_reg[0][3] = h;

    // Row 0
    systolic_unit pe00 (.a(a_reg[0][0]), .b(b_reg[0][0]), .clk(clk), .rst(rst), .c_out(c_reg[0][0]), .a_out(a_reg[1][0]), .b_out(b_reg[1][0]));
    systolic_unit pe01 (.a(a_reg[0][1]), .b(b_reg[0][0]), .clk(clk), .rst(rst), .c_out(c_reg[0][1]), .a_out(a_reg[1][1]), .b_out(b_reg[1][1]));
    systolic_unit pe02 (.a(a_reg[0][2]), .b(b_reg[0][1]), .clk(clk), .rst(rst), .c_out(c_reg[0][2]), .a_out(a_reg[1][2]), .b_out(b_reg[1][2]));
    systolic_unit pe03 (.a(a_reg[0][3]), .b(b_reg[0][2]), .clk(clk), .rst(rst), .c_out(c_reg[0][3]), .a_out(a_reg[1][3]), .b_out(b_reg[1][3]));

    // Row 1
    systolic_unit pe10 (.a(a_reg[1][0]), .b(b_reg[1][0]), .clk(clk), .rst(rst), .c_out(c_reg[1][0]), .a_out(a_reg[2][0]), .b_out(b_reg[2][0]));
    systolic_unit pe11 (.a(a_reg[1][1]), .b(b_reg[1][1]), .clk(clk), .rst(rst), .c_out(c_reg[1][1]), .a_out(a_reg[2][1]), .b_out(b_reg[2][1]));
    systolic_unit pe12 (.a(a_reg[1][2]), .b(b_reg[1][2]), .clk(clk), .rst(rst), .c_out(c_reg[1][2]), .a_out(a_reg[2][2]), .b_out(b_reg[2][2]));
    systolic_unit pe13 (.a(a_reg[1][3]), .b(b_reg[1][3]), .clk(clk), .rst(rst), .c_out(c_reg[1][3]), .a_out(a_reg[2][3]), .b_out(b_reg[2][3]));

    // Row 2
    systolic_unit pe20 (.a(a_reg[2][0]), .b(b_reg[2][0]), .clk(clk), .rst(rst), .c_out(c_reg[2][0]), .a_out(a_reg[3][0]), .b_out(b_reg[3][0]));
    systolic_unit pe21 (.a(a_reg[2][1]), .b(b_reg[2][1]), .clk(clk), .rst(rst), .c_out(c_reg[2][1]), .a_out(a_reg[3][1]), .b_out(b_reg[3][1]));
    systolic_unit pe22 (.a(a_reg[2][2]), .b(b_reg[2][2]), .clk(clk), .rst(rst), .c_out(c_reg[2][2]), .a_out(a_reg[3][2]), .b_out(b_reg[3][2]));
    systolic_unit pe23 (.a(a_reg[2][3]), .b(b_reg[2][3]), .clk(clk), .rst(rst), .c_out(c_reg[2][3]), .a_out(a_reg[3][3]), .b_out(b_reg[3][3]));

    // Row 3
    systolic_unit pe30 (.a(a_reg[3][0]), .b(b_reg[3][0]), .clk(clk), .rst(rst), .c_out(c_reg[3][0]), .a_out(a_reg[4][0]), .b_out(b_reg[4][0]));
    systolic_unit pe31 (.a(a_reg[3][1]), .b(b_reg[3][1]), .clk(clk), .rst(rst), .c_out(c_reg[3][1]), .a_out(a_reg[4][1]), .b_out(b_reg[4][1]));
    systolic_unit pe32 (.a(a_reg[3][2]), .b(b_reg[3][2]), .clk(clk), .rst(rst), .c_out(c_reg[3][2]), .a_out(a_reg[4][2]), .b_out(b_reg[4][2]));
    systolic_unit pe33 (.a(a_reg[3][3]), .b(b_reg[3][3]), .clk(clk), .rst(rst), .c_out(c_reg[3][3]), .a_out(a_reg[4][3]), .b_out(b_reg[4][3]));

    // Outputs assignments
    assign i = c_reg[0][0];
    assign j = c_reg[0][1];
    assign k = c_reg[0][2];
    assign l = c_reg[0][3];
    assign m = c_reg[1][0];
    assign n = c_reg[1][1];
    assign o = c_reg[1][2];
    assign p = c_reg[1][3];
    assign q = c_reg[2][0];
    assign r = c_reg[2][1];
    assign s = c_reg[2][2];
    assign t = c_reg[2][3];
    assign u = c_reg[3][0];
    assign v = c_reg[3][1];
    assign w = c_reg[3][2];
    assign x = c_reg[3][3];

endmodule
