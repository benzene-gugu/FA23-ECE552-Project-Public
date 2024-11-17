/*
 * File name: flag.v
 * File Type: Verilog Source
 * Module name: Flag(clk, rst, we, new_flag, flag)
 * Testbench: flag_tb.sv
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This file contains the register definition for the flag register. The flag register is a 3-bit register
 *              that stores the N, Z, and V flags. The register would operate just as any other register in the register
 *              file. The register is synchronous and resets synchronously. Ny default, bypassing the register is disabled.
 * Dependent files: bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module Flag(clk, rst, we, new_flag, flag);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire we; // write enable
    input wire [2:0] new_flag; // new flag in order of Z, N, V from high to low

    // Outputs
    output wire [2:0] flag; // flag in order of Z, N, V from high to low

    // Instantiations
    // Instantiate 3 bitcells
    BitCell iBC[2:0] (
        .clk({3{clk}}),
        .rst({3{rst}}),
        .D(new_flag[2:0]),
        .we({3{we}}),
        .re1({3{1'b1}}),
        .re2(),
        .line1(flag[2:0]),
        .line2()
    );
endmodule
`default_nettype wire