/*
 * File name: CLA_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: CLA(A,B,Cin,Sum,G,P)
 * Author: Daniel Zhao
 * Date: 10/12/2023
 * Description: This is a testbench for CLA. The testbench will test all possible input combinations.
 * Dependencies: CLA.v, PFA.v
 */
`default_nettype none
module CLA_tb ();
    
    // Declare the simulation signals
    logic [3:0] sim_A; // Input A
    logic [3:0] sim_B; // Input B
    logic sim_Cin; // Input Cin
    logic [3:0] sim_Sum; // Output Sum
    logic sim_G; // Group Generate
    logic sim_P; // Group Propogate

    // Instantiate the DUT
    CLA iDUT (
        .A(sim_A),
        .B(sim_B),
        .Cin(sim_Cin),
        .Sum(sim_Sum),
        .G(sim_G),
        .P(sim_P)
    );

    // Start the testbench
    initial begin

        // Print the header
        $display("A\tB\tCin\tSum\tG\tP");

        // Monitor the simulation signals
        $monitor("%h\t%h\t%b\t%h\t%b\t%b", sim_A, sim_B, sim_Cin, sim_Sum, sim_G, sim_P);

        // Test all possible input combinations
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                for (int k = 0; k < 2; k++) begin

                    // Assign the inputs
                    sim_A = i;
                    sim_B = j;
                    sim_Cin = k;

                    // Wait for the output to settle
                    #1;

                    // Check the output
                    if (sim_Sum !== (i + j + k) % 16) begin
                        $display("Error: Sum is incorrect.");
                        $stop();
                    end
                    if (sim_P !== ((sim_A[0] | sim_B[0]) & (sim_A[1] | sim_B[1]) & (sim_A[2] | sim_B[2]) & 
                        (sim_A[3] | sim_B[3]))) begin
                        $display("Error: P is incorrect.");
                        $stop();
                    end
                    if (sim_G !== ((sim_A[3] & sim_B[3]) | (sim_A[2] & sim_B[2] & (sim_A[3] | sim_B[3])) | 
                        (sim_A[1] & sim_B[1] & (sim_A[3] | sim_B[3]) & (sim_A[2] | sim_B[2])) | 
                        (sim_A[0] & sim_B[0] & (sim_A[3] | sim_B[3]) & (sim_A[2] | sim_B[2]) & (sim_A[1] | sim_B[1]))))
                    begin
                        $display("Error: G is incorrect.");
                        $stop();
                    end
                end
            end
        end

        // Print the finish message
        $display("Testbench finished. No prominent errors found.");
        $stop();
    end
endmodule
`default_nettype wire