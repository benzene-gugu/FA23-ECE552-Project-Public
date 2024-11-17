/*
 * File name: PSA_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: PSA(A, B, Sum, Ovfl)
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This is a testbench for PSA.v. It tests selected edge cases and some random cases of A and B.
 * Dependencies: PSA.v, CLA.v, PFA.v
 */
`default_nettype none
module PSA_tb ();
    
    // Declare the randomized input packet that would be used for randomization
    class Packet;
        rand bit [31:0] data; // Randomized data
    endclass

    // Declare the simulation signals
    logic [15:0] sim_A; // 16-bit input A
    logic [15:0] sim_B; // 16-bit input B
    logic [15:0] sim_Sum; // 16-bit output Sum
    logic sim_Ovfl; // 1-bit output Ovfl

    // Instantiate the DUT
    PSA iDUT (
        .A(sim_A),
        .B(sim_B),
        .Sum(sim_Sum),
        .Ovfl(sim_Ovfl)
    );

    // Declare the input packet
    Packet pkt;

    // Start the testbench
    initial begin
        
        // Print the header
        $display("A\tB\tSum\tOvfl");

        // Monitor the simulation signals
        $monitor(
            "%b_%b_%b_%b\t%b_%b_%b_%b\t%b_%b_%b_%b\t%b",
            sim_A[15:12],sim_A[11:8],sim_A[7:4],sim_A[3:0],
            sim_B[15:12],sim_B[11:8],sim_B[7:4],sim_B[3:0],
            sim_Sum[15:12],sim_Sum[11:8],sim_Sum[7:4],sim_Sum[3:0],
            sim_Ovfl
        );

        // Test all edge cases of A and B
        // Case 0: A = 0x0000, B = 0x0000;
        sim_A = 16'b0000_0000_0000_0000;
        sim_B = 16'b0000_0000_0000_0000;
        #5;
        if(sim_Sum !== 16'b0000_0000_0000_0000 || sim_Ovfl !== 1'b0) begin
            $display("Error: A = 0x0000, B = 0x0000, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end
        #5;

        // Case 1: A = 0x0000, B = 0xFFFF;
        sim_A = 16'b0000_0000_0000_0000;
        sim_B = 16'b1111_1111_1111_1111;
        #5;
        if(sim_Sum !== 16'b1111_1111_1111_1111 || sim_Ovfl !== 1'b0) begin
            $display("Error: A = 0x0000, B = 0xFFFF, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end
        #5;

        // Case 2: A = 0x0000, B = 0x7777;
        sim_A = 16'b0000_0000_0000_0000;
        sim_B = 16'b0111_0111_0111_0111;
        #5;
        if(sim_Sum !== 16'b0111_0111_0111_0111 || sim_Ovfl !== 1'b0) begin
            $display("Error: A = 0x0000, B = 0x7777, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 3: A = 0x1111, B = 0x1111;
        sim_A = 16'b0001_0001_0001_0001;
        sim_B = 16'b0001_0001_0001_0001;
        #5;
        if(sim_Sum !== 16'b0010_0010_0010_0010 || sim_Ovfl !== 1'b0) begin
            $display("Error: A = 0x1111, B = 0x1111, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 4: A = 0x7777, B = 0x7777;
        sim_A = 16'b0111_0111_0111_0111;
        sim_B = 16'b0111_0111_0111_0111;
        #5;
        if(sim_Sum !== 16'b0111_0111_0111_0111 || sim_Ovfl !== 1'b1) begin
            $display("Error: A = 0x7777, B = 0x7777, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 5: A = 0xFFFF, B = 0xFFFF;
        sim_A = 16'b1111_1111_1111_1111;
        sim_B = 16'b1111_1111_1111_1111;
        #5;
        if(sim_Sum !== 16'b1110_1110_1110_1110 || sim_Ovfl !== 1'b0) begin
            $display("Error: A = 0xFFFF, B = 0xFFFF, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end

        // Case 6: A = 0xFFFF, B = 0x8888;
        sim_A = 16'b1111_1111_1111_1111;
        sim_B = 16'b1000_1000_1000_1000;
        #5;
        if(sim_Sum !== 16'b1000_1000_1000_1000 || sim_Ovfl !== 1'b1) begin
            $display("Error: A = 0xFFFF, B = 0x8888, Sum = %b, Error = %b", sim_Sum, sim_Ovfl);
            $stop();
        end
        #5;

        // Case 7-19: Random cases
        // Initialize the input packet
        pkt = new();

        for(int i = 7; i <= 19; i++) begin

            // Generate a new random input packet
            pkt.randomize();

            // Assign the input packet to the simulation signals
            sim_A = pkt.data[31:16];
            sim_B = pkt.data[15:0];

            // Wait for 5ns
            #5;

            // Check if the simulation signals are correct
            if ((sim_Sum[15:12] !== (sim_A[15:12] + sim_B[15:12]))
                    ||(sim_Sum[11:8] !== (sim_A[11:8] + sim_B[11:8]))
                    ||(sim_Sum[7:4] !== (sim_A[7:4] + sim_B[7:4]))
                    ||(sim_Sum[3:0] !== (sim_A[3:0] + sim_B[3:0])))
            begin
                if(sim_Ovfl !== 1'b1) begin
                    $display("Error: A = %b, B = %b, Sum = %b, Error = %b", sim_A, sim_B, sim_Sum, sim_Ovfl);
                    $stop();
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