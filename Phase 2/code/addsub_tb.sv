/*
 * File name: addsub_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: addsub(A,B,Sub,Sum,Ovfl)
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This is a testbench for addsub.v. The testbench tests edge cases for A and B and tests random cases after
 *              that. 
 * Dependencies: addsub.v, CLA.v, PFA.v
 */
`default_nettype none
module addsub_tb();
    // Declare the randomized input packet that would be used for randomization
    class Packet;
        rand bit [32:0] data; // Randomized data
    endclass

    // Declare the simulation signals
    logic [15:0] sim_A;
    logic [15:0] sim_B;
    logic sim_Sub;
    logic [15:0] sim_Sum;
    logic sim_Ovfl;

    // Declare the DUT
    addsub iDUT(
        .A(sim_A),
        .B(sim_B),
        .Sub(sim_Sub),
        .Sum(sim_Sum),
        .Ovfl(sim_Ovfl)
    );

    // Declare the input packet
    Packet pkt;

    // Start the testbench
    initial begin
        
        // Print the header
        $display("A\tB\tSub\tSum\tOvfl");

        // Monitor the simulation signals
        $monitor("%h\t%h\t%b\t%h\t%b", sim_A, sim_B, sim_Sub, sim_Sum, sim_Ovfl);

        // Case 0: A = 0x0000, B = 0x0000, Sub = 0
        sim_A = 16'h0000;
        sim_B = 16'h0000;
        sim_Sub = 1'b0;
        #5;
        if(sim_Sum != 16'h0000 || sim_Ovfl != 1'b0) begin
            $display("Error: A = 0x0000, B = 0x0000, Sub = 0, Sum = %h, Ovfl = %b", sim_Sum, sim_Ovfl);
            $stop();
        end
        #5;

        // Case 1: A = 0x0000, B = 0x0000, Sub = 1
        sim_A = 16'h0000;
        sim_B = 16'h0000;
        sim_Sub = 1'b1;
        #5;
        if(sim_Sum != 16'h0000 || sim_Ovfl != 1'b0) begin
            $display("Error: A = 0x0000, B = 0x0000, Sub = 1, Sum = %h, Ovfl = %b", sim_Sum, sim_Ovfl);
            $stop();
        end
        #5;

        // Case 2: A = 0x7FFF, B = 0x7FFF, Sub = 0
        sim_A = 16'h7FFF;
        sim_B = 16'h7FFF;
        sim_Sub = 1'b0;
        #5;
        if(sim_Sum != 16'h7FFF || sim_Ovfl != 1'b1) begin
            $display("Error: A = 0x7FFF, B = 0x7FFF, Sub = 0, Sum = %h, Ovfl = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 3: A = 0x8000, B = 0x8000, Sub = 0
        sim_A = 16'h8000;
        sim_B = 16'h8000;
        sim_Sub = 1'b0;
        #5;
        if(sim_Sum != 16'h8000 || sim_Ovfl != 1'b1) begin
            $display("Error: A = 0x8000, B = 0x8000, Sub = 0, Sum = %h, Ovfl = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 4: A = 0x7FFF, B = 0x8000, Sub = 1
        sim_A = 16'h7FFF;
        sim_B = 16'h8000;
        sim_Sub = 1'b1;
        #5;
        if(sim_Sum != 16'h7FFF || sim_Ovfl != 1'b1) begin
            $display("Error: A = 0x7FFF, B = 0x8000, Sub = 1, Sum = %h, Ovfl = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 5: A = 0x8000, B = 0x7FFF, Sub = 1
        sim_A = 16'h8000;
        sim_B = 16'h7FFF;
        sim_Sub = 1'b1;
        #5;
        if(sim_Sum != 16'h8000 || sim_Ovfl != 1'b1) begin
            $display("Error: A = 0x8000, B = 0x7FFF, Sub = 1, Sum = %h, Ovfl = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 6-19: Random cases
        // Initialize the input packet
        pkt = new();

        for (int i = 6; i <= 19; i++) begin

            // Generate a new random input packet
            pkt.randomize();

            // Assign the input packet to the simulation signals
            sim_A = pkt.data[15:0];
            sim_B = pkt.data[31:16];
            sim_Sub = pkt.data[32];

            // Wait for 5ns
            #5;

            // Check the results
            if (sim_Sub == 0) begin
                if (sim_Sum != sim_A + sim_B) begin
                    if (sim_Ovfl != 1) begin
                        $display("Error: A = %h, B = %h, Sub = 0, Sum = %h, Ovfl = %b", sim_A, sim_B, sim_Sum, sim_Ovfl);
                        $stop();
                    end
                end
            end
            else begin
                if (sim_Sum != sim_A - sim_B) begin
                    if (sim_Ovfl != 1) begin
                        $display("Error: A = %h, B = %h, Sub = 1, Sum = %h, Ovfl = %b", sim_A, sim_B, sim_Sum, sim_Ovfl);
                        $stop();
                    end
                end
            end

            // Wait for 5ns
            #5;
        end

        // Print the finish message
        $display("Testbench finished. No prominent errors found.");
        $stop();
    end
endmodule
`default_nettype wire