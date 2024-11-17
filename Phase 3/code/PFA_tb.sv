/*
 * File name: PFA_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: PFA(A,B,Cin,Sum,G,P)
 * Author: Daniel Zhao
 * Date: 10/12/2023
 * Description: This is a testbench for PFA. The testbench will test all possible input combinations.
 * Dependencies: PFA.v
 */
`default_nettype none
module PFA_tb ();
    
    // Declare the simulation signals
    logic sim_A; // Input A
    logic sim_B; // Input B
    logic sim_Cin; // Input Cin
    logic sim_Sum; // Output Sum
    logic sim_G; // Output G
    logic sim_P; // Output P

    // Instantiate the DUT
    PFA iDUT (
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
        $monitor("%b\t%b\t%b\t%b\t%b\t%b", sim_A, sim_B, sim_Cin, sim_Sum, sim_G, sim_P);

        // Test all possible input combinations
        for (int i = 0; i < 2; i++) begin
            for (int j = 0; j < 2; j++) begin
                for (int k=0; k < 2; k++) begin

                    // Assign the inputs
                    sim_A = i;
                    sim_B = j;
                    sim_Cin = k;

                    // Wait for the outputs to settle
                    #1;

                    // Check the outputs
                    if(sim_Sum !== (sim_A + sim_B + sim_Cin) % 2) begin
                        $display("Error: Sum is incorrect for A=%b, B=%b, Cin=%b", sim_A, sim_B, sim_Cin);
                        $stop();
                    end
                    if(sim_G !== (sim_A & sim_B)) begin
                        $display("Error: G is incorrect for A=%b, B=%b, Cin=%b", sim_A, sim_B, sim_Cin);
                        $stop();
                    end
                    if(sim_P !== (sim_A | sim_B)) begin
                        $display("Error: P is incorrect for A=%b, B=%b, Cin=%b", sim_A, sim_B, sim_Cin);
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