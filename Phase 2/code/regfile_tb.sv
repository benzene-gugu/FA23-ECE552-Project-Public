/*
 * File name: regfile_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: RegisterFile(clk, rst, Src1, Src2, Dst, we, DstData, Src1Data, Src2Data)
 * Author: Daniel Zhao
 * Date: 10/07/2023
 * Description: This is a testbench for RegisterFile. It tests the functionality of the RegisterFile, assuming bypassing
 *              is not enabled. 
 * Dependencies: regfile.v, reg.v, bitcell.v, D-Flip-Flop.v, decoder_en.v, decoder.v
 */
`default_nettype none
module regfile_tb ();
    
    // Declare the randomized input packet that would be used for randomization
    class Packet;
        rand bit [19:0] data; // Randomized data
    endclass

    // Declare the simulation signals
    logic sim_clk; // Clock
    logic sim_rst; // synchronous active high reset
    logic [3:0] sim_Src1; // Source 1 register address
    logic [3:0] sim_Src2; // Source 2 register address
    logic [3:0] sim_Dst; // Destination register address
    logic sim_we; // Write enable
    logic [15:0] sim_DstData; // Destination register data
    logic [15:0] sim_Src1Data; // Source 1 register data
    logic [15:0] sim_Src2Data; // Source 2 register data

    // Instantiate the DUT
    RegisterFile iDUT (
        .clk(sim_clk),
        .rst(sim_rst),
        .Src1(sim_Src1),
        .Src2(sim_Src2),
        .Dst(sim_Dst),
        .we(sim_we),
        .DstData(sim_DstData),
        .Src1Data(sim_Src1Data),
        .Src2Data(sim_Src2Data)
    );

    // Declare the input packet
    Packet pkt;

    // Declare the clock period
    always begin
        #10 sim_clk = ~sim_clk;
    end

    // Start the simulation
    initial begin

        // Initialize the input packet
        pkt = new();

        // Initialize the simulation signals
        sim_clk = 0;
        sim_rst = 0;
        sim_Src1 = 4'h0;
        sim_Src2 = 4'h0;
        sim_Dst = 4'h0;
        sim_we = 0;
        sim_DstData = 16'h0000;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Test 1: Unable to write to registers without write enable
        @(negedge sim_clk);
        sim_DstData = 16'h0001;
        @(negedge sim_clk);
        sim_DstData = 16'h0000;
        @(negedge sim_clk);
        if (sim_Src1Data !== 16'h0000 || sim_Src2Data !== 16'h0000) begin
            $display("Test 1 failed: Unable to write to registers without write enable");
            $stop();
        end

        // Test 2: Write to a random register with write enable
        @(negedge sim_clk);
        sim_we = 1;
        pkt.randomize();
        sim_Dst = pkt.data[19:16];
        sim_DstData = pkt.data[15:0];
        @(negedge sim_clk);
        sim_we = 0;
        @(negedge sim_clk);
        if (sim_Src1Data !== 16'h0000 || sim_Src2Data !== 16'h0000) begin
            $display("Test 2 failed: Write to a random register with write enable");
            $stop();
        end

        // Test 3: Read from a random register through Src1
        @(negedge sim_clk);
        sim_Src1 = pkt.data[19:16];
        @(negedge sim_clk);
        if (sim_Src1Data !== pkt.data[15:0]) begin
            $display("Test 3 failed: Read from a random register");
            $stop();
        end

        // Test 4: Read from a random register through Src2
        @(negedge sim_clk);
        sim_Src2 = pkt.data[19:16];
        @(negedge sim_clk);
        if (sim_Src2Data !== pkt.data[15:0]) begin
            $display("Test 4 failed: Read from a random register");
            $stop();
        end

        // Test 5: Reset the registers
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;
        @(negedge sim_clk);
        if (sim_Src1Data !== 16'h0000 || sim_Src2Data !== 16'h0000) begin
            $display("Test 5 failed: Reset the registers");
            $stop();
        end

        /*
        // Test 6: Write and read from a random register with register bypassing through Src1
        @(negedge sim_clk);
        sim_we = 1;
        pkt.randomize();
        sim_Dst = pkt.data[19:16];
        sim_DstData = pkt.data[15:0];
        sim_Src1 = pkt.data[19:16];
        if(sim_Src1Data !== pkt.data[15:0]) begin
            $display("Test 6 failed: Write and read from a random register with register bypassing through Src1");
            $stop();
        end

        // Test 7: Write and read from a random register with register bypassing through Src2
        @(negedge sim_clk);
        sim_we = 1;
        pkt.randomize();
        sim_Dst = pkt.data[19:16];
        sim_DstData = pkt.data[15:0];
        sim_Src2 = pkt.data[19:16];
        if(sim_Src2Data !== pkt.data[15:0]) begin
            $display("Test 7 failed: Write and read from a random register with register bypassing through Src2");
            $stop();
        end
        */

        // Print the finish message
        $display("Testbench finished. No prominent error detected.");
        $stop();
    end
endmodule
`default_nettype wire