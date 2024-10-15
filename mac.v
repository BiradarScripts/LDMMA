module mac (   
    input wire clk,          // Added clock signal
    input wire reset,        
    input wire [7:0] a,      
    input wire [7:0] b,      
    output reg [15:0] result 
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 16'b0;  // Reset the result
        end else begin
            result <= result + (a * b);  // Accumulate a * b on each clock cycle
        end
    end
endmodule
