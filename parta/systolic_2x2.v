module systolic_matrix_mul_2x2(
    input wire clk,              // Clock signal
    input wire rst               // Reset signal
);

// Control Signals
reg ena, wea;
reg [2:0] addra;
wire [31:0] dina;

// Input/Output Wires
wire [31:0] a00, a01, b00, b01;
wire [31:0] c00, c01, c10, c11;
wire [31:0]a_reg00,b_reg00,a_reg01,b_reg01,a_reg10,b_reg10,a_reg11,b_reg11;

// Initial Settings
initial begin
    ena = 1;
    wea = 0;
    addra = 3'b000;
end

// Increment address on each clock cycle, reset when rst is high
always @(posedge clk or posedge rst) begin
    if (rst) begin
        addra <= 3'b000;
    end else if(addra<3'b110)begin
        addra <= addra + 1;    
    end
end

// Memory Blocks
blk_mem_gen_0 mtrixa1 (
    .clka(clk), .ena(ena), .wea(wea), .addra(addra), .dina(dina), .douta(a00)
);

blk_mem_gen_0 mtrixb1 (
    .clka(clk), .ena(ena), .wea(wea), .addra(addra), .dina(dina), .douta(b00)
);

blk_mem_gen_1 matrixa2 (
    .clka(clk), .ena(ena), .wea(wea), .addra(addra), .dina(dina), .douta(a01)
);

blk_mem_gen_1 matrixb2 (
    .clka(clk), .ena(ena), .wea(wea), .addra(addra), .dina(dina), .douta(b01)
);

// Instantiate PE Units for Systolic Array
systolic_unit pe00(.a(a00), .b(b00), .clk(clk), .rst(rst), .a_out(a_reg00), .b_out(b_reg00), .c_out(c00));
systolic_unit pe01(.a(a_reg00), .b(b01), .clk(clk), .rst(rst), .a_out(a_reg01), .b_out(b_reg01), .c_out(c01));
systolic_unit pe10(.a(a01), .b(b_reg00), .clk(clk), .rst(rst), .a_out(a_reg10), .b_out(b_reg10), .c_out(c10));
systolic_unit pe11(.a(a_reg10), .b(b_reg01), .clk(clk), .rst(rst), .a_out(a_reg11), .b_out(b_reg11), .c_out(c11));

// Debugging Module for Signal Probing
ila_0 your_instance_name (
    .clk(clk), .probe0(a00), .probe1(a01), .probe2(b00), .probe3(c00),
    .probe4(c01), .probe5(c10), .probe6(c11), .probe7(rst)
);

//ila_1 ila2 (
//	.clk(clk), // input wire clk

    
//	.probe0(a_reg00), // input wire [31:0]  probe0  
//	.probe1(b_reg00), // input wire [31:0]  probe1 
//	.probe2(a_reg01), // input wire [31:0]  probe2 
//	.probe3(b_reg01), // input wire [31:0]  probe3 
//	.probe4(a_reg10), // input wire [31:0]  probe4 
//	.probe5(b_reg10), // input wire [31:0]  probe5 
//	.probe6(a_reg11), // input wire [31:0]  probe6 
//	.probe7(rst) // input wire [0:0]  probe7
//);

endmodule