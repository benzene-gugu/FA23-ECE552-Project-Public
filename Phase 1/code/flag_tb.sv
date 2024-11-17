/*
 * File name: flag_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: Flag(clk, rst, we, new_flag, flag)
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This is a testbench for Flag. It tests the functionality of the Register, assuming bypassing is not enabled. 
 * Dependencies: flag.v, bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module flag_tb();

    // Declare the simulation signals
    logic sim_clk; // Clock
    logic sim_rst; // synchronous active high reset
    logic sim_we; // Write enable
    logic [2:0] sim_new_flag; // New flag
    logic [2:0] sim_flag; // Flag

    // Declare the DUT
    Flag iDUT(
        .clk(sim_clk),
        .rst(sim_rst),
        .we(sim_we),
        .new_flag(sim_new_flag),
        .flag(sim_flag)
    );

    // Declare the clock period
    always begin
        #10 sim_clk = ~sim_clk;
    end

    // Start the simulation
    initial begin

        // Initialize the simulation signals
        sim_clk = 0;
        sim_rst = 0;
        sim_we = 0;
        sim_new_flag = 0;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 1: we = 0, unable to write
        @(negedge sim_clk);
        sim_we = 0;
        sim_new_flag = 3'b111;
        @(negedge sim_clk);
        sim_new_flag = 3'b000;
        @(negedge sim_clk);
        if(sim_flag !== 3'b000) begin
            $display("Test 1 failed");
        end

        // Test 2: we = 1, write to all bits at once
        @(negedge sim_clk);
        sim_we = 1;
        sim_new_flag = 3'b111;
        @(negedge sim_clk);
        sim_we = 0;
        sim_new_flag = 3'b000;
        @(negedge sim_clk);
        if(sim_flag !== 3'b111) begin
            $display("Test 2 failed");
        end

        // Test 3: we = 1, only update one bit
        @(negedge sim_clk);
        sim_we = 1;
        sim_new_flag = {1'b0, sim_flag[1:0]};
        @(negedge sim_clk);
        sim_we = 0;
        sim_new_flag = 3'b000;
        @(negedge sim_clk);
        if(sim_flag !== 3'b011) begin
            $display("Test 3 failed");
        end

        // Test 4: reset the register
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;
        @(negedge sim_clk);
        if(sim_flag !== 3'b000) begin
            $display("Test 4 failed");
        end

        /*
        // Test 5: we = 1, write to all bits at once, bypassing is enabled
        @(negedge sim_clk);
        sim_we = 1;
        sim_new_flag = 3'b111;
        if (sim_flag !== 3'b111) begin
            $display("Test 5 failed");
        end
        @(negedge sim_clk);
        sim_we = 0;
        sim_new_flag = 3'b000;
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 6: we = 1, only update one bit, bypassing is enabled
        @(negedge sim_clk);
        sim_we = 1;
        sim_new_flag = {1'b1, sim_flag[1:0]};
        if (sim_flag !== 3'b100) begin
            $display("Test 6 failed");
        end
        @(negedge sim_clk);
        sim_we = 0;
        sim_new_flag = 3'b000;
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;
        */

        // Print the finish message
        $display("Testbench finished. No prominent error detected.");
        $stop();
    end

endmodule
`default_nettype wire