`timescale 1ns / 1ps

module uart_rx #(
    OVERSAMPLE = 13,
    N_DATA_BITS = 8,
    MAJORITY_START_IDX = 4,
    MAJORITY_END_IDX = 8
) (
    input   i_en,
            i_clk,
            i_data,
            i_reset,
    
    output  [N_DATA_BITS-1:0]   o_data,
                                o_data_valid
);

    // Finally ignore the stop bit, and connect the internal logic to the output ports
    assign o_data = frame_data[N_DATA_BITS-1:0];
    assign o_data_valid = frame_data_valid;
endmodule
