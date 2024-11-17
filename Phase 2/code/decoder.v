/*
 * File name: decoder.v
 * File Type: Verilog Source
 * Module name: decoder_4_16(id,line)
 * Testbench: decoder_tb.sv
 * Author: Daniel Zhao
 * Date: 10/06/2023
 * Description: This file contains a general 4:16 decoder module. The module accepts a 4-bit encoding id and converts it
 *              to a 16-bit line. 
 * Dependent files: NULL
 */
`default_nettype none
module decoder_4_16 (id,line);
    
    // Inputs
    input wire [3:0] id; // 4-bit encoding id

    // Outputs
    output wire [15:0] line; // 16-bit line

    // Assignments
    assign line[0] = ~id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 4'b0000
    assign line[1] = ~id[3] & ~id[2] & ~id[1] & id[0]; // id = 4'b0001
    assign line[2] = ~id[3] & ~id[2] & id[1] & ~id[0]; // id = 4'b0010
    assign line[3] = ~id[3] & ~id[2] & id[1] & id[0]; // id = 4'b0011
    assign line[4] = ~id[3] & id[2] & ~id[1] & ~id[0]; // id = 4'b0100
    assign line[5] = ~id[3] & id[2] & ~id[1] & id[0]; // id = 4'b0101
    assign line[6] = ~id[3] & id[2] & id[1] & ~id[0]; // id = 4'b0110
    assign line[7] = ~id[3] & id[2] & id[1] & id[0]; // id = 4'b0111
    assign line[8] = id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 4'b1000
    assign line[9] = id[3] & ~id[2] & ~id[1] & id[0]; // id = 4'b1001
    assign line[10] = id[3] & ~id[2] & id[1] & ~id[0]; // id = 4'b1010
    assign line[11] = id[3] & ~id[2] & id[1] & id[0]; // id = 4'b1011
    assign line[12] = id[3] & id[2] & ~id[1] & ~id[0]; // id = 4'b1100
    assign line[13] = id[3] & id[2] & ~id[1] & id[0]; // id = 4'b1101
    assign line[14] = id[3] & id[2] & id[1] & ~id[0]; // id = 4'b1110
    assign line[15] = id[3] & id[2] & id[1] & id[0]; // id = 4'b1111
endmodule
`default_nettype wire