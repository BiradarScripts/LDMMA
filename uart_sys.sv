`timescale 1ns / 1ps

module top_controller(
    input   i_clk_100M,
            i_uart_rx,
            reset,
    
    output  [7:0] cathodes,
            [3:0] anodes
);

    localparam  N_DATA_BITS = 8,
                OVERSAMPLE = 13,
                BLOCK_RAM_SIZE = 10;
                
    localparam integer UART_CLOCK_DIVIDER = 64;
    localparam integer MAJORITY_START_IDX = 4;
    localparam integer MAJORITY_END_IDX = 8;
    localparam integer UART_CLOCK_DIVIDER_WIDTH = $clog2(UART_CLOCK_DIVIDER);
    
    reg uart_clk;
    reg uart_en;
    reg [UART_CLOCK_DIVIDER_WIDTH:0] uart_divider_counter;
    
    wire [N_DATA_BITS-1:0] uart_rx_data;
    wire uart_rx_data_valid;
    reg uart_rx_data_valid_delay;
    wire uart_rx_data_valid_pulse;
    
    reg [N_DATA_BITS-1:0] display_data;
    
    reg[5:0] write_counter;
    reg[3:0] ram_write_addr;
    reg[3:0] ram_read_addr;
    reg [31:0] ram_data_in;
    reg[5:0] counter;
    reg ram_we;
    reg read_mode;
    wire [31:0] ram_data_out0, ram_data_out1, ram_data_out2, ram_data_out3;
    wire [31:0] ram_data_outb0, ram_data_outb1, ram_data_outb2, ram_data_outb3;
    wire ena;
    
    
    reg [1:0] matrix_select; // Track which matrix we're loading (0 = first matrix, 1 = second matrix)
    
    assign ena = 1;
    wire zero;
    assign zero = 0;
    
    blk_mem_gen_0 ram0 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b00)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_out0)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_1 ram1 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b01)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_out1)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_2 ram2 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b10)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_out2)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_3 ram3 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b11)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_out3)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_4 ramb0 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b00)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_outb0)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_5 ramb1 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b01)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_outb1)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_6 ramb2 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b10)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_outb2)  // output wire [31 : 0] doutb
    );
    
    blk_mem_gen_7 ramb3 (
      .clka(uart_clk),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b11)),      // input wire [0 : 0] wea
      .addra(ram_write_addr),  // input wire [3 : 0] addra
      .dina(ram_data_in),    // input wire [31 : 0] dina
      .douta(),  // output wire [31 : 0] douta
      .clkb(i_clk_100M),    // input wire clkb
      .enb(ena),      // input wire enb
      .web(zero),      // input wire [0 : 0] web
      .addrb(ram_read_addr),  // input wire [3 : 0] addrb
      .dinb(),    // input wire [31 : 0] dinb
      .doutb(ram_data_outb3)  // output wire [31 : 0] doutb
    );
    
    
    
//    blk_mem_gen_0 ram0 (
//      .clka(uart_clk),    // input wire clka
//      .ena(ena),      // input wire ena
//      .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b00)),      // input wire [0 : 0] wea
//      .addra(read_mode ? ram_read_addr : ram_write_addr),  // input wire [3 : 0] addra
//      .dina(ram_data_in),    // input wire [31 : 0] dina
//      .douta(ram_data_out0)  // output wire [31 : 0] douta
//    );
      
//    blk_mem_gen_1 ram1 (
//        .clka(uart_clk),
//        .ena(ena),
//        .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b01)),
//        .addra(read_mode ? ram_read_addr : ram_write_addr),
//        .dina(ram_data_in),
//        .douta(ram_data_out1)
//    );
    
//    blk_mem_gen_2 ram2 (
//        .clka(uart_clk),
//        .ena(ena),
//        .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b10)),
//        .addra(read_mode ? ram_read_addr : ram_write_addr),
//        .dina(ram_data_in),
//        .douta(ram_data_out2)
//    );
    
//    blk_mem_gen_3 ram3 (
//        .clka(uart_clk),
//        .ena(ena),
//        .wea(ram_we && (matrix_select == 0) && (write_counter[1:0] == 2'b11)),
//        .addra(read_mode ? ram_read_addr : ram_write_addr),
//        .dina(ram_data_in),
//        .douta(ram_data_out3)
//    );
    
//    // block RAMs for matrix B
    
//    blk_mem_gen_4 ramb0 (
//      .clka(uart_clk),    // input wire clka
//      .ena(ena),      // input wire ena
//      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b00)),      // input wire [0 : 0] wea
//      .addra(read_mode ? ram_read_addr : ram_write_addr),  // input wire [3 : 0] addra
//      .dina(ram_data_in),    // input wire [31 : 0] dina
//      .douta(ram_data_outb0)  // output wire [31 : 0] douta
//    );
    
//    blk_mem_gen_5 ramb1 (
//      .clka(uart_clk),    // input wire clka
//      .ena(ena),      // input wire ena
//      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b01)),      // input wire [0 : 0] wea
//      .addra(read_mode ? ram_read_addr : ram_write_addr),  // input wire [3 : 0] addra
//      .dina(ram_data_in),    // input wire [31 : 0] dina
//      .douta(ram_data_outb1)  // output wire [31 : 0] douta
//    );
    
//    blk_mem_gen_6 ramb2 (
//      .clka(uart_clk),    // input wire clka
//      .ena(ena),      // input wire ena
//      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b10)),      // input wire [0 : 0] wea
//      .addra(read_mode ? ram_read_addr : ram_write_addr),  // input wire [3 : 0] addra
//      .dina(ram_data_in),    // input wire [31 : 0] dina
//      .douta(ram_data_outb2)  // output wire [31 : 0] douta
//    );
    
//    blk_mem_gen_7 ramb3 (
//      .clka(uart_clk),    // input wire clka
//      .ena(ena),      // input wire ena
//      .wea(ram_we && (matrix_select == 1) && (write_counter[1:0] == 2'b11)),      // input wire [0 : 0] wea
//      .addra(read_mode ? ram_read_addr : ram_write_addr),  // input wire [3 : 0] addra
//      .dina(ram_data_in),    // input wire [31 : 0] dina
//      .douta(ram_data_outb3)  // output wire [31 : 0] douta
//    );

    ila_0 input_monitor (
        .clk(uart_clk),
        .probe0(uart_rx_data_valid_pulse), // one bit
        .probe1(uart_rx_data), // 8 bit
        .probe2(i_uart_rx) // 
    );

    ila_1 ram_monitor (
        .clk(uart_clk), // input wire clk
    
    
        .probe0(counter), // input wire [5:0]  probe0  
        .probe1(ram_write_addr), // input wire [3:0]  probe1 
        .probe2(ram_read_addr), // input wire [3:0]  probe2 
        .probe3(read_mode), // input wire [0:0]  probe3 
        .probe4(ram_data_out0), // input wire [31:0]  probe4 
        .probe5(ram_data_out1), // input wire [31:0]  probe5 
        .probe6(ram_data_out2), // input wire [31:0]  probe6 
        .probe7(ram_data_out3), // input wire [31:0]  probe7 
        .probe8(ram_data_outb0), // input wire [31:0]  probe8 
        .probe9(ram_data_outb1), // input wire [31:0]  probe9 
        .probe10(ram_data_outb2), // input wire [31:0]  probe10 
        .probe11(ram_data_outb3) // input wire [31:0]  probe11
    );
    
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
    
    clk_wiz_0 clock_gen (
        .clk_out1(uart_clk),
        .clk_in1(i_clk_100M)
    );


    // block ram for c(output)
// blk_mem_gen_4 c1 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );

// blk_mem_gen_5 c2 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );

// blk_mem_gen_6 c3 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );

// blk_mem_gen_7 c4 (
//   .clka(clk),    // input wire clka
//   .ena(ena),      // input wire ena
//   .wea(wea),      // input wire [0 : 0] wea
//   .addra(addra),  // input wire [3 : 0] addra
//   .dina(dina),    // input wire [31 : 0] dina
//   .douta()  // output wire [31 : 0] douta
// );


wire [31:0] c00;
wire [31:0] c01;
wire [31:0] c02;
wire [31:0] c03;
wire [31:0] c10;
wire [31:0] c11;
wire [31:0] c12;
wire [31:0] c13;
wire [31:0] c20;
wire [31:0] c21;
wire [31:0] c22;
wire [31:0] c23;
wire [31:0] c30;
wire [31:0] c31;
wire [31:0] c32;
wire [31:0] c33;



 systolic_matrix_mul_4x4 multiplier (
    .clk(i_clk_100M),
    .rst(reset),

    // Map each element of matrix A to the appropriate inputs
    .a_0(ram_data_out0),
    .a_1(ram_data_out1),
    .a_2(ram_data_out2),
    .a_3(ram_data_out3),

    // Map each element of matrix B to the appropriate inputs
    .b_0(ram_data_outb0),
    .b_1(ram_data_outb1),
    .b_2(ram_data_outb2),
    .b_3(ram_data_outb3),
    .flag(read_mode),

    // Connect each element of the output matrix C individually
    .c_00(c00),
    .c_01(c01),
    .c_02(c02),
    .c_03(c03),
    .c_10(c10),
    .c_11(c11),
    .c_12(c12),
    .c_13(c13),
    .c_20(c20),
    .c_21(c21),
    .c_22(c22),
    .c_23(c23),
    .c_30(c30),
    .c_31(c31),
    .c_32(c32),
    .c_33(c33)
);



ila_2 monitor_debug  (
	.clk(uart_clk), // input wire clk


	.probe0(c00), // input wire [31:0]  probe0  
	.probe1(c01), // input wire [31:0]  probe1 
	.probe2(c02), // input wire [31:0]  probe2 
	.probe3(c03), // input wire [31:0]  probe3 
	.probe4(c10), // input wire [31:0]  probe4 
	.probe5(c11), // input wire [31:0]  probe5 
	.probe6(c12), // input wire [31:0]  probe6 
	.probe7(c13), // input wire [31:0]  probe7 
	.probe8(c20), // input wire [31:0]  probe8 
	.probe9(c21), // input wire [31:0]  probe9 
	.probe10(c22), // input wire [31:0]  probe10 
	.probe11(c23), // input wire [31:0]  probe11 
	.probe12(c30), // input wire [31:0]  probe12 
	.probe13(c31), // input wire [31:0]  probe13 
	.probe14(c32), // input wire [31:0]  probe14 
	.probe15(c33), // input wire [31:0]  probe15 
	.probe16(read_mode) // input wire [0:0]  probe16
);



    


    always @(posedge uart_clk) begin
        if (reset)
            uart_rx_data_valid_delay <= 0;
        else
            uart_rx_data_valid_delay <= uart_rx_data_valid;
    end
    
    always @(posedge uart_clk) begin
        if(uart_divider_counter < (UART_CLOCK_DIVIDER-1))
            uart_divider_counter <= uart_divider_counter + 1;
        else
            uart_divider_counter <= 'd0;
    end
    
    assign uart_rx_data_valid_pulse = uart_rx_data_valid && !uart_rx_data_valid_delay;
    
    always @(posedge uart_clk) begin
        uart_en <= (uart_divider_counter == 'd10); 
    end
    
    // Main control logic
    always @(posedge uart_clk) begin
        if (reset) begin
            write_counter <= 0;
            ram_write_addr <= 0;
            ram_read_addr <= 0;
            counter <= 0;
            ram_we <= 0;
            read_mode <= 0;
        end
        else if (!read_mode) begin // Write mode
            if (counter == 8) begin // After filling all RAMs
                read_mode <= 1;
            end
            if (uart_rx_data_valid_pulse) begin
                ram_data_in <= uart_rx_data;
                ram_we <= 1'b1;
                
                if (ram_write_addr == BLOCK_RAM_SIZE - 1) begin
                    ram_write_addr <= 0;
                    counter <= counter + 1;
                    
                    // Update write_counter based on which matrix we're writing
                    if (matrix_select == 0) begin
                        if (write_counter == 2'b11) begin // Finished first matrix
                            matrix_select <= 1;
                            write_counter <= 0;
                        end
                        else begin
                            write_counter <= write_counter + 1;
                        end
                    end
                    else begin // matrix_select == 1
                        if (write_counter == 2'b11) begin // Finished second matrix
                            matrix_select <= 2; // Done with both matrices
                        end
                        else begin
                            write_counter <= write_counter + 1;
                        end
                    end
                end
                else begin
                    ram_write_addr <= ram_write_addr + 1;
                end
            end
            else begin
                ram_we <= 1'b0;
            end
        end
        else begin // Read mode
            ram_we <= 1'b0;
//            counter = counter + 1;
            if (ram_read_addr == BLOCK_RAM_SIZE - 1) begin
                ram_read_addr <= BLOCK_RAM_SIZE-1;
//                read_mode <= 1'b0;
//                counter <= 10;
            end
            else
                ram_read_addr <= ram_read_addr + 1;
        end
    end
    
    always @(posedge uart_clk) begin
        if (reset)
            display_data <= 0;
        else if (!read_mode && uart_rx_data_valid)
            display_data <= uart_rx_data;
    end
endmodule
