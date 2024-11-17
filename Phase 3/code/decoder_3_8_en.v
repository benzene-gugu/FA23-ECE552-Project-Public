/*
 * File name: decoder_3_8_en.v
 * File Type: Verilog Source
 * Module name: decoder_en_3_8(id,en,line)
 * Testbench: NONE
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This file contains a 3:8 decoder module with enable. The module accepts a 3-bit encoding id and converts
 *              it to a 8-bit line only when the enable signal is asserted. If the enable signal is deasserted, the line
 *              output is set to 0.
 * Dependent files: decoder_3_8.v
 */
`default_nettype none
module decoder_en_3_8 (id,en,line);
    
    // Inputs
    input wire [2:0] id; // 3-bit encoding id
    input wire en; // enable signal

    // Outputs
    output wire [7:0] line; // 8-bit line

    // Internal wires
    wire [7:0] line_decode; // 8-bit line from decoder

    // Assignments
    assign line = en ? line_decode : 8'h00; // Only output the line when enable is asserted

    // Instantiations
    decoder_3_8 iDecoder (.id(id), .line(line_decode)); // Instantiate a 3:8 decoder
endmodule
`default_nettype wire