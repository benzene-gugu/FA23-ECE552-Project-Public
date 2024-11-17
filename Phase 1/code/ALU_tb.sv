/*
 * File name: ALU_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: ALU(clk, rst, In1, In2, Opcode, Out, Flags)
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This is a testbench for ALU.v. It tests the functionality of ALU.v, assuming that all the submodules are
 *              working properly. Assuming that bypassing the flag register is disabled. 
 * Dependencies: ALU.v, flag.v, bitcell.v, D-Flip-Flop.v, addsub.v, CLA.v, PFA.v, PSA.v, RED.v, shifter.v
 */
`default_nettype none
module ALU_tb();

    // Declare the randomized input packet that would be used for randomization
    class Packet;
        rand bit [31:0] data; // Randomized data
    endclass

    // Declare the simulation signals
    logic sim_clk; // Clock
    logic sim_rst; // Reset
    logic [15:0] sim_In1; // Input 1
    logic [15:0] sim_In2; // Input 2
    logic [3:0] sim_Opcode; // Opcode
    logic [15:0] sim_Out; // Output
    logic [2:0] sim_Flags; // Flags

    // Instantiate the DUT
    ALU DUT(
        .clk(sim_clk),
        .rst(sim_rst),
        .In1(sim_In1),
        .In2(sim_In2),
        .Opcode(sim_Opcode),
        .Out(sim_Out),
        .Flags(sim_Flags)
    );

    // Declare the input packet
    Packet pkt;

    // Declare the clock period
    always begin
        #10 sim_clk = ~sim_clk;
    end

    // Start the simulation
    initial begin
        // Initialize the simulation signals
        sim_clk = 0;
        sim_rst = 0;
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h0;
        @(negedge sim_clk);
        sim_rst = 1;
        @(negedge sim_clk);
        sim_rst = 0;

        // Case 0-0: Test ADD for zero
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h0;
        @(negedge sim_clk);
        if (sim_Out !== 16'h0000 || sim_Flags !== 3'b100) begin
            $display("Test 0-0 failed");
        end

        // Case 0-1: Test ADD for negative
        @(negedge sim_clk);
        sim_In1 = 16'hFFFF;
        sim_In2 = 16'hFFFF;
        sim_Opcode = 4'h0;
        @(negedge sim_clk);
        if (sim_Out !== 16'hFFFE || sim_Flags !== 3'b010) begin
            $display("Test 0-1 failed");
            $stop();
        end

        // Case 0-2: Test ADD for overflow
        @(negedge sim_clk);
        sim_In1 = 16'h7FFF;
        sim_In2 = 16'h7FFF;
        sim_Opcode = 4'h0;
        @(negedge sim_clk);
        if (sim_Out !== 16'h7FFF || sim_Flags !== 3'b001) begin
            $display("Test 0-2 failed");
            $stop();
        end

        // Case 1-0: Test SUB for zero
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h1;
        @(negedge sim_clk);
        if (sim_Out !== 16'h0000 || sim_Flags !== 3'b100) begin
            $display("Test 1-0 failed");
            $stop();
        end

        // Case 1-1: Test SUB for negative
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0001;
        sim_Opcode = 4'h1;
        @(negedge sim_clk);
        if (sim_Out !== 16'hFFFF || sim_Flags !== 3'b010) begin
            $display("Test 1-1 failed");
            $stop();
        end

        // Case 1-2: Test SUB for overflow
        @(negedge sim_clk);
        sim_In1 = 16'h8000;
        sim_In2 = 16'h0001;
        sim_Opcode = 4'h1;
        @(negedge sim_clk);
        if (sim_Out !== 16'h8000 || sim_Flags !== 3'b011) begin
            $display("Test 1-2 failed");
            $stop();
        end

        // Case 2: Test XOR for zero
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h2;
        @(negedge sim_clk);
        if (sim_Out !== 16'h0000 || sim_Flags !== 3'b111) begin
            $display("Test 2 failed");
            $stop();
        end

        // Case 4: Test Left Shift for zero
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h4;
        @(negedge sim_clk);
        if (sim_Out !== 16'h0000 || sim_Flags !== 3'b111) begin
            $display("Test 4 failed");
            $stop();
        end

        // Case 5: Test Right Shift for zero
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h5;
        @(negedge sim_clk);
        if (sim_Out !== 16'h0000 || sim_Flags !== 3'b111) begin
            $display("Test 5 failed");
            $stop();
        end

        // Case 6: Test Right Rotate for zero
        @(negedge sim_clk);
        sim_In1 = 16'h0000;
        sim_In2 = 16'h0000;
        sim_Opcode = 4'h6;
        @(negedge sim_clk);
        if (sim_Out !== 16'h0000 || sim_Flags !== 3'b111) begin
            $display("Test 6 failed");
            $stop();
        end

        // Initialize the input packet
        pkt = new();

        // Case 8: Test Data Address Calculation
        @(negedge sim_clk);
        pkt.randomize();
        sim_In1 = pkt.data[15:0];
        sim_In2 = pkt.data[31:16];
        sim_Opcode = 4'h8;
        @(negedge sim_clk);
        if (sim_Out !== ((sim_In1 & 16'hfffe) + (sim_In2 << 1))) begin
            $display("Test 8 failed");
            $stop();
        end

        // Case 10: Test Load Lower Byte
        @(negedge sim_clk);
        pkt.randomize();
        sim_In1 = pkt.data[15:0];
        sim_In2 = pkt.data[31:16];
        sim_Opcode = 4'hA;
        @(negedge sim_clk);
        if (sim_Out !== ((sim_In1 & 16'hff00) | sim_In2[7:0])) begin
            $display("Test 10 failed");
            $stop();
        end

        // Case 11: Test Load Upper Byte
        @(negedge sim_clk);
        pkt.randomize();
        sim_In1 = pkt.data[15:0];
        sim_In2 = pkt.data[31:16];
        sim_Opcode = 4'hB;
        @(negedge sim_clk);
        if (sim_Out !== ((sim_In1 & 16'h00ff) | (sim_In2[7:0] << 8))) begin
            $display("Test 11 failed");
            $stop();
        end

        // Print the finish message
        $display("Testbench finished. No prominent error detected.");
        $stop();
    end
endmodule
`default_nettype wire