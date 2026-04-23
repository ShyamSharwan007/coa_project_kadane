`timescale 1ns / 1ps

module max_subarray_pipeline (
    input clk,
    input reset,
    input signed [15:0] data_in,
    input data_valid,
    output reg signed [15:0] max_sum
);

    reg signed [15:0] current_sum;
    reg stage1_valid;
    
    // The explicit Pipeline Register
    reg signed [15:0] current_sum_pipeline_reg; 

    // Combinational wire for instantaneous feedback (Solves the RAW hazard)
    wire signed [15:0] next_current_sum;
    assign next_current_sum = (current_sum < 0) ? data_in : (current_sum + data_in);

    always @(posedge clk) begin
        if (reset) begin
            current_sum <= 0;
            max_sum <= 0;
            current_sum_pipeline_reg <= 0;
            stage1_valid <= 0;
        end else begin
            // Pass the valid signal down the pipeline
            stage1_valid <= data_valid;

            // STAGE 1: Calculate local sum and push to pipeline register
            if (data_valid) begin
                current_sum <= next_current_sum; 
                current_sum_pipeline_reg <= next_current_sum; 
            end

            // STAGE 2: Global Max Check (Delayed by 1 cycle)
            if (stage1_valid) begin
                if (current_sum_pipeline_reg > max_sum) begin
                    max_sum <= current_sum_pipeline_reg;
                end
            end
        end
    end
endmodule
