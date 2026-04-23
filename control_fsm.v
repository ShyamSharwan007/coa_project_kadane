`timescale 1ns / 1ps

module control_fsm (
    input clk,
    input reset,
    input start,
    output reg [3:0] memory_address,
    output reg memory_read_enable,
    output reg data_valid,
    output reg system_done
);

    parameter IDLE = 2'b00, READ = 2'b01, WAIT_PIPE = 2'b10, DONE = 2'b11;
    reg [1:0] state, next_state;
    reg [3:0] count;

    // State Register & Counter (Sequential Logic - Updates ONLY on Clock)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            data_valid <= 0;
        end else begin
            state <= next_state;
            
            // Only increment count on the clock edge during these states
            if (state == READ || state == WAIT_PIPE) begin
                count <= count + 1;
            end
            
            // Delay data_valid by 1 cycle to match ROM read latency
            data_valid <= memory_read_enable; 
        end
    end

    // Next State Logic (Combinational Logic - NO counters here!)
    always @(*) begin
        // Default outputs to prevent latches
        memory_address = count;
        memory_read_enable = 0;
        system_done = 0;
        next_state = state;

        case (state)
            IDLE: begin
                if (start) next_state = READ;
            end
            READ: begin
                memory_read_enable = 1;
                // Transition when we've read all 10 elements (0 to 9)
                if (count == 4'd9) next_state = WAIT_PIPE; 
            end
            WAIT_PIPE: begin
                // Wait for the pipeline to finish processing the last elements
                if (count == 4'd13) next_state = DONE;
            end
            DONE: begin
                system_done = 1;
            end
        endcase
    end
endmodule
