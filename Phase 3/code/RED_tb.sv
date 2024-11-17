/*
 * File name: RED_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: RED(A, B, Sum)
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This is a testbench for RED.v. It tests selected edge cases and some random cases of A and B.
 * Dependencies: RED.v, CLA.v, PFA.v
 */
`default_nettype none
module RED_tb();

    // Declare the randomized input packet that would be used for randomization
    class Packet;
        rand bit [31:0] data; // Randomized data
    endclass

    // Declare the simulation signals
    logic [15:0] sim_A;
    logic [15:0] sim_B;
    logic [15:0] sim_Sum;

    // Declare additional internal signals
    logic [15:0] a,b,c,d;
    assign a = {{8{sim_A[15]}},sim_A[15:8]};
    assign b = {{8{sim_A[7]}},sim_A[7:0]};
    assign c = {{8{sim_B[15]}},sim_B[15:8]};
    assign d = {{8{sim_B[7]}},sim_B[7:0]};

    // Instantiate the DUT
    RED iDUT(
        .A(sim_A),
        .B(sim_B),
        .Sum(sim_Sum)
    );

    // Declare the input packet
    Packet pkt;

    // Start the testbench
    initial begin

        // Print the header
        $display("A\tB\tSum");

        // Monitor the simulation signals
        $monitor("%h_%h\t%h_%h\t%h", sim_A[15:8], sim_A[7:0], sim_B[15:8], sim_B[7:0], sim_Sum);

        // Case 0: A = 0x0000, B = 0x0000
        sim_A = 16'h0000;
        sim_B = 16'h0000;
        #5;
        if (sim_Sum !== 16'h0000) begin
            $display("Error: A = 0x0000, B = 0x0000, Sum = %h", sim_Sum);
            $stop();
        end

        // Case 1: A = 0x0000, B = 0xFF00
        sim_A = 16'h0000;
        sim_B = 16'hFF00;
        #5;
        if (sim_Sum !== 16'hFFFF) begin
            $display("Error: A = 0x0000, B = 0xFF00, Sum = %h", sim_Sum);
            $stop();
        end

        // Case 2: A = 0xFFFF, B = 0xFFFF
        sim_A = 16'hFFFF;
        sim_B = 16'hFFFF;
        #5;
        if (sim_Sum !== 16'hFFFC) begin
            $display("Error: A = 0xFFFF, B = 0xFFFF, Sum = %h", sim_Sum);
            $stop();
        end

        // Case 3: A = 0x0000, B = 0x0100
        sim_A = 16'h0000;
        sim_B = 16'h0100;
        #5;
        if (sim_Sum !== 16'h0001) begin
            $display("Error: A = 0x0000, B = 0x0100, Sum = %h", sim_Sum);
            $stop();
        end

        // Case 4-19: Random cases
        // Initialize the input packet
        pkt = new();

        for(int i = 4; i <= 19; i++) begin
            
            // Generate a new random input packet
            pkt.randomize();

            // Assign the input packet to the simulation signals
            sim_A = pkt.data[31:16];
            sim_B = pkt.data[15:0];

            // Wait for 5ns
            #5;

            // Check the result
            if (sim_Sum !== (a + b + c + d)) begin
                $display("Error: A = %h, B = %h, Sum = %h", sim_A, sim_B, sim_Sum);
                $stop();
            end
        end
        
        // Print the finish message
        $display("Testbench finished. No prominent errors found.");
        $stop();
    end
endmodule
`default_nettype wire