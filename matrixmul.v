module systolic_array(
    input reset,
    input clk, 
    input [7:0] a[3:0][3:0],
    input [7:0] b[3:0][3:0],
    output reg [15:0] res[3:0][3:0]
);

    wire [8:0] a_data; 
    wire [8:0] b_data; 
    wire [15:0] result; 

    integer i, j;

    reg [3:0] stage; 

    mac my_mac (
        .reset(reset),
        .a(a_data),
        .b(b_data),
        .result(result)
    );


    always @(posedge reset) begin
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                res[i][j] <= 16'b0;
            end
        end
        stage <= 4'b0000; 
    end


    always @(posedge clk) begin
        if (!reset) begin
            case (stage)
                //stage 1
                4'b0000: begin
                    res[0][0] <= my_mac(res[0][0], a[0][0], b[0][0]);
                    stage <= stage + 1;
                end
                //stage 2
                4'b0001: begin
                    res[0][0] <= my_mac(res[0][0], a[0][1], b[1][0]);
                    res[0][1] <= my_mac(res[0][1], a[0][0], b[0][1]);
                    res[1][0] <= my_mac(res[1][0], a[1][0], b[0][0]);
                    stage <= stage + 1;
                end
                //stage 3
                4'b0010: begin
                    res[0][0] <= my_mac(res[0][0], a[0][2], b[2][0]);
                    res[0][1] <= my_mac(res[0][1], a[0][1], b[1][1]);
                    res[0][2] <= my_mac(res[0][2], a[0][0], b[0][2]);
                    res[1][0] <= my_mac(res[1][0], a[1][1], b[0][1]);
                    res[2][0] <= my_mac(res[2][0], a[2][0], b[0][0]);
                    res[1][1] <= my_mac(res[1][1], a[1][0], b[0][1]);
                    stage <= stage + 1;
                end
                //stage 4
                4'b0011: begin
                    res[0][0] <= my_mac(res[0][0], a[0][3], b[3][0]);
                    res[0][1] <= my_mac(res[0][1], a[0][2], b[2][1]);
                    res[0][2] <= my_mac(res[0][2], a[0][1], b[1][2]);
                    res[0][3] <= my_mac(res[0][3], a[0][0], b[0][3]);
                    res[1][0] <= my_mac(res[1][0], a[1][2], b[0][2]);
                    res[1][1] <= my_mac(res[1][1], a[1][1], b[1][1]);
                    res[1][2] <= my_mac(res[1][2], a[1][0], b[0][2]);
                    res[2][0] <= my_mac(res[2][0], a[2][1], b[0][1]);
                    res[2][1] <= my_mac(res[2][1], a[2][0], b[0][2]);
                    res[3][0] <= my_mac(res[3][0], a[3][0], b[0][0]); 

                    stage <= 4'b0000; 
                end
                //stage 5
                4'b0100: begin
                    res[0][1] <= my_mac(res[0][1], a[0][3], b[3][1]);
                    res[0][2] <= my_mac(res[0][2], a[0][2], b[2][2]);
                    res[0][3] <= my_mac(res[0][3], a[0][1], b[1][3]);
                    res[1][0] <= my_mac(res[1][0], a[1][3], b[3][0]);
                    res[1][1] <= my_mac(res[1][1], a[1][2], b[2][1]);
                    res[1][2] <= my_mac(res[1][2], a[1][1], b[1][2]);
                    res[1][3] <= my_mac(res[1][3], a[1][0], b[0][3]);
                    res[2][0] <= my_mac(res[2][0], a[2][2], b[2][0]);
                    res[2][1] <= my_mac(res[2][1], a[2][1], b[1][1]);
                    res[2][2] <= my_mac(res[2][2], a[2][0], b[0][2]);
                    res[3][0] <= my_mac(res[3][0], a[3][1], b[1][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][0], b[0][1]);
                    stage <= stage + 1;
                end
                //stage 6
                4'b0101: begin
                    res[0][2] <= my_mac(res[0][2], a[0][3], b[3][2]);
                    res[0][3] <= my_mac(res[0][3], a[0][2], b[2][3]);
                    res[1][0] <= my_mac(res[1][0], a[1][3], b[3][1]);
                    res[1][1] <= my_mac(res[1][1], a[1][2], b[2][2]);
                    res[1][2] <= my_mac(res[1][2], a[1][1], b[1][3]);
                    res[2][0] <= my_mac(res[2][0], a[2][3], b[3][0]);
                    res[2][1] <= my_mac(res[2][1], a[2][2], b[2][1]);
                    res[2][2] <= my_mac(res[2][2], a[2][1], b[1][2]);
                    res[2][3] <= my_mac(res[2][3], a[2][0], b[0][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][2], b[2][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][1], b[1][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][0], b[0][2]);
                    stage <= stage + 1;
                end
                //stage 7
                4'b0110: begin
                    res[0][3] <= my_mac(res[0][3], a[0][3], b[3][3]);
                    res[1][0] <= my_mac(res[1][0], a[1][3], b[3][2]);
                    res[1][1] <= my_mac(res[1][1], a[1][2], b[2][3]);
                    res[2][0] <= my_mac(res[2][0], a[2][3], b[3][1]);
                    res[2][1] <= my_mac(res[2][1], a[2][2], b[2][2]);
                    res[2][2] <= my_mac(res[2][2], a[2][1], b[1][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][3], b[3][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][2], b[2][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][1], b[1][2]);
                    res[3][3] <= my_mac(res[3][3], a[3][0], b[0][3]);
                    stage <= stage + 1;
                end
                //stage 8
                4'b0111: begin
                    res[1][1] <= my_mac(res[1][1], a[1][3], b[3][1]);
                    res[1][2] <= my_mac(res[1][2], a[1][2], b[2][2]);
                    res[1][3] <= my_mac(res[1][3], a[1][1], b[1][3]);
                    res[2][0] <= my_mac(res[2][0], a[2][3], b[3][0]);
                    res[2][1] <= my_mac(res[2][1], a[2][2], b[2][1]);
                    res[2][2] <= my_mac(res[2][2], a[2][1], b[1][2]);
                    res[2][3] <= my_mac(res[2][3], a[2][0], b[0][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][2], b[2][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][1], b[1][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][0], b[0][2]);
                    stage <= stage + 1;
                end
                //stage 9
                4'b1000: begin
                    res[1][2] <= my_mac(res[1][2], a[1][3], b[3][2]);
                    res[1][3] <= my_mac(res[1][3], a[1][2], b[2][3]);
                    res[2][0] <= my_mac(res[2][0], a[2][3], b[3][1]);
                    res[2][1] <= my_mac(res[2][1], a[2][2], b[2][2]);
                    res[2][2] <= my_mac(res[2][2], a[2][1], b[1][3]);
                    res[2][3] <= my_mac(res[2][3], a[2][0], b[0][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][3], b[3][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][2], b[2][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][1], b[1][2]);
                    res[3][3] <= my_mac(res[3][3], a[3][0], b[0][3]);
                    stage <= stage + 1;
                end
                //stage 10
                4'b1001: begin
                    res[1][3] <= my_mac(res[1][3], a[1][3], b[3][3]);
                    res[2][0] <= my_mac(res[2][0], a[2][3], b[3][2]);
                    res[2][1] <= my_mac(res[2][1], a[2][2], b[2][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][3], b[3][1]);
                    res[3][1] <= my_mac(res[3][1], a[3][2], b[2][2]);
                    res[3][2] <= my_mac(res[3][2], a[3][1], b[1][3]);
                    res[3][3] <= my_mac(res[3][3], a[3][0], b[0][3]);
                    stage <= stage + 1;
                end
                //stage 11
                4'b1010: begin
                    res[2][1] <= my_mac(res[2][1], a[2][3], b[3][1]);
                    res[2][2] <= my_mac(res[2][2], a[2][2], b[2][2]);
                    res[2][3] <= my_mac(res[2][3], a[2][1], b[1][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][2], b[2][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][1], b[1][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][0], b[0][2]);
                    stage <= stage + 1;
                end
                //stage 12
                4'b1011: begin
                    res[2][2] <= my_mac(res[2][2], a[2][3], b[3][2]);
                    res[2][3] <= my_mac(res[2][3], a[2][2], b[2][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][3], b[3][0]);
                    res[3][1] <= my_mac(res[3][1], a[3][2], b[2][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][1], b[1][2]);
                    res[3][3] <= my_mac(res[3][3], a[3][0], b[0][3]);
                    stage <= stage + 1;
                end
                //stage 13
                4'b1100: begin
                    res[2][3] <= my_mac(res[2][3], a[2][3], b[3][3]);
                    res[3][0] <= my_mac(res[3][0], a[3][3], b[3][1]);
                    res[3][1] <= my_mac(res[3][1], a[3][2], b[2][2]);
                    res[3][2] <= my_mac(res[3][2], a[3][1], b[1][3]);
                    res[3][3] <= my_mac(res[3][3], a[3][0], b[0][3]);
                    stage <= stage + 1;
                end
                //stage 14
                4'b1101: begin
                    res[3][1] <= my_mac(res[3][1], a[3][3], b[3][1]);
                    res[3][2] <= my_mac(res[3][2], a[3][2], b[2][2]);
                    res[3][3] <= my_mac(res[3][3], a[3][1], b[1][3]);
                    stage <= stage + 1;
                end
                //stage 15
                4'b1110: begin
                    res[3][2] <= my_mac(res[3][2], a[3][3], b[3][2]);
                    res[3][3] <= my_mac(res[3][3], a[3][2], b[2][3]);
                    stage <= stage + 1;
                end
                //stage 16
                4'b1111: begin
                    res[3][3] <= my_mac(res[3][3], a[3][3], b[3][3]);
                    stage <= 4'b0000; 
                end
                default: stage <= 4'b0000; 

            endcase
        end
    end

endmodule
