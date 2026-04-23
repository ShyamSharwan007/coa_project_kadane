`timescale 1ns / 1ps

module memory_rom (
    input clk,
    input [3:0] address,
    input read_enable,
    output reg signed [15:0] data_out
);

    // 16-element array of 16-bit signed integers
    reg signed [15:0] mem [0:15];

    initial begin
        mem[0]  = -16'd2;
        mem[1]  =  16'd1;
        mem[2]  = -16'd3;
        mem[3]  =  16'd4;
        mem[4]  = -16'd1;
        mem[5]  =  16'd2;
        mem[6]  =  16'd1;
        mem[7]  = -16'd5;
        mem[8]  =  16'd4;
        mem[9]  =  16'd0;
        // Pad the rest of the memory with zeros
        mem[10] = 16'd0; mem[11] = 16'd0; mem[12] = 16'd0; 
        mem[13] = 16'd0; mem[14] = 16'd0; mem[15] = 16'd0;
    end

    // Synchronous read
    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= mem[address];
        end
    end
endmodule
