/*
 * File name: bitcell.v
 * File Type: Verilog Source
 * Module name: BitCell(clk, rst, D, we, re1, re2, line1, line2)
 * Testbench: bitcell_tb.sv
 * Author: Daniel Zhao
 * Date: 10/06/2023
 * Description: This file contains a bitcell module. The module stores a single bits of data. The data is stored on the
 *              rising edge of the clock if write enable is asserted. The data read from the bitcell is available on the
 *              line when the corresponding read enable is asserted, otherwise the line is high impedance. The bitcell
 *              resets synchronously when the reset signal is asserted. By default, bypassing the bitcell is disabled.
 * Dependent files: D-Flip-Flop.v
 */
`default_nettype none
module BitCell (clk, rst, D, we, re1, re2, line1, line2);
    
    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire D; // data input
    input wire we; // write enable
    input wire re1; // read enable 1
    input wire re2; // read enable 2

    // Outputs
    output wire line1; // data output 1
    output wire line2; // data output 2

    // Internal wires
    wire Q; // data output from D-Flip-Flop

    // Assignments without bypassing
    assign line1 = re1 ? Q : 1'bz; // Only output the data when read enable 1 is asserted
    assign line2 = re2 ? Q : 1'bz; // Only output the data when read enable 2 is asserted

    // Assignments with bypassing
    // assign line1 = re1 ? (we ? D : Q) : 1'bz; // Output the data when read enable 1 is asserted
    // assign line2 = re2 ? (we ? D : Q) : 1'bz; // Output the data when read enable 2 is asserted

    // Instantiations
    dff iDFF (.q(Q), .d(D), .wen(we), .clk(clk), .rst(rst)); // D-Flip-Flop instantiation
endmodule