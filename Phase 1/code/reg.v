/*
 * File name: reg.v
 * File Type: Verilog Source
 * Module name: Register(clk, rst, D, we, re1, re2, line1, line2)
 * Testbench: reg_tb.sv
 * Author: Daniel Zhao
 * Date: 10/07/2023
 * Description: This file contains a register module. The module stores 16 bits of data. The data is stored in 16 bitcells.
 *              The data is stored on the rising edge of the clock if write enable is asserted. The data read from the
 *              register is available on the line when the corresponding read enable is asserted, otherwise the line is
 *              high impedance. The register resets synchronously when the reset signal is asserted. By default, bypassing
 *              the register is disabled.
 * Dependent files: bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module Register (clk, rst, D, we, re1, re2, line1, line2);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire [15:0] D; // data input
    input wire we; // write enable
    input wire re1; // read enable 1
    input wire re2; // read enable 2

    // Outputs
    output wire [15:0] line1; // data output 1
    output wire [15:0] line2; // data output 2

    // Instantiations
    // Instantiate 16 bitcells
    BitCell iBC[15:0] (
        .clk({16{clk}}),
        .rst({16{rst}}),
        .D(D[15:0]),
        .we({16{we}}),
        .re1({16{re1}}),
        .re2({16{re2}}),
        .line1(line1[15:0]),
        .line2(line2[15:0])
    );
endmodule
`default_nettype wire