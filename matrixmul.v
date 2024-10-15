module systolic_array(
    input reset,
    input clk
);

    wire [7:0]a[3:0][3:0];
    wire [7:0]b[3:0][3:0];
    reg [15:0]res[3:0][3:0];
    
    reg [7:0] a_data1; 
    reg [7:0] b_data1;
    reg [7:0] a_data2;
    reg [7:0] b_data2;
    reg [7:0] a_data3;
    reg [7:0] b_data3;
    reg [7:0] a_data4;
    reg [7:0] b_data4;
    reg [7:0] a_data5;
    reg [7:0] b_data5;
    reg [7:0] a_data6;
    reg [7:0] b_data6;
    reg [7:0] a_data7;
    reg [7:0] b_data7;
    reg [7:0] a_data8;
    reg [7:0] b_data8;
    reg [7:0] a_data9;
    reg [7:0] b_data9;
    reg [7:0] a_data10;
    reg [7:0] b_data10;
    reg [7:0] a_data11;
    reg [7:0] b_data11;
    reg [7:0] a_data12;
    reg [7:0] b_data12;
    wire [15:0] result1;
    wire [15:0] result2;
    wire [15:0] result3;
    wire [15:0] result4;
    wire [15:0] result5;
    wire [15:0] result6;
    wire [15:0] result7;
    wire [15:0] result8;
    wire [15:0] result9;
    wire [15:0] result10;
    wire [15:0] result11;
    wire [15:0] result12;
    integer i, j;

    reg [3:0] stage; 

    mac my_mac (
        .clk(clk),
        .reset(reset),
        .a(a_data1),
        .b(b_data1),
        .result(result1)
    );

    mac my_mac2 (
        .clk(clk),
        .reset(reset),
        .a(a_data2),
        .b(b_data2),
        .result(result2)
    );

    mac my_mac3 (
        .clk(clk),
        .reset(reset),
        .a(a_data3),
        .b(b_data3),
        .result(result3)
    );

    mac my_mac4 (
        .clk(clk),
        .reset(reset),
        .a(a_data4),
        .b(b_data4),
        .result(result4)
    );

    mac my_mac5 (
        .clk(clk),
        .reset(reset),
        .a(a_data5),
        .b(b_data5),
        .result(result5)
    );

    mac my_mac6 (
        .clk(clk),
        .reset(reset),
        .a(a_data6),
        .b(b_data6),
        .result(result6)
    );

    mac my_mac7 (
        .clk(clk),
        .reset(reset),
        .a(a_data7),
        .b(b_data7),
        .result(result7)
    );

    mac my_mac8 (
        .clk(clk),
        .reset(reset),
        .a(a_data8),
        .b(b_data8),
        .result(result8)
    );

    mac my_mac9 (
        .clk(clk),
        .reset(reset),
        .a(a_data9),
        .b(b_data9),
        .result(result9)
    );

    mac my_mac10 (
        .clk(clk),
        .reset(reset),
        .a(a_data10),
        .b(b_data10),
        .result(result10)
    );

    mac my_mac11 (
        .clk(clk),
        .reset(reset),
        .a(a_data11),
        .b(b_data11),
        .result(result11)
    );

    mac my_mac12 (
        .clk(clk),
        .reset(reset),
        .a(a_data12),
        .b(b_data12),
        .result(result12)
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
                    a_data1<=a[0][0];
                    b_data1<=b[0][0];
                    res[0][0] <= res[0][0] +result1;
                    stage <= stage + 1;
                end
                //stage 2
                4'b0001: begin
                    a_data2<=a[0][1];
                    b_data2<=b[1][0];
                    a_data3<=a[0][0];
                    b_data3<=b[0][1];
                    a_data4<=a[1][0];
                    b_data4<=b[0][0];
                    res[0][0] <= res[0][0] +result2;
                    res[0][1] <= res[0][1]+result3;
                    res[1][0] <=res[1][0]+ result4;
                    stage <= stage + 1;
                end
                //stage 3
                4'b0010: begin
                    a_data1<=a[0][2];
                    b_data1<=b[2][0];
                    a_data2<=a[0][1];
                    b_data2<=b[1][1];
                    a_data3<=a[0][0];
                    b_data3<=b[0][2];
                    a_data4<=a[1][1];
                    b_data4<=b[0][1];
                    a_data5<=a[2][0];
                    b_data5<=b[0][0];
                    a_data6<=a[1][0];
                    b_data6<=b[0][1];
                    res[0][0] <=res[0][0]+ result1;
                    res[0][1] <= res[0][1] +result2;
                    res[0][2] <= res[0][2]+result3;
                    res[1][0] <=res[1][0]+ result4;
                    res[2][0] <=res[2][0]+ result5;
                    res[1][1] <=res[1][1]+ result6;

                    stage <= stage + 1;
                end
                //stage 4
                4'b0011: begin
                    a_data1<=a[0][3];
                    b_data1<=b[3][0];
                    a_data2<=a[0][2];
                    b_data2<=b[2][1];
                    a_data3<=a[0][1];
                    b_data3<=b[1][2];
                    a_data4<=a[0][0];
                    b_data4<=b[0][3];
                    a_data5<=a[1][2];
                    b_data5<=b[0][2];
                    a_data6<=a[1][1];
                    b_data6<=b[1][1];
                    a_data7<=a[1][0];
                    b_data7<=b[0][2];
                    a_data8<=a[2][1];
                    b_data8<=b[0][1];
                    a_data9<=a[2][0];
                    b_data9<=b[0][2];
                    a_data10<=a[3][0];
                    b_data10<=b[0][0];
                    res[0][0] <=res[0][0]+ result1;
                    res[0][1] <=res[0][1]+ result2;
                    res[0][2] <=res[0][2]+ result3;
                    res[0][3] <=res[0][3]+ result4;
                    res[1][0] <=res[1][0]+ result5;
                    res[1][1] <=res[1][1] + result6;
                    res[1][2] <=res[1][2]+ result7;
                    res[2][0]<=res[2][0]+result8;
                    res[2][1]<=res[2][1]+result9;
                    res[3][0]<=res[3][0]+result10;

                    stage <= 4'b0000; 
                end
                //stage 5
                4'b0100: begin
                    a_data1<=a[0][3];
                    b_data1<=b[3][1];
                    a_data2<=a[0][2];
                    b_data2<=b[2][2];
                    a_data3<=a[0][1];
                    b_data3<=b[1][3];
                    a_data4<=a[1][3];
                    b_data4<=b[3][0];
                    a_data5<=a[1][2];
                    b_data5<=b[2][1];
                    a_data6<=a[1][1];
                    b_data6<=b[1][2];
                    a_data7<=a[1][0];
                    b_data7<=b[0][3];
                    a_data8<=a[2][2];
                    b_data8<=b[2][0];
                    a_data9<=a[2][1];
                    b_data9<=b[1][1];
                    a_data10<=a[2][0];
                    b_data10<=b[0][2];
                    a_data11<=a[3][1];
                    b_data11<=b[1][0];
                    a_data12<=a[3][0];
                    b_data12<=b[0][1];
                    res[0][1] <=res[0][1]+ result1;
                    res[0][2] <=res[0][2]+ result2;
                    res[0][3] <=res[0][3]+ result3;
                    res[1][0] <=res[1][0]+ result4;
                    res[1][1] <=res[1][1]+ result5;
                    res[1][2] <=res[1][2]+ result6;
                    res[1][3] <=res[1][3]+ result7;
                    res[2][0] <=res[2][0]+ result8;
                    res[2][1] <=res[2][1]+ result9;
                    res[2][2] <=res[2][2]+ result10;
                    res[3][0] <=res[3][0]+ result11;
                    res[3][1] <=res[3][1]+ result12;
                
                    stage <= stage + 1;
                end
                //stage 6
                4'b0101: begin
                    a_data1<=a[0][3];
                    b_data1<=b[3][2];
                    a_data2<=a[0][2];
                    b_data2<=b[2][3];
                    a_data3<=a[1][3];
                    b_data3<=b[3][1];
                    a_data4<=a[1][2];
                    b_data4<=b[2][2];
                    a_data5<=a[1][1];
                    b_data5<=b[1][3];
                    a_data6<=a[2][3];
                    b_data6<=b[3][0];
                    a_data7<=a[2][2];
                    b_data7<=b[2][1];
                    a_data8<=a[2][1];
                    b_data8<=b[1][2];
                    a_data9<=a[2][0];
                    b_data9<=b[0][3];
                    a_data10<=a[3][2];
                    b_data10<=b[2][0];
                    a_data11<=a[3][1];
                    b_data11<=b[1][1];
                    a_data12<=a[3][0];
                    b_data12<=b[0][2];
                    res[0][2] <=res[0][2]+ result1;
                    res[0][2] <=res[0][3]+ result2;
                    res[1][0] <=res[1][0]+ result3;
                    res[1][1] <=res[1][1]+ result4;
                    res[1][2] <=res[1][2]+ result5;
                    res[2][0] <=res[2][0]+ result6;
                    res[2][1] <=res[2][1]+ result7;
                    res[2][2] <= res[2][2]+ result8;
                    res[2][3] <=res[2][3]+ result9;
                    res[3][0] <=res[3][0]+ result10;
                    res[3][1] <=res[3][1]+ result11;
                    res[3][2] <=res[3][2]+ result12;


                    stage <= stage + 1;
                end
                //stage 7
                4'b0110: begin
                    a_data1<=a[0][3];
                    b_data1<=b[3][3];

                    a_data2<=a[1][3];
                    b_data2<=b[3][2];
                    a_data3<=a[1][2];
                    b_data3<=b[2][3];
                    a_data4<=a[2][3];
                    b_data4<=b[3][1];
                    a_data5<=a[2][2];
                    b_data5<=b[2][2];
                    a_data6<=a[2][1];
                    b_data6<=b[1][3];
                    a_data7<=a[3][3];
                    b_data7<=b[3][0];
                    a_data8<=a[3][2];
                    b_data8<=b[2][1];
                    a_data9<=a[3][1];
                    b_data9<=b[1][2];
                    a_data10<=a[3][0];
                    b_data10<=b[0][3];
                    res[0][3] <=res[0][3]+ result1;
                    res[1][0] <=res[1][0]+ result2;
                    res[1][1] <=res[1][1]+ result3;
                    res[2][0] <=res[2][0]+ result4;
                    res[2][1] <=res[2][1]+ result5;
                    res[2][2] <=res[2][2]+ result6;
                    res[3][0] <= res[3][0]+ result7;
                    res[3][1] <=res[3][1]+ result8;
                    res[3][2] <=res[3][2]+ result9;
                    res[3][3] <=res[3][3]+ result10;


                    stage <= stage + 1;
                end
                //stage 8
                4'b0111: begin

                    a_data1<=a[1][3];
                    b_data1<=b[3][1];
                    a_data2<=a[1][2];
                    b_data2<=b[2][2];
                    a_data3<=a[1][1];
                    b_data3<=b[1][3];
                    a_data4<=a[2][3];
                    b_data4<=b[3][0];
                    a_data5<=a[2][2];
                    b_data5<=b[2][1];
                    a_data6<=a[2][1];
                    b_data6<=b[1][2];
                    a_data7<=a[2][0];
                    b_data7<=b[0][3];
                    a_data8<=a[3][2];
                    b_data8<=b[2][0];
                    a_data9<=a[3][1];
                    b_data9<=b[1][1];
                    a_data10<=a[3][0];
                    b_data10<=b[0][2];
                    res[1][1] <=res[1][1]+ result1;
                    res[1][2] <=res[1][2]+ result2;
                    res[1][3] <=res[1][3]+ result3;
                    res[2][0] <=res[2][0]+ result4;
                    res[2][1] <=res[2][1]+ result5;
                    res[2][2] <=res[2][2]+ result6;
                    res[2][3] <=res[2][3]+ result7;
                    res[3][0] <=res[3][0]+ result8;
                    res[3][1] <=res[3][1]+ result9;
                    res[3][2] <=res[3][2]+ result10;


                    stage <= stage + 1;
                end
                //stage 9
                4'b1000: begin
                    a_data1<=a[1][3];
                    b_data1<=b[3][2];
                    a_data2<=a[1][2];
                    b_data2<=b[2][3];
                    a_data3<=a[2][3];
                    b_data3<=b[3][1];
                    a_data4<=a[2][2];
                    b_data4<=b[2][2];
                    a_data5<=a[2][1];
                    b_data5<=b[1][3];
                    a_data6<=a[2][0];
                    b_data6<=b[0][3];
                    a_data7<=a[3][3];
                    b_data7<=b[3][0];
                    a_data8<=a[3][2];
                    b_data8<=b[2][1];
                    a_data9<=a[3][1];
                    b_data9<=b[1][2];
                    a_data10<=a[3][0];
                    b_data10<=b[0][3];

                    res[1][2] <=res[1][2]+ result1;
                    res[1][3] <=res[1][3]+ result2;
                    res[2][0] <=res[2][0]+ result3;
                    res[2][1] <=res[2][1]+ result4;
                    res[2][2] <=res[2][2]+ result5;
                    res[2][3] <=res[2][3]+ result6;
                    res[3][0] <=res[3][0]+ result7;
                    res[3][1] <=res[3][1]+ result8;
                    res[3][2] <=res[3][2]+ result9;
                    res[3][3] <=res[3][3]+ result10;

                    stage <= stage + 1;
                end
                //stage 10
                4'b1001: begin
                    a_data1<=a[1][3];
                    b_data1<=b[3][3];
                    a_data2<=a[2][3];
                    b_data2<=b[3][2];
                    a_data3<=a[2][2];
                    b_data3<=b[2][3];
                    a_data4<=a[3][3];
                    b_data4<=b[3][1];
                    a_data5<=a[3][2];
                    b_data5<=b[2][2];
                    a_data6<=a[3][1];
                    b_data6<=b[1][3];
                    a_data7<=a[3][0];
                    b_data7<=b[0][3];

                    res[1][3] <=res[1][3]+ result1;
                    res[2][0] <=res[2][0]+ result2;
                    res[2][1] <=res[2][1]+ result3;
                    res[3][0] <=res[3][0]+ result4;
                    res[3][1] <=res[3][1]+ result5;
                    res[3][2] <=res[3][2]+ result6;
                    res[3][3] <=res[3][3]+ result7;
                    stage <= stage + 1;
                end
                //stage 11
                4'b1010: begin
                    a_data1<=a[2][3];
                    b_data1<=b[3][1];
                    a_data2<=a[2][2];
                    b_data2<=b[2][2];
                    a_data3<=a[2][1];
                    b_data3<=b[1][3];
                    a_data4<=a[3][2];
                    b_data4<=b[2][0];
                    a_data5<=a[3][1];
                    b_data5<=b[1][1];
                    a_data6<=a[3][0];
                    b_data6<=b[0][2];

                    res[2][1] <=res[2][1]+ result1;
                    res[2][2] <=res[2][2] + result2;
                    res[2][3] <=res[2][3]+ result3;
                    res[3][0] <=res[3][0]+ result4;
                    res[3][1] <=res[3][1]+ result5;
                    res[3][2] <=res[3][2]+ result6;


                    stage <= stage + 1;
                end
                //stage 12
                4'b1011: begin
                    a_data1<=a[2][3];
                    b_data1<=b[3][2];
                    a_data2<=a[2][2];
                    b_data2<=b[2][3];
                    a_data3<=a[3][3];
                    b_data3<=b[3][0];
                    a_data4<=a[3][2];
                    b_data4<=b[2][1];
                    a_data5<=a[3][1];
                    b_data5<=b[1][2];
                    a_data6<=a[3][0];
                    b_data6<=b[0][3];

                    res[2][2] <=res[2][2]+ result1;
                    res[2][3] <=res[2][3]+ result2;
                    res[3][0] <=res[3][0]+ result3;
                    res[3][1] <=res[3][1]+ result4;
                    res[3][2] <=res[3][2]+ result5;
                    res[3][3] <=res[3][3]+ result6;
                    stage <= stage + 1;
                end
                //stage 13
                4'b1100: begin
                    a_data1<=a[2][3];
                    b_data1<=b[3][3];
                    a_data2<=a[3][3];
                    b_data2<=b[3][1];
                    a_data3<=a[3][2];
                    b_data3<=b[2][2];
                    a_data4<=a[3][1];
                    b_data4<=b[1][3];
                    a_data5<=a[3][0];
                    b_data5<=b[0][3];

                    res[2][3] <=res[2][3]+ result1;
                    res[3][0] <=res[3][0]+ result2;
                    res[3][1] <=res[3][1]+ result3;
                    res[3][2] <=res[3][2]+ result4;
                    res[3][3] <=res[3][3]+ result5;


                    stage <= stage + 1;
                end
                //stage 14
                4'b1101: begin
                    a_data1<=a[3][3];
                    b_data1<=b[3][1];
                    a_data2<=a[3][2];
                    b_data2<=b[2][2];
                    a_data3<=a[3][1];
                    b_data3<=b[1][3];

                    res[3][1] <= res[3][1]+ result1;
                    res[3][2] <=res[3][2] + result2;
                    res[3][3] <=res[3][3]+ result3;

                    stage <= stage + 1;
                end
                //stage 15
                4'b1110: begin
                    a_data1<=a[3][3];
                    b_data1<=b[3][2];
                    a_data2<=a[3][2];
                    b_data2<=b[2][3];

                    res[3][2] <=res[3][2]+ result1;
                    res[3][3] <=res[3][3]+ result2;

                    stage <= stage + 1;
                end
                //stage 16
                4'b1111: begin
                    a_data1<=a[3][3];
                    b_data1<=b[3][3];

                    res[3][3] <=res[3][3]+ result1;
                    stage <= 4'b0000; 
                end
                default: stage <= 4'b0000; 

            endcase
        end
    end

endmodule