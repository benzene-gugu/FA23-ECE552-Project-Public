/*
 * File name: decoder_3_8.v
 * File Type: Verilog Source
 * Module name: decoder_3_8(id,line)
 * Testbench: NONE
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This file contains a general 3:8 decoder module. The module accepts a 3-bit encoding id and converts it
 *              to a 8-bit line. 
 * Dependent files: NULL
 */
`default_nettype none
module decoder_3_8(id,line);
    
    // Inputs
    input wire [2:0] id; // 3-bit encoding id

    // Outputs
    output wire [7:0] line; // 8-bit line

    // Assignments
    assign line[0] = ~id[2] & ~id[1] & ~id[0]; // id = 3'b000
    assign line[1] = ~id[2] & ~id[1] & id[0]; // id = 3'b001
    assign line[2] = ~id[2] & id[1] & ~id[0]; // id = 3'b010
    assign line[3] = ~id[2] & id[1] & id[0]; // id = 3'b011
    assign line[4] = id[2] & ~id[1] & ~id[0]; // id = 3'b100
    assign line[5] = id[2] & ~id[1] & id[0]; // id = 3'b101
    assign line[6] = id[2] & id[1] & ~id[0]; // id = 3'b110
    assign line[7] = id[2] & id[1] & id[0]; // id = 3'b111
endmodule
`default_nettype wire