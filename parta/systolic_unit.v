module systolic_unit(
    input wire [31:0] a,       // 32-bit input 'a'
    input wire [31:0] b,       // 32-bit input 'b'     
    input wire clk,            // Clock signal
    input wire rst,            // Reset signal
    output reg [31:0] a_out,   // 32-bit output 'a'
    output reg [31:0] b_out,   // 32-bit output 'b'
    output reg [31:0] c_out    // 32-bit output 'c'
);

// Internal register to store the updated 'c'
reg [31:0] c_reg;
initial
begin
c_reg = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the values to 0 on reset
        a_out <= 0;
        b_out <= 0;
        c_out <= 0;
        c_reg <= 0;
    end else begin
        // Update 'c' and output the values
<<<<<<< HEAD
        c_reg <= c + a*b;
=======
        c_reg <= c_reg + a*b;
>>>>>>> 226a27df1f3c31561291f7623bcd4507757c119e
        a_out <= a;
        b_out <= b;
        c_out <= c_reg;
    end
end

endmodule
