module systolic_matrix_mul_4x4 (
    input wire clk,                   // Clock signal
    input wire rst,                   // Reset signal
    input wire [31:0] a[0:3],         // 4x4 input matrix A
    input wire [31:0] b[0:3],         // 4x4 input matrix B
    output wire [31:0] c[0:3][0:3]    // 4x4 output matrix C
);

    // Internal connections for the intermediate a, b, and c values
    wire [31:0] a_reg[0:3][0:3];
    wire [31:0] b_reg[0:3][0:3];
    wire [31:0] c_reg[0:3][0:3];

    // Row 0
    systolic_unit pe00 (.a(a[0]), .b(b[0]), .clk(clk), .rst(rst), .c_out(c[0][0]), .a_out(a_reg[0][0]), .b_out(b_reg[0][0]));
    systolic_unit pe01 (.a(a[1]), .b(b_reg[0][0]), .clk(clk), .rst(rst), .c_out(c[0][1]), .a_out(a_reg[0][1]), .b_out(b_reg[0][1]));
    systolic_unit pe02 (.a(a[2]), .b(b_reg[0][1]), .clk(clk), .rst(rst), .c_out(c[0][2]), .a_out(a_reg[0][2]), .b_out(b_reg[0][2]));
    systolic_unit pe03 (.a(a[3]), .b(b_reg[0][2]), .clk(clk), .rst(rst), .c_out(c[0][3]), .a_out(a_reg[0][3]), .b_out(b_reg[0][3]));

    // Row 1
    systolic_unit pe10 (.a(a_reg[0][0]), .b(b[1]), .clk(clk), .rst(rst), .c_out(c[1][0]), .a_out(a_reg[1][0]), .b_out(b_reg[1][0]));
    systolic_unit pe11 (.a(a_reg[0][1]), .b(b_reg[1][0]), .clk(clk), .rst(rst), .c_out(c[1][1]), .a_out(a_reg[1][1]), .b_out(b_reg[1][1]));
    systolic_unit pe12 (.a(a_reg[0][2]), .b(b_reg[1][1]), .clk(clk), .rst(rst), .c_out(c[1][2]), .a_out(a_reg[1][2]), .b_out(b_reg[1][2]));
    systolic_unit pe13 (.a(a_reg[0][3]), .b(b_reg[1][2]), .clk(clk), .rst(rst), .c_out(c[1][3]), .a_out(a_reg[1][3]), .b_out(b_reg[1][3]));

    // Row 2
    systolic_unit pe20 (.a(a_reg[1][0]), .b(b[2]), .clk(clk), .rst(rst), .c_out(c[2][0]), .a_out(a_reg[2][0]), .b_out(b_reg[2][0]));
    systolic_unit pe21 (.a(a_reg[1][1]), .b(b_reg[2][0]), .clk(clk), .rst(rst), .c_out(c[2][1]), .a_out(a_reg[2][1]), .b_out(b_reg[2][1]));
    systolic_unit pe22 (.a(a_reg[1][2]), .b(b_reg[2][1]), .clk(clk), .rst(rst), .c_out(c[2][2]), .a_out(a_reg[2][2]), .b_out(b_reg[2][2]));
    systolic_unit pe23 (.a(a_reg[1][3]), .b(b_reg[2][2]), .clk(clk), .rst(rst), .c_out(c[2][3]), .a_out(a_reg[2][3]), .b_out(b_reg[2][3]));

    // Row 3
    systolic_unit pe30 (.a(a_reg[2][0]), .b(b[3]), .clk(clk), .rst(rst), .c_out(c[3][0]), .a_out(a_reg[3][0]), .b_out(b_reg[3][0]));
    systolic_unit pe31 (.a(a_reg[2][1]), .b(b_reg[3][0]), .clk(clk), .rst(rst), .c_out(c[3][1]), .a_out(a_reg[3][1]), .b_out(b_reg[3][1]));
    systolic_unit pe32 (.a(a_reg[2][2]), .b(b_reg[3][1]), .clk(clk), .rst(rst), .c_out(c[3][2]), .a_out(a_reg[3][2]), .b_out(b_reg[3][2]));
    systolic_unit pe33 (.a(a_reg[2][3]), .b(b_reg[3][2]), .clk(clk), .rst(rst), .c_out(c[3][3]), .a_out(a_reg[3][3]), .b_out(b_reg[3][3]));

    ila_0 ila_instance (
        .clk(clk),           // input wire clk
        .probe0(c[0][0]),    // input wire [31:0] probe0
        .probe1(c[0][1]),    // input wire [31:0] probe1
        .probe2(c[0][2]),    // input wire [31:0] probe2
        .probe3(c[0][3]),    // input wire [31:0] probe3
        .probe4(c[1][0]),    // input wire [31:0] probe4
        .probe5(c[1][1]),    // input wire [31:0] probe5
        .probe6(c[1][2]),    // input wire [31:0] probe6
        .probe7(c[1][3]),    // input wire [31:0] probe7
        .probe8(c[2][0]),    // input wire [31:0] probe8
        .probe9(c[2][1]),    // input wire [31:0] probe9
        .probe10(c[2][2]),   // input wire [31:0] probe10
        .probe11(c[2][3]),   // input wire [31:0] probe11
        .probe12(c[3][0]),   // input wire [31:0] probe12
        .probe13(c[3][1]),   // input wire [31:0] probe13
        .probe14(c[3][2]),   // input wire [31:0] probe14
        .probe15(c[3][3]),   // input wire [31:0] probe15
        .probe16(rst)        // input wire [0:0] probe16
    );

endmodule
