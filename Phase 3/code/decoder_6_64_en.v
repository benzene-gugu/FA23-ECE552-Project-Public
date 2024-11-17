/*
 * File name: decoder_6_64_en.v
 * File Type: Verilog Source
 * Module name: decoder_en_6_64(id,en,line)
 * Testbench: NONE
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This file contains a general 6:64 decoder module with an enable input. The module accepts a 6-bit encoding
 *              id and converts it to a 64-bit line only when the enable signal is asserted. If the enable signal is
 *              deasserted, the line output is set to 0.
 * Dependent files: decoder_6_64.v
 */
`default_nettype none
module decoder_en_6_64 (id,en,line);
    
    // Inputs
    input wire [5:0] id; // 6-bit encoding id
    input wire en; // enable signal

    // Outputs
    output wire [63:0] line; // 64-bit line

    // Internal wires
    wire [63:0] line_decode; // 64-bit line from decoder

    // Assignments
    assign line = en ? line_decode : 64'h0000000000000000; // Only output the line when enable is asserted

    // Instantiations
    decoder_6_64 iDecoder (.id(id), .line(line_decode)); // Instantiate a 6:64 decoder
endmodule