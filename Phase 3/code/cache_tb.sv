/*
 * File name: cache_tb.sv
 * File Type: SystemVerilog Testbench
 * DUT: cache(clk, rst, addr, data_in, data_out, data_valid, miss_en, miss, wr, mem_enable, mem_wr, mem_addr, mem_in, 
 *            mem_out, mem_valid)
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This is a testbench for cache. It tests the functionality of the cache. 
 * Dependencies: cache.v, DataArray.v, MetaDataArray.v, D-Flip=Flop.v, decoder_6_64.v, decoder_3_8.v
 */
`default_nettype none
module cache_tb();

    // Declare simulation signals
    logic sim_clk; // Clock
    logic sim_rst; // synchronous active high reset
    logic [15:0] sim_addr; // Address
    logic [15:0] sim_data_in; // Data input
    logic [15:0] sim_data_out; // Data output
    logic sim_data_valid; // Data valid
    logic sim_miss_en; // Miss enable
    logic sim_miss; // Miss
    logic sim_wr; // Write enable
    logic sim_mem_enable; // Memory enable
    logic sim_mem_wr; // Memory write enable
    logic [15:0] sim_mem_addr; // Memory address
    logic [15:0] sim_mem_in; // Memory input
    logic [15:0] sim_mem_out; // Memory output
    logic sim_mem_valid; // Memory valid

    // Instantiate the DUT
    cache iDUT (
        .clk(sim_clk),
        .rst(sim_rst),
        .addr(sim_addr),
        .data_in(sim_data_in),
        .data_out(sim_data_out),
        .data_valid(sim_data_valid),
        .miss_en(sim_miss_en),
        .miss(sim_miss),
        .wr(sim_wr),
        .mem_enable(sim_mem_enable),
        .mem_wr(sim_mem_wr),
        .mem_addr(sim_mem_addr),
        .mem_in(sim_mem_in),
        .mem_out(sim_mem_out),
        .mem_valid(sim_mem_valid)
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
        sim_addr = 16'h0000;
        sim_data_in = 16'h0000;
        sim_miss_en = 0;
        sim_wr = 0;
        sim_mem_out = 16'h0000;
        sim_mem_valid = 0;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        @(negedge sim_clk);
        sim_wr = 0;
        sim_addr = 16'h0000;
        sim_miss_en = 1;
	    sim_mem_out = 16'h0001;
        /*
        sim_wr = 1;
        sim_addr = 16'h0000;
        sim_miss_en = 1;
        sim_data_in = 16'h0001;
        */
        repeat(3) @(negedge sim_clk);
        sim_mem_valid = 1;
        repeat(16) @(negedge sim_clk);

        sim_wr = 0;
        sim_addr = 16'h1002;
        sim_miss_en = 1;
        sim_mem_out = 16'h0002;
        repeat(3) @(negedge sim_clk);
        sim_mem_valid = 1;
        repeat(16) @(negedge sim_clk);

        sim_wr = 0;
        sim_addr = 16'h2004;
        sim_miss_en = 1;
        sim_mem_out = 16'h0003;
        repeat(3) @(negedge sim_clk);
        sim_mem_valid = 1;
        repeat(16) @(negedge sim_clk);
        $stop();

    end

endmodule
`default_nettype wire