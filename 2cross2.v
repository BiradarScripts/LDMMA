`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 19:33:26
// Design Name: 
// Module Name: systolicarray
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module systoicarray(
    input clk,
    input reset
);
    

    reg ena, wea;
    reg [1:0] addra;
    wire [47:0] dina;

    wire [47:0] a_elem;
    wire [47:0] b_elem;
    

    reg [31:0] c11, c12, c21, c22;
    wire [31:0] temp;
    
    reg [15:0] a11, a12, a21, a22;
    reg [15:0] b11, b12, b21, b22;
    
    reg [31:0] temp_c11, temp_c12, temp_c21, temp_c22;
    
    reg [1:0] state;
    
    initial begin
        ena = 1;
        wea = 0;
        addra = 2'b00;
        state = 2'b00; 
    end
    
    vio_0 your_instance_name (
      .clk(clk),                // input wire clk
      .probe_in0(temp),    // input wire [31 : 0] probe_in0
      .probe_in1(c11),    // input wire [31 : 0] probe_in1
      .probe_in2(c12),    // input wire [31 : 0] probe_in2
      .probe_in3(c21),    // input wire [31 : 0] probe_in3
      .probe_out0(c22)  // output wire [0 : 0] probe_out0
);
    

    blk_mem_gen_0 matrixa (
      .clka(clk),    // input wire clka
      .ena(ena),     // input wire ena
      .wea(wea),     // input wire [0 : 0] wea
      .addra(addra), // input wire [1 : 0] addra
      .dina(dina),   // input wire [47 : 0] dina
      .douta(a_elem) // output wire [47 : 0] douta
    );
    
    blk_mem_gen_0 matrixb (
      .clka(clk),    // input wire clka
      .ena(ena),     // input wire ena
      .wea(wea),     // input wire [0 : 0] wea
      .addra(addra), // input wire [1 : 0] addra
      .dina(dina),   // input wire [47 : 0] dina
      .douta(b_elem) // output wire [47 : 0] douta
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            c11 <= 32'd0;
            c12 <= 32'd0;
            c21 <= 32'd0;
            c22 <= 32'd0;
            addra <= 2'b00;
            state <= 2'b00;
            
            temp_c11 <= 32'd0;
            temp_c12 <= 32'd0;
            temp_c21 <= 32'd0;
            temp_c22 <= 32'd0;
        end else begin
            case (state)
                2'b00: begin
                    
                    a11 <= a_elem[47:32]; 
                    b11 <= b_elem[47:32]; 
                    temp_c11 <= a11 * b11; 
                    state <= 2'b01;
                end
                
                2'b01: begin
                    a11 <= a_elem[47:32]; 
                    a12 <= a_elem[31:16]; 
                    a21 <= a_elem[15:0];  
                    b11 <= b_elem[47:32]; 
                    b12 <= b_elem[31:16]; 
                    b21 <= b_elem[15:0];  
                    
                    temp_c11 <= temp_c11 + a11 * b11; 
                    temp_c12 <= a12 * b12;            
                    temp_c21 <= a21 * b21;           
                    state <= 2'b10;
                end
                
                2'b10: begin
              
                    a12 <= a_elem[47:32]; 
                    a21 <= a_elem[31:16]; 
                    a22 <= a_elem[15:0];  
                    b12 <= b_elem[47:32];
                    b21 <= b_elem[31:16];
                    b22 <= b_elem[15:0]; 
                    
                    temp_c12 <= temp_c12 + a12 * b12; 
                    temp_c21 <= temp_c21 + a21 * b21; 
                    temp_c22 <= a22 * b22;           
                    state <= 2'b11;
                end
                
                2'b11: begin
                    a22 <= a_elem[47:32]; 
                    b22 <= b_elem[47:32]; 
                    
                    temp_c22 <= temp_c22 + a22 * b22; 
                    
                    c11 <= temp_c11; 
                    c12 <= temp_c12; 
                    c21 <= temp_c21; 
                    c22 <= temp_c22; 
                    
                    state <= 2'b00;
                end
            endcase
        end
    end
    
endmodule
