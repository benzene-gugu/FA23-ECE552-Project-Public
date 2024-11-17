/*
 * File name: shifter_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: shifter(in, amount, mode, out)
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This is a testbench for shifter.v. It tests all possible cases of in, amount, and mode.
 * Dependencies: shifter.v
 */
`default_nettype none
module shifter_tb();

    // Declare the simulation signals
    logic signed [15:0] sim_in;
    logic [3:0] sim_amount;
    logic [1:0] sim_mode;
    logic signed [15:0] sim_out;

    // Instantiate the DUT
    shifter iDUT(
        .in(sim_in),
        .amount(sim_amount),
        .mode(sim_mode),
        .out(sim_out)
    );

    // Declare additional internal signals
    logic signed [15:0] left_shift;
    logic signed [15:0] arithemetic_right_shift;
    logic signed [15:0] right_rotate;
    assign left_shift = sim_in << sim_amount;
    assign arithemetic_right_shift = sim_in >>> sim_amount;
    assign right_rotate = sim_in >> sim_amount | sim_in << (16 - sim_amount);

    // Start the testbench
    initial begin
         
        // Print the header
        $display("in\tamount\tmode\tout");

        // Monitor the simulation signals
        $monitor("%b\t%b\t%b\t%b", sim_in, sim_amount, sim_mode, sim_out);

        // Test all possible cases of in, amount, and mode
        for (int i = 0; i < 65536; i++) begin
            for (int j = 0; j < 16; j++) begin
                for (int k = 0; k < 3; k++) begin

                    // Assign the simulation signals
                    sim_in = i;
                    sim_amount = j;
                    sim_mode = k;

                    // Wait for 1ns
                    #1;

                    // Check the output
                    if(sim_mode === 2'b00) begin
                        if (sim_out !== left_shift) begin
                            $display("Error: %b << %b = %b, but the output is %b", sim_in, sim_amount, left_shift, 
                                sim_out);
                            $stop();
                        end
                    end
                    else if (sim_mode === 2'b01) begin
                        if (sim_out !== arithemetic_right_shift) begin
                            $display("Error: %b >>> %b = %b, but the output is %b", sim_in, sim_amount, 
                                arithemetic_right_shift, sim_out);
                            $stop();
                        end
                    end
                    else if (sim_mode === 2'b10) begin
                        if (sim_out !== right_rotate) begin
                            $display("Error: &b ROR %b = %b, but the output is %b", sim_in, sim_amount, right_rotate, 
                                sim_out);
                            $stop();
                        end
                    end
                    else begin
                        $display("Error: Invalid mode %b", sim_mode);
                        $stop();
                    end
                end
            end
        end

        // Prints the finish message
        $display("Testbench finished. No prominent errors found.");
        $stop();
    end
endmodule
`default_nettype wire