/*
 * File name: reg_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: Register(clk, rst, D, we, re1, re2, line1, line2)
 * Author: Daniel Zhao
 * Date: 10/07/2023
 * Description: This is a testbench for Register. It tests the functionality of the Register, assuming bypassing is not
 *              enabled. 
 * Dependencies: reg.v, bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module reg_tb ();

    // Declare the randomized input packet that would be used for randomization
    class Packet;
        rand bit [15:0] data; // Randomized data
    endclass

    // Declare the simulation signals
    logic sim_clk; // Clock
    logic sim_rst; // synchronous active high reset
    logic sim_we; // Write enable
    logic sim_re1; // Read enable 1
    logic sim_re2; // Read enable 2
    logic [15:0] sim_D; // Data input
    logic [15:0] sim_line1; // Output line 1
    logic [15:0] sim_line2; // Output line 2

    // Instantiate the DUT
    Register iDUT(
        .clk(sim_clk),
        .rst(sim_rst),
        .D(sim_D),
        .we(sim_we),
        .re1(sim_re1),
        .re2(sim_re2),
        .line1(sim_line1),
        .line2(sim_line2)
    );

    // Declare the input packet
    Packet pkt;

    // Declare the clock period
    always begin
        #10 sim_clk = ~sim_clk;
    end

    // Start the testbench
    initial begin
        
        // Initialize the input packet
        pkt = new();

        // Initialize the simulation signals
        sim_clk = 0;
        sim_rst = 0;
        sim_we = 0;
        sim_re1 = 0;
        sim_re2 = 0;
        sim_D = 16'h0000;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 1: Unable to write to the register without write enable
        @(negedge sim_clk);
        sim_D = 16'h0001;
        @(negedge sim_clk);
        sim_D = 16'h0000;
        @(negedge sim_clk);
        if (sim_line1 !== 16'bzzzzzzzzzzzzzzzz || sim_line2 !== 16'bzzzzzzzzzzzzzzzz) begin
            $display("Test 1 failed");
            $stop();
        end

        // Test 2: Able to write to the register with write enable
        @(negedge sim_clk);
        sim_we = 1;
        pkt.randomize();
        sim_D = pkt.data;
        @(negedge sim_clk);
        sim_we = 0;
        @(negedge sim_clk);
        if (sim_line1 !== 16'bzzzzzzzzzzzzzzzz || sim_line2 !== 16'bzzzzzzzzzzzzzzzz) begin
            $display("Test 2 failed");
            $stop();
        end

        // Test 3: Able to read from the register with read enable 1
        @(negedge sim_clk);
        sim_re1 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== pkt.data || sim_line2 !== 16'bzzzzzzzzzzzzzzzz) begin
            $display("Test 3 failed");
            $stop();
        end

        // Test 4: Able to read from the register with read enable 2
        @(negedge sim_clk);
        sim_re1 = 0;
        sim_re2 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 16'bzzzzzzzzzzzzzzzz || sim_line2 !== pkt.data) begin
            $display("Test 4 failed");
            $stop();
        end

        // Test 5: Able to read from the register with read enable 1 and 2
        @(negedge sim_clk);
        sim_re1 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== pkt.data || sim_line2 !== pkt.data) begin
            $display("Test 5 failed");
            $stop();
        end

        // Test 6: Reset the register
        @(negedge sim_clk);
        sim_rst = 1;
        sim_re1 = 0;
        sim_re2 = 0;
        @(negedge sim_clk);
        sim_rst = 0;
        @(negedge sim_clk);
        if (sim_line1 !== 16'bzzzzzzzzzzzzzzzz || sim_line2 !== 16'bzzzzzzzzzzzzzzzz) begin
            $display("Test 6 failed");
            $stop();
        end

        /*
        // Test 7: Bypassing the register through read enable 1
        @(negedge sim_clk);
        sim_we = 1;
        pkt.randomize();
        sim_D = pkt.data;
        sim_re1 = 1;
        sim_re2 = 0;
        if (sim_line1 !== pkt.data || sim_line2 !== 16'bzzzzzzzzzzzzzzzz) begin
            $display("Test 7 failed");
            $stop();
        end
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 8: Bypassing the register through read enable 2
        @(negedge sim_clk);
        sim_we = 1;
        pkt.randomize();
        sim_D = pkt.data;
        sim_re1 = 0;
        sim_re2 = 1;
        if (sim_line1 !== 16'bzzzzzzzzzzzzzzzz || sim_line2 !== pkt.data) begin
            $display("Test 8 failed");
            $stop();
        end
        @(negedge sim_clk);
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