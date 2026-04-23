`timescale 1ns / 1ps

module max_subarray_system (
    input clk,
    input reset,
    input start,
    output signed [15:0] final_max_sum,
    output done
);

    wire [3:0] memory_address_lines;
    wire memory_read_enable;
    wire signed [15:0] data_bus;
    wire data_valid_signal;

    // Instantiate ROM
    memory_rom mem_inst (
        .clk(clk),
        .address(memory_address_lines),
        .read_enable(memory_read_enable),
        .data_out(data_bus)
    );

    // Instantiate FSM
    control_fsm fsm_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .memory_address(memory_address_lines),
        .memory_read_enable(memory_read_enable),
        .data_valid(data_valid_signal),
        .system_done(done)
    );

    // Instantiate Pipeline
    max_subarray_pipeline pipeline_inst (
        .clk(clk),
        .reset(reset),
        .data_in(data_bus),
        .data_valid(data_valid_signal),
        .max_sum(final_max_sum)
    );

endmodule
