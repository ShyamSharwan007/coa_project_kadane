`timescale 1ns / 1ps

module max_subarray_system_tb;

    reg clk;
    reg reset;
    reg start;
    wire signed [15:0] final_max_sum;
    wire done;

    // Instantiate the Top Level System
    max_subarray_system uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .final_max_sum(final_max_sum),
        .done(done)
    );

    // Generate a 10ns Clock
    always #5 clk = ~clk;

    initial begin
        // Setup waveform dumping for GTKWave
        $dumpfile("pipeline_waves.vcd");
        $dumpvars(0, max_subarray_system_tb);

        // Initialize Inputs
        clk = 0;
        reset = 1;
        start = 0;

        // Apply Reset
        #20;
        reset = 0;
        
        // Trigger Start Signal
        #10;
        start = 1;
        #10;
        start = 0; // Turn off start, let FSM take over

        // Wait for system to declare it is done
        wait(done == 1);
        
        // Give it a few extra clock cycles to settle, then print result
        #20;
        $display("-----------------------------------------");
        $display("Simulation Complete.");
        $display("Calculated Maximum Subarray Sum: %d", final_max_sum);
        $display("Expected Result: 6");
        $display("-----------------------------------------");
        
        $finish;
    end
endmodule
