/*
 * File name: CLA.v
 * File Type: Verilog Source
 * Module name: CLA(A,B,Cin,Sum,G,P)
 * Testbench: CLA_tb.sv
 * Author: Daniel Zhao
 * Date: 10/12/2023
 * Description: This module describes a 4-bit Carry Lookahead Adder. It takes in two 4-bit numbers and a carry in as inputs
 *              and outputs a 4-bit sum, a group generate bit, and a group propagate bit.
 * Dependent files: PFA.v
 */
`default_nettype none
module CLA(A,B,Cin,Sum,G,P);

    // Inputs
    input wire [3:0] A; // First 4-bit number
    input wire [3:0] B; // Second 4-bit number
    input wire Cin; // Carry in

    // Outputs
    output wire [3:0] Sum; // 4-bit sum
    output wire G; // Group generate bit
    output wire P; // Group propagate bit

    // Internal wires
    wire [3:0] Carries; // Array of carries
    wire [3:0] Generates; // Array of generates
    wire [3:0] Propagates; // Array of propagates
    
    // Assignments
    assign Carries[0] = Cin; // Carry in is the first carry
    assign Carries[1] = Generates[0] | Propagates[0] & Carries[0]; // Carry 1 exists either when generated or propagated
    assign Carries[2] = Generates[1] | Propagates[1] & Carries[1]; // Carry 2 exists either when generated or propagated
    assign Carries[3] = Generates[2] | Propagates[2] & Carries[2]; // Carry 3 exists either when generated or propagated
    // Group propagate bit is true when all propagates are true
    assign P = Propagates[3] & Propagates[2] & Propagates[1] & Propagates[0];
    // Group generate bit is true when the bit is generated and propagated from the previous bits
    assign G = Generates[3] | (Generates[2] & Propagates[3]) | 
        (Generates[1] & Propagates[3] & Propagates[2]) | (Generates[0] & Propagates[3] & Propagates[2] & Propagates[1]);

    // Instantiations
    PFA iPFA[3:0] (.A(A[3:0]), .B(B), .Cin(Carries[3:0]), .Sum(Sum[3:0]), .G(Generates[3:0]), .P(Propagates[3:0]));
endmodule
`default_nettype wire