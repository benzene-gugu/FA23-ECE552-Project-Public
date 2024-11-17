/*
 * File name: decoder_en.v
 * File Type: Verilog Source
 * Module name: decoder_en_4_16(id,en,line)
 * Testbench: decoder_en_tb.sv
 * Author: Daniel Zhao
 * Date: 10/06/2023
 * Description: This file contains a 4:16 decoder module with enable. The module accepts a 4-bit encoding id and converts
 *              it to a 16-bit line only when the enable signal is asserted. If the enable signal is deasserted, the line
 *              output is set to 0.
 * Dependent files: decoder.v
 */
`default_nettype none
module decoder_en_4_16 (id,en,line);
    
    // Inputs
    input wire [3:0] id; // 4-bit encoding id
    input wire en; // enable signal

    // Outputs
    output wire [15:0] line; // 16-bit line

    // Internal wires
    wire [15:0] line_decode; // 16-bit line from decoder

    // Assignments
    assign line = en ? line_decode : 16'h0000; // Only output the line when enable is asserted

    // Instantiations
    decoder_4_16 iDecoder (.id(id), .line(line_decode)); // Instantiate a 4:16 decoder
endmodule
`default_nettype wire