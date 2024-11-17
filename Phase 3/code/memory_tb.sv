/*
 * File name: memory_tb.sv
 * File Type: SystemVerilog Testbench
 * DUT: memory4c(clk, rst, addr, data_in, data_out, data_valid, enable, wr)
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This is a testbench for multicycle main memory. It tests the functionality of the memory.
 * Dependencies: multicycle_memory.v
 */
`default_nettype none
module memory_tb();

    // Declare simulation signals
    logic sim_clk; // Clock
    logic sim_rst; // synchronous active high reset
    logic [15:0] sim_addr; // Address
    logic [15:0] sim_data_in; // Data input
    logic [15:0] sim_data_out; // Data output
    logic sim_data_valid; // Data valid
    logic sim_enable; // Enable
    logic sim_wr; // Write enable

    // Instantiate the DUT
    memory4c iDUT (
        .clk(sim_clk),
        .rst(sim_rst),
        .addr(sim_addr),
        .data_in(sim_data_in),
        .data_out(sim_data_out),
        .data_valid(sim_data_valid),
        .enable(sim_enable),
        .wr(sim_wr)
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
        sim_addr = 0;
        sim_data_in = 0;
        sim_enable = 0;
        sim_wr = 0;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Read from memory
        @(posedge sim_clk);
        sim_addr = 16'h0000;
        sim_enable = 1;
        sim_wr = 0;
        repeat(5) @(posedge sim_clk);

        $stop();

    end

endmodule
`default_nettype wire