/*
 * File name: PFA.v
 * File Type: Verilog Source
 * Module name: PFA(A,B,Cin,Sum,G,P)
 * Testbench: PFA_tb.sv
 * Author: Daniel Zhao
 * Date: 10/12/2023
 * Description: This module describes a 1-bit Partial Full Adder. It takes in two bits and a carry in as inputs and outputs
 *              a sum bit, a generate bit, and a propagate bit.
 * Dependent files: none
 */
`default_nettype none
module PFA(A,B,Cin,Sum,G,P);

    // Inputs
    input wire A; // First bit
    input wire B; // Second bit
    input wire Cin; // Carry in

    // Outputs
    output wire Sum; // Sum bit
    output wire G; // Generate bit
    output wire P; // Propagate bit
    
    // Assignments
    assign Sum = A ^ B ^ Cin; // Sum bit is the XOR of the inputs and the carry in
    assign G = A & B; // Generate bit is the AND of the inputs
    assign P = A | B; // Propagate bit is the OR of the inputs
endmodule
`default_nettype wire