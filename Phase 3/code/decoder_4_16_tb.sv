/*
 * File name: decoder_4_16_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: decoder_4_16(id,line)
 * Author: Daniel Zhao
 * Date: 10/06/2023
 * Description: This is a testbench for decoder_4_16. The testbench would test all the possible input combinations. 
 * Dependencies: decoder.v
 */
`default_nettype none
module decoder_4_16_tb ();
    
    // Declare the simulation signals
    logic [3:0] sim_id; // encoding id
    logic [15:0] sim_line; // converted line

    // Instantiate the DUT
    decoder_4_16 iDUT (
        .id(sim_id),
        .line(sim_line)
    );

    // Start the testbench
    initial begin

        // Print the header
        $display("id\tline");

        // Monitor the simulation signals
        $monitor("%h\t%b", sim_id, sim_line);

        // Test all the possible input combinations
        for(int i = 0; i < 16; i++) begin
            
            // Assign the simulation signals
            sim_id = i;

            // Wait for output to stablize
            #5;

            // Check the output
            if(sim_line !== 16'h0001 << i) begin
                $display("Error: id = %h, line = %h, expected = %h", sim_id, sim_line, 16'h0001 << i);
                $stop();
            end
        end

        // Print the finish message
        $display("Testbench finished. No prominent errors found.");
        $stop();
    end
endmodule
`default_nettype wire