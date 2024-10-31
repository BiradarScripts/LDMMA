`timescale 1ns / 1ps

module top_controller(
    input   i_clk_100M,
            i_uart_rx,
    
    output  [7:0] cathodes,
            [3:0] anodes
);

    localparam  N_DATA_BITS = 8,
                OVERSAMPLE = 13;
                
    localparam integer UART_CLOCK_DIVIDER = 64;
    localparam integer MAJORITY_START_IDX = 4;
    localparam integer MAJORITY_END_IDX = 8;
    localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);
    
    wire reset;
    
    reg uart_clk;
    reg uart_en;
    reg [UART_CLOCK_DIVIDER_WIDTH-1:0] uart_divider_counter;
    reg display_data_update;
    reg [N_DATA_BITS-1:0] display_data;
    
    wire [N_DATA_BITS-1:0] uart_rx_data;
    wire uart_rx_data_valid;
    
    // Buffers for matrix A and B (each 128 bits)
    reg [127:0] matrix_a_buffer;
    reg [127:0] matrix_b_buffer;
    reg [4:0] byte_count; // Counts chunks received (0-31)
    
    // Matrix multiplication trigger
    reg trigger_mul;
    
    // 4x4 output from matrix multiplication (each output is 32 bits)
    wire [31:0] mul_result[0:3][0:3]; 
    
    // ILA instance for monitoring
   ila_0 ila_inst (
    .clk(uart_clk), // input wire clk
    // Unpacking Matrix A into separate 32-bit signals
    .probe0({matrix_a_buffer[127:120], matrix_a_buffer[119:112], matrix_a_buffer[111:104], matrix_a_buffer[103:96]}),  // A[0][0]
    .probe1({matrix_a_buffer[95:88], matrix_a_buffer[87:80], matrix_a_buffer[79:72], matrix_a_buffer[71:64]}),     // A[0][1]
    .probe2({matrix_a_buffer[63:56], matrix_a_buffer[55:48], matrix_a_buffer[47:40], matrix_a_buffer[39:32]}),     // A[1][0]
    .probe3({matrix_a_buffer[31:24], matrix_a_buffer[23:16], matrix_a_buffer[15:8], matrix_a_buffer[7:0]}),       // A[1][1]

    // Unpacking Matrix B into separate 32-bit signals
    .probe4({matrix_b_buffer[127:120], matrix_b_buffer[119:112], matrix_b_buffer[111:104], matrix_b_buffer[103:96]}),  // B[0][0]
    .probe5({matrix_b_buffer[95:88], matrix_b_buffer[87:80], matrix_b_buffer[79:72], matrix_b_buffer[71:64]}),     // B[0][1]
    .probe6({matrix_b_buffer[63:56], matrix_b_buffer[55:48], matrix_b_buffer[47:40], matrix_b_buffer[39:32]}),     // B[1][0]
    .probe7({matrix_b_buffer[31:24], matrix_b_buffer[23:16], matrix_b_buffer[15:8], matrix_b_buffer[7:0]}),       // B[1][1]

    // Unpacking Mul Result into 16 separate 32-bit signals
    .probe8(mul_result[0][0]), // C[0][0]
    .probe9(mul_result[0][1]), // C[0][1]
    .probe10(mul_result[0][2]), // C[0][2]
    .probe11(mul_result[0][3]), // C[0][3]
    .probe12(mul_result[1][0]), // C[1][0]
    .probe13(mul_result[1][1]), // C[1][1]
    .probe14(mul_result[1][2]), // C[1][2]
    .probe15(mul_result[1][3]), // C[1][3]
    .probe16(mul_result[2][0]), // C[2][0]
    .probe17(mul_result[2][1]), // C[2][1]
    .probe18(mul_result[2][2]), // C[2][2]
    .probe19(mul_result[2][3]), // C[2][3]
    .probe20(mul_result[3][0]), // C[3][0]
    .probe21(mul_result[3][1]), // C[3][1]
    .probe22(mul_result[3][2]), // C[3][2]
    .probe23(mul_result[3][3]), // C[3][3]
    .probe24(trigger_mul)      // Trigger flag
);


    // UART Clock Divider and Enable Control
    always @(posedge uart_clk) begin
        if (uart_divider_counter < (UART_CLOCK_DIVIDER-1))
            uart_divider_counter <= uart_divider_counter + 1;
        else
            uart_divider_counter <= 'd0;
    end
    
    always @(posedge uart_clk) begin
        uart_en <= (uart_divider_counter == 'd10); 
    end
    
    always @(posedge uart_clk)
        if(uart_rx_data_valid)
            display_data <= uart_rx_data;
    
    clk_wiz_0 clock_gen (
        .clk_out1(uart_clk),     // output clk_out1    = 162.209M
        .clk_in1(i_clk_100M)
    );
    

    // UART Receiver Module
    uart_rx #(
        .OVERSAMPLE(OVERSAMPLE),
        .N_DATA_BITS(N_DATA_BITS),
        .MAJORITY_START_IDX(MAJORITY_START_IDX),
        .MAJORITY_END_IDX(MAJORITY_END_IDX)
    ) rx_data (
        .i_clk(uart_clk),
        .i_en(uart_en),
        .i_reset(reset),
        .i_data(i_uart_rx),
        
        .o_data(uart_rx_data),
        .o_data_valid(uart_rx_data_valid)
    );
    
    seven_seg_drive #(
        .INPUT_WIDTH(N_DATA_BITS),
        .SEV_SEG_PRESCALAR(16)
    ) display (
        .i_clk(uart_clk),
        .number(display_data),
        .decimal_points(4'h0),
        .anodes(anodes),
        .cathodes(cathodes)
    );
    

    // Accumulate 8-bit data into 128-bit matrices (Matrix A and B)
    always @(posedge uart_clk) begin
        if (reset) begin
            matrix_a_buffer <= 128'b0;
            matrix_b_buffer <= 128'b0;
            byte_count <= 5'd0; // Reset chunk count
            trigger_mul <= 1'b0;
        end else if (uart_rx_data_valid) begin
            if (byte_count < 16) begin
                // Fill Matrix A (0-15)
                case (byte_count)
                    0: matrix_a_buffer[127:120] <= uart_rx_data; // A[0][0]
                    1: matrix_a_buffer[119:112] <= uart_rx_data; // A[0][1]
                    2: matrix_a_buffer[111:104] <= uart_rx_data; // A[0][2]
                    3: matrix_a_buffer[103:96]  <= uart_rx_data; // A[0][3]
                    4: matrix_a_buffer[95:88]   <= uart_rx_data; // A[1][0]
                    5: matrix_a_buffer[87:80]   <= uart_rx_data; // A[1][1]
                    6: matrix_a_buffer[79:72]   <= uart_rx_data; // A[1][2]
                    7: matrix_a_buffer[71:64]   <= uart_rx_data; // A[1][3]
                    8: matrix_a_buffer[63:56]   <= uart_rx_data; // A[2][0]
                    9: matrix_a_buffer[55:48]   <= uart_rx_data; // A[2][1]
                    10: matrix_a_buffer[47:40]  <= uart_rx_data; // A[2][2]
                    11: matrix_a_buffer[39:32]  <= uart_rx_data; // A[2][3]
                    12: matrix_a_buffer[31:24]  <= uart_rx_data; // A[3][0]
                    13: matrix_a_buffer[23:16]  <= uart_rx_data; // A[3][1]
                    14: matrix_a_buffer[15:8]   <= uart_rx_data; // A[3][2]
                    15: matrix_a_buffer[7:0]    <= uart_rx_data; // A[3][3]
                endcase
                byte_count <= byte_count + 1; // Increment the chunk count
            end else if (byte_count < 32) begin
                // Fill Matrix B (16-31)
                case (byte_count - 16)
                    0: matrix_b_buffer[127:120] <= uart_rx_data; // B[0][0]
                    1: matrix_b_buffer[119:112] <= uart_rx_data; // B[0][1]
                    2: matrix_b_buffer[111:104] <= uart_rx_data; // B[0][2]
                    3: matrix_b_buffer[103:96]  <= uart_rx_data; // B[0][3]
                    4: matrix_b_buffer[95:88]   <= uart_rx_data; // B[1][0]
                    5: matrix_b_buffer[87:80]   <= uart_rx_data; // B[1][1]
                    6: matrix_b_buffer[79:72]   <= uart_rx_data; // B[1][2]
                    7: matrix_b_buffer[71:64]   <= uart_rx_data; // B[1][3]
                    8: matrix_b_buffer[63:56]   <= uart_rx_data; // B[2][0]
                    9: matrix_b_buffer[55:48]   <= uart_rx_data; // B[2][1]
                    10: matrix_b_buffer[47:40]  <= uart_rx_data; // B[2][2]
                    11: matrix_b_buffer[39:32]  <= uart_rx_data; // B[2][3]
                    12: matrix_b_buffer[31:24]  <= uart_rx_data; // B[3][0]
                    13: matrix_b_buffer[23:16]  <= uart_rx_data; // B[3][1]
                    14: matrix_b_buffer[15:8]   <= uart_rx_data; // B[3][2]
                    15: matrix_b_buffer[7:0]    <= uart_rx_data; // B[3][3]
                endcase
                byte_count <= byte_count + 1; // Increment the chunk count
            end
            
            // Trigger multiplication after receiving 32 chunks
            if (byte_count == 31) begin
                trigger_mul <= 1'b1; // Set trigger flag for multiplication
            end
        end
    end

    // Matrix Multiplication Module
    systolic_matrix_mul_4x4 mul_inst (
    .clk(uart_clk),
    .a({matrix_a_buffer[127:120], matrix_a_buffer[119:112], matrix_a_buffer[111:104], matrix_a_buffer[103:96]}),  // A[0][0]
    .b({matrix_a_buffer[95:88], matrix_a_buffer[87:80], matrix_a_buffer[79:72], matrix_a_buffer[71:64]}),          // A[0][1]
    .c({matrix_a_buffer[63:56], matrix_a_buffer[55:48], matrix_a_buffer[47:40], matrix_a_buffer[39:32]}),          // A[1][0]
    .d({matrix_a_buffer[31:24], matrix_a_buffer[23:16], matrix_a_buffer[15:8], matrix_a_buffer[7:0]}),            // A[1][1]
    
    .e({matrix_b_buffer[127:120], matrix_b_buffer[119:112], matrix_b_buffer[111:104], matrix_b_buffer[103:96]}),  // B[0][0]
    .f({matrix_b_buffer[95:88], matrix_b_buffer[87:80], matrix_b_buffer[79:72], matrix_b_buffer[71:64]}),          // B[0][1]
    .g({matrix_b_buffer[63:56], matrix_b_buffer[55:48], matrix_b_buffer[47:40], matrix_b_buffer[39:32]}),          // B[1][0]
    .h({matrix_b_buffer[31:24], matrix_b_buffer[23:16], matrix_b_buffer[15:8], matrix_b_buffer[7:0]}),            // B[1][1]
    
    // Unpacking Result Matrix to Outputs
    .i(mul_result[0][0]),  // C[0][0]
    .j(mul_result[0][1]),  // C[0][1]
    .k(mul_result[0][2]),  // C[0][2]
    .l(mul_result[0][3]),  // C[0][3]
    .m(mul_result[1][0]),  // C[1][0]
    .n(mul_result[1][1]),  // C[1][1]
    .o(mul_result[1][2]),  // C[1][2]
    .p(mul_result[1][3]),  // C[1][3]
    .q(mul_result[2][0]),  // C[2][0]
    .r(mul_result[2][1]),  // C[2][1]
    .s(mul_result[2][2]),  // C[2][2]
    .t(mul_result[2][3]),  // C[2][3]
    .u(mul_result[3][0]),  // C[3][0]
    .v(mul_result[3][1]),  // C[3][1]
    .w(mul_result[3][2]),  // C[3][2]
    .x(mul_result[3][3])   // C[3][3]
);


endmodule


    