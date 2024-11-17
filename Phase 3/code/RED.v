/*
 * File name: RED.v
 * File Type: Verilog Source
 * Module name: RED(A, B, Sum)
 * Testbench: RED_tb.sv
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This module is a reduction unit for the sum of the four bytes of the input, packed as two 16-bit words. 
 *              The output would be a sign-extended 16-bit word.
 * Dependent files: CLA.v, PFA.v
 */
`default_nettype none
module RED(A, B, Sum);

    // Inputs
    input wire [15:0] A;
    input wire [15:0] B;

    // Outputs
    output wire [15:0] Sum;

    // Internal wires
    wire [1:0] Carries_1_1;
    wire [1:0] Generates_1_1;
    wire [1:0] Propagates_1_1;
    wire Ovfl_1_1;
    wire [11:0] Sum_1_1;
    wire [1:0] Carries_1_2;
    wire [1:0] Generates_1_2;
    wire [1:0] Propagates_1_2;
    wire Ovfl_1_2;
    wire [11:0] Sum_1_2;
    wire [2:0] Carries_2;
    wire [2:0] Generates_2;
    wire [2:0] Propagates_2;
    wire Ovfl_2;

    // Assignments
    assign Carries_1_1[0] = 1'b0;
    assign Carries_1_1[1] = Generates_1_1[0] | Propagates_1_1[0] & Carries_1_1[0];
    assign Ovfl_1_1 = (~A[15] & ~B[15] & Sum_1_1[7]) | (A[15] & B[15] & ~Sum_1_1[7]);
    assign Sum_1_1[11:8] = Ovfl_1_1 ? {4{Generates_1_1[1] | Propagates_1_1[1] & Carries_1_1[1]}} : {4{Sum_1_1[7]}};
    assign Carries_1_2[0] = 1'b0;
    assign Carries_1_2[1] = Generates_1_2[0] | Propagates_1_2[0] & Carries_1_2[0];
    assign Ovfl_1_2 = (~A[7] & ~B[7] & Sum_1_2[7]) | (A[7] & B[7] & ~Sum_1_2[7]);
    assign Sum_1_2[11:8] = Ovfl_1_2 ? {4{Generates_1_2[1] | Propagates_1_2[1] & Carries_1_2[1]}} : {4{Sum_1_2[7]}};
    assign Carries_2[0] = 1'b0;
    assign Carries_2[1] = Generates_2[0] | Propagates_2[0] & Carries_2[0];
    assign Carries_2[2] = Generates_2[1] | Propagates_2[1] & Carries_2[1];
    assign Ovfl_2 = (~Sum_1_1[11] & ~Sum_1_2[11] & Sum[11]) | (Sum_1_1[11] & Sum_1_2[11] & ~Sum[11]);
    assign Sum[15:12] = Ovfl_2 ? {4{Generates_2[1] | Propagates_2[1] & Carries_2[1]}} : {4{Sum[11]}};

    // Instantiations
    CLA iCLA_1_1[1:0] (
        .A(A[15:8]),
        .B(B[15:8]),
        .Cin(Carries_1_1[1:0]),
        .Sum(Sum_1_1[7:0]),
        .G(Generates_1_1[1:0]),
        .P(Propagates_1_1[1:0])
    );
    CLA iCLA_1_2[1:0] (
        .A(A[7:0]),
        .B(B[7:0]),
        .Cin(Carries_1_2[1:0]),
        .Sum(Sum_1_2[7:0]),
        .G(Generates_1_2[1:0]),
        .P(Propagates_1_2[1:0])
    );
    CLA iCLA_2[2:0] (
        .A(Sum_1_1[11:0]),
        .B(Sum_1_2[11:0]),
        .Cin(Carries_2[2:0]),
        .Sum(Sum[11:0]),
        .G(Generates_2[2:0]),
        .P(Propagates_2[2:0])
    );
endmodule
`default_nettype wire