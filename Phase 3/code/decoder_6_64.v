/*
 * File name: decoder_6_64.v
 * File Type: Verilog Source
 * Module name: decoder_6_64(id,line)
 * Testbench: NONE
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This file contains a general 6:64 decoder module. The module accepts a 6-bit encoding id and converts
 *              it to a 64-bit line.
 * Dependent files: NULL
 */
`default_nettype none
module decoder_6_64 (id,line);
    
    // Inputs
    input wire [5:0] id; // 6-bit encoding id

    // Outputs
    output wire [63:0] line; // 64-bit line

    // Assignments
    assign line[0] = ~id[5] & ~id[4] & ~id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b000000
    assign line[1] = ~id[5] & ~id[4] & ~id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b000001
    assign line[2] = ~id[5] & ~id[4] & ~id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b000010
    assign line[3] = ~id[5] & ~id[4] & ~id[3] & ~id[2] & id[1] & id[0]; // id = 6'b000011
    assign line[4] = ~id[5] & ~id[4] & ~id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b000100
    assign line[5] = ~id[5] & ~id[4] & ~id[3] & id[2] & ~id[1] & id[0]; // id = 6'b000101
    assign line[6] = ~id[5] & ~id[4] & ~id[3] & id[2] & id[1] & ~id[0]; // id = 6'b000110
    assign line[7] = ~id[5] & ~id[4] & ~id[3] & id[2] & id[1] & id[0]; // id = 6'b000111
    assign line[8] = ~id[5] & ~id[4] & id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b001000
    assign line[9] = ~id[5] & ~id[4] & id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b001001
    assign line[10] = ~id[5] & ~id[4] & id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b001010
    assign line[11] = ~id[5] & ~id[4] & id[3] & ~id[2] & id[1] & id[0]; // id = 6'b001011
    assign line[12] = ~id[5] & ~id[4] & id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b001100
    assign line[13] = ~id[5] & ~id[4] & id[3] & id[2] & ~id[1] & id[0]; // id = 6'b001101
    assign line[14] = ~id[5] & ~id[4] & id[3] & id[2] & id[1] & ~id[0]; // id = 6'b001110
    assign line[15] = ~id[5] & ~id[4] & id[3] & id[2] & id[1] & id[0]; // id = 6'b001111
    assign line[16] = ~id[5] & id[4] & ~id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b010000
    assign line[17] = ~id[5] & id[4] & ~id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b010001
    assign line[18] = ~id[5] & id[4] & ~id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b010010
    assign line[19] = ~id[5] & id[4] & ~id[3] & ~id[2] & id[1] & id[0]; // id = 6'b010011
    assign line[20] = ~id[5] & id[4] & ~id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b010100
    assign line[21] = ~id[5] & id[4] & ~id[3] & id[2] & ~id[1] & id[0]; // id = 6'b010101
    assign line[22] = ~id[5] & id[4] & ~id[3] & id[2] & id[1] & ~id[0]; // id = 6'b010110
    assign line[23] = ~id[5] & id[4] & ~id[3] & id[2] & id[1] & id[0]; // id = 6'b010111
    assign line[24] = ~id[5] & id[4] & id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b011000
    assign line[25] = ~id[5] & id[4] & id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b011001
    assign line[26] = ~id[5] & id[4] & id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b011010
    assign line[27] = ~id[5] & id[4] & id[3] & ~id[2] & id[1] & id[0]; // id = 6'b011011
    assign line[28] = ~id[5] & id[4] & id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b011100
    assign line[29] = ~id[5] & id[4] & id[3] & id[2] & ~id[1] & id[0]; // id = 6'b011101
    assign line[30] = ~id[5] & id[4] & id[3] & id[2] & id[1] & ~id[0]; // id = 6'b011110
    assign line[31] = ~id[5] & id[4] & id[3] & id[2] & id[1] & id[0]; // id = 6'b011111
    assign line[32] = id[5] & ~id[4] & ~id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b100000
    assign line[33] = id[5] & ~id[4] & ~id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b100001
    assign line[34] = id[5] & ~id[4] & ~id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b100010
    assign line[35] = id[5] & ~id[4] & ~id[3] & ~id[2] & id[1] & id[0]; // id = 6'b100011
    assign line[36] = id[5] & ~id[4] & ~id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b100100
    assign line[37] = id[5] & ~id[4] & ~id[3] & id[2] & ~id[1] & id[0]; // id = 6'b100101
    assign line[38] = id[5] & ~id[4] & ~id[3] & id[2] & id[1] & ~id[0]; // id = 6'b100110
    assign line[39] = id[5] & ~id[4] & ~id[3] & id[2] & id[1] & id[0]; // id = 6'b100111
    assign line[40] = id[5] & ~id[4] & id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b101000
    assign line[41] = id[5] & ~id[4] & id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b101001
    assign line[42] = id[5] & ~id[4] & id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b101010
    assign line[43] = id[5] & ~id[4] & id[3] & ~id[2] & id[1] & id[0]; // id = 6'b101011
    assign line[44] = id[5] & ~id[4] & id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b101100
    assign line[45] = id[5] & ~id[4] & id[3] & id[2] & ~id[1] & id[0]; // id = 6'b101101
    assign line[46] = id[5] & ~id[4] & id[3] & id[2] & id[1] & ~id[0]; // id = 6'b101110
    assign line[47] = id[5] & ~id[4] & id[3] & id[2] & id[1] & id[0]; // id = 6'b101111
    assign line[48] = id[5] & id[4] & ~id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b110000
    assign line[49] = id[5] & id[4] & ~id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b110001
    assign line[50] = id[5] & id[4] & ~id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b110010
    assign line[51] = id[5] & id[4] & ~id[3] & ~id[2] & id[1] & id[0]; // id = 6'b110011
    assign line[52] = id[5] & id[4] & ~id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b110100
    assign line[53] = id[5] & id[4] & ~id[3] & id[2] & ~id[1] & id[0]; // id = 6'b110101
    assign line[54] = id[5] & id[4] & ~id[3] & id[2] & id[1] & ~id[0]; // id = 6'b110110
    assign line[55] = id[5] & id[4] & ~id[3] & id[2] & id[1] & id[0]; // id = 6'b110111
    assign line[56] = id[5] & id[4] & id[3] & ~id[2] & ~id[1] & ~id[0]; // id = 6'b111000
    assign line[57] = id[5] & id[4] & id[3] & ~id[2] & ~id[1] & id[0]; // id = 6'b111001
    assign line[58] = id[5] & id[4] & id[3] & ~id[2] & id[1] & ~id[0]; // id = 6'b111010
    assign line[59] = id[5] & id[4] & id[3] & ~id[2] & id[1] & id[0]; // id = 6'b111011
    assign line[60] = id[5] & id[4] & id[3] & id[2] & ~id[1] & ~id[0]; // id = 6'b111100
    assign line[61] = id[5] & id[4] & id[3] & id[2] & ~id[1] & id[0]; // id = 6'b111101
    assign line[62] = id[5] & id[4] & id[3] & id[2] & id[1] & ~id[0]; // id = 6'b111110
    assign line[63] = id[5] & id[4] & id[3] & id[2] & id[1] & id[0]; // id = 6'b111111
endmodule
`default_nettype wire