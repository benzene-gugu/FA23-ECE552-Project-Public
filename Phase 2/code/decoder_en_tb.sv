/*
 * File name: decoder_en_tb.sv
 * File type: SystemVerilog Testbench
 * DUT: decoder_en_4_16(id,en,line)
 * Author: Daniel Zhao
 * Date: 10/06/2023
 * Description: This is a testbench for decoder_en_4_16. The testbench would test all the possible input combinations. 
 * Dependencies: decoder_en.v, decoder.v
 */
`default_nettype none
module decoder_en_tb ();
    
    // Declare the simulation signals
    logic [3:0] sim_id; // encoding id
    logic sim_en; // enable signal
    logic [15:0] sim_line; // converted line

    // Instantiate the DUT
    decoder_en_4_16 iDUT (
        .id(sim_id),
        .en(sim_en),
        .line(sim_line)
    );

    // Start the testbench
    initial begin

        // Print the header
        $display("id\ten\tline");

        // Monitor the simulation signals
        $monitor("%h\t%b\t%b", sim_id, sim_en, sim_line);

        // Test all the possible input combinations
        for(int i = 0; i < 16; i++) begin
            
            // Assign the simulation signals
            sim_id = i;
            sim_en = 1'b1;

            // Wait for output to stablize
            #5;

            // Check the output
            if(sim_line !== 16'h0001 << i) begin
                $display("Error: when enabled, id = %h, line = %h, expected = %h", sim_id, sim_line, 16'h0001 << i);
                $stop();
            end

            // Assign the simulation signals
            sim_en = 1'b0;

            // Wait for output to stablize
            #5;

            // Check the output
            if(sim_line !== 16'h0000) begin
                $display("Error: when disabled, id = %h, line = %h, expected = %h", sim_id, sim_line, 16'h0000);
                $stop();
            end
        end

        // Print the finish message
        $display("Testbench finished. No prominent errors found.");
        $stop();
    end
endmodule
`default_nettype wire