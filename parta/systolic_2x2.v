module systolic_matrix_mul_2x2(
    input wire clk,              // Clock signal
    input wire rst              // Reset signal
);

//wire 

reg ena, wea;
reg [1:0] addra;
wire [31:0] dina;


 wire [31:0] a00;
 wire [31:0] a01;       // Input matrix A (0,0)
 wire [31:0] b00;
 wire [31:0] b01;       // Input matrix B (0,0)
 wire [31:0] c00;      // Output matrix C (0,0)
 wire [31:0] c01;      // Output matrix C (0,1)
 wire [31:0] c10;      // Output matrix C (1,0)
 wire [31:0] c11;      // Output matrix C (1,1)

initial begin
    ena = 1;
    wea = 0;
    addra = 2'b00;
end

blk_mem_gen_0 mtrixa1 (
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [1 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(a00)  // output wire [31 : 0] douta
);

blk_mem_gen_0 mtrixb1 (
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [1 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(b00)  // output wire [31 : 0] douta
);

blk_mem_gen_1 matrixa2 (
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [1 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(a01)  // output wire [31 : 0] douta
);

ila_0 your_instance_name (
	.clk(clk), // input wire clk


	.probe0(a00), // input wire [31:0]  probe0  
	.probe1(a01), // input wire [31:0]  probe1 
	.probe2(b00), // input wire [31:0]  probe2 
	.probe3(b01), // input wire [31:0]  probe3 
	.probe4(c00), // input wire [31:0]  probe4 
	.probe5(c01), // input wire [31:0]  probe5 
	.probe6(c10), // input wire [31:0]  probe6 
	.probe7(c11) // input wire [31:0]  probe7
);

blk_mem_gen_1 matrixb2 (
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [1 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(b01)  // output wire [31 : 0] douta
);

// Internal registers to store intermediate values
wire [31:0] a_reg00, a_reg01, a_reg10, a_reg11;
wire [31:0] b_reg00, b_reg01, b_reg10, b_reg11;
wire [31:0] c_reg00, c_reg01, c_reg10, c_reg11;

// Instantiate the first PE for C(0,0)
systolic_unit pe00( 
    .a(a00),
    .b(b00),
    .clk(clk),
    .rst(rst),
    .a_out(a_reg00),
    .b_out(b_reg00),
    .c_out(c00)
);

// Debugging print for PE00 output


// Instantiate the second PE for C(0,1)
systolic_unit pe01(
    .a(a_reg00),
    .b(b01),  // Systolic pattern: pass value from below
    .clk(clk),
    .rst(rst),
    .a_out(a_reg01),
    .b_out(b_reg01),
    .c_out(c01)
);

// Debugging print for PE01 output


// Instantiate the third PE for C(1,0)
systolic_unit pe10(
    .a(a01),
    .b(b_reg00),    // Systolic pattern: pass value from the right
    .clk(clk),
    .rst(rst),
    .a_out(a_reg10),
    .b_out(b_reg10),
    .c_out(c10)
);



// Instantiate the fourth PE for C(1,1)
systolic_unit pe11(
    .a(a_reg10),
    .b(b_reg01),  
    .clk(clk),
    .rst(rst),
    .a_out(a_reg11),
    .b_out(b_reg11),
    .c_out(c11)
);

// Debugging print for PE11 output


endmodule
