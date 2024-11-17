/*
 * File name: IF_ID.v
 * File Type: Verilog Source
 * Module name: IF_ID(clk, rst, we, inst_IF, incremented_pc_IF, flush_IF, inst_ID, incremented_pc_ID, flush_ID)
 * Testbench: None
 * Author: Daniel Zhao
 * Date: 11/10/2023
 * Description: This file contains a register module. being used for the storage of IF/ID pipeline registers. The register
 *              resets synchronously when the reset signal is asserted. 
 * Dependent files: reg,v, bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module IF_ID (clk, rst, we, inst_IF, incremented_pc_IF, flush_IF, inst_ID, incremented_pc_ID, flush_ID);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire we; // write enable
    input wire [15:0] inst_IF; // instruction from IF stage
    input wire [15:0] incremented_pc_IF; // incremented program counter from IF stage
    input wire flush_IF; // flush signal from IF stage

    // Outputs
    output wire [15:0] inst_ID; // instruction to ID stage
    output wire [15:0] incremented_pc_ID; // incremented program counter to ID stage
    output wire flush_ID; // flush signal to ID stage

    // Instantiations
    // Instantiate 2 registers for instruction and incremented program counter
    Register iR[1:0] (
        .clk({2{clk}}),
        .rst({2{rst}}),
        .D({inst_IF, incremented_pc_IF}),
        .we({we, we}),
        .re1(2'b11),
        .re2(),
        .line1({inst_ID, incremented_pc_ID}),
        .line2()
    );

    // Instantiate 1 bitcell for flush signal
    BitCell iBC(
        .clk(clk),
        .rst(rst),
        .D(flush_IF),
        .we(we),
        .re1(1'b1),
        .re2(),
        .line1(flush_ID),
        .line2()
    );
endmodule
