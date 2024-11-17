/*
 * File name: bitcell_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: BitCell(clk, rst, D, we, re1, re2, line1, line2)
 * Author: Daniel Zhao
 * Date: 10/06/2023
 * Description: This is a testbench for BitCell. The testbench would test the functionality of BitCell, assuming bypass
 *              is not used. 
 * Dependencies: bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module bitcell_tb ();
    
    // Declare the simulation signals
    logic sim_clk; // clock
    logic sim_rst; // synchronous active high reset
    logic sim_D; // data input
    logic sim_we; // write enable
    logic sim_re1; // read enable 1
    logic sim_re2; // read enable 2
    logic sim_line1; // output line 1
    logic sim_line2; // output line 2

    // Instantiate the DUT
    BitCell iDUT (
        .clk(sim_clk),
        .rst(sim_rst),
        .D(sim_D),
        .we(sim_we),
        .re1(sim_re1),
        .re2(sim_re2),
        .line1(sim_line1),
        .line2(sim_line2)
    );

    // Declare the clock period
    always begin
        #10 sim_clk = ~sim_clk;
    end

    // Start the testbench
    initial begin

        // Initialize the signals
        sim_clk = 0;
        sim_rst = 0;
        sim_D = 0;
        sim_we = 0;
        sim_re1 = 0;
        sim_re2 = 0;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 1: unable to write without write enable
        @(negedge sim_clk);
        sim_D = 1;
        @(negedge sim_clk);
        sim_D = 0;
        @(negedge sim_clk);
        if (sim_line1 !== 1'bz || sim_line2 !== 1'bz) begin
            $display("Test 1 failed");
            $stop();
        end

        // Test 2: write 1 to the cell
        @(negedge sim_clk);
        sim_D = 1;
        sim_we = 1;
        @(negedge sim_clk);
        sim_we = 0;
        @(negedge sim_clk);
        if (sim_line1 !== 1'bz || sim_line2 !== 1'bz) begin
            $display("Test 2 failed");
            $stop();
        end

        // Test 3: read 1 from the cell through line 1
        @(negedge sim_clk);
        sim_re1 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 1'b1 || sim_line2 !== 1'bz) begin
            $display("Test 3 failed");
            $stop();
        end

        // Test 4: read 1 from the cell through line 2
        @(negedge sim_clk);
        sim_re1 = 0;
        sim_re2 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 1'bz || sim_line2 !== 1'b1) begin
            $display("Test 4 failed");
            $stop();
        end

        // Test 5: read 1 from the cell through both lines
        @(negedge sim_clk);
        sim_re1 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 1'b1 || sim_line2 !== 1'b1) begin
            $display("Test 5 failed");
            $stop();
        end

        // Test 6: write 0 to the cell
        @(negedge sim_clk);
        sim_D = 0;
        sim_we = 1;
        sim_re1 = 0;
        sim_re2 = 0;
        @(negedge sim_clk);
        sim_we = 0;
        @(negedge sim_clk);
        if (sim_line1 !== 1'bz || sim_line2 !== 1'bz) begin
            $display("Test 6 failed");
            $stop();
        end

        // Test 7: read 0 from the cell through line 1
        @(negedge sim_clk);
        sim_re1 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 1'b0 || sim_line2 !== 1'bz) begin
            $display("Test 7 failed");
            $stop();
        end

        // Test 8: read 0 from the cell through line 2
        @(negedge sim_clk);
        sim_re1 = 0;
        sim_re2 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 1'bz || sim_line2 !== 1'b0) begin
            $display("Test 8 failed");
            $stop();
        end

        // Test 9: read 0 from the cell through both lines
        @(negedge sim_clk);
        sim_re1 = 1;
        @(negedge sim_clk);
        if (sim_line1 !== 1'b0 || sim_line2 !== 1'b0) begin
            $display("Test 9 failed");
            $stop();
        end

        // Test 10: reset the cell to 0 after writing 1
        @(negedge sim_clk);
        sim_D = 1;
        sim_we = 1;
        sim_re1 = 0;
        sim_re2 = 0;
        @(negedge sim_clk);
        sim_we = 0;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;
        @(negedge sim_clk);
        if (sim_line1 !== 1'bz || sim_line2 !== 1'bz) begin
            $display("Test 10 failed");
            $stop();
        end

        /*
        // Test 11: By-passing the cell through line 1
        @(negedge sim_clk);
        sim_D = 1;
        sim_we = 1;
        sim_re1 = 1;
        sim_re2 = 0;
        if (sim_line1 !== 1'b1 || sim_line2 !== 1'bz) begin
            $display("Test 11 failed");
            $stop();
        end
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 12: By-passing the cell through line 2
        @(negedge sim_clk);
        sim_D = 1;
        sim_we = 1;
        sim_re1 = 0;
        sim_re2 = 1;
        if (sim_line1 !== 1'bz || sim_line2 !== 1'b1) begin
            $display("Test 12 failed");
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