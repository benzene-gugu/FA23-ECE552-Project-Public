/*
 * File name: addsub.v
 * File Type: Verilog Source
 * Module name: addsub(A,B,Sub,Sum,Ovfl)
 * Testbench: addsub_tb.sv
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: 
 * Dependent files: CLA.v, PFA.v
 */
`default_nettype none
module addsub (A,B,Sub,Sum,Ovfl);
    
    // Inputs
    input wire [15:0] A;
    input wire [15:0] B;
    input wire Sub;

    // Outputs
    output wire [15:0] Sum;
    output wire Ovfl;

    // Internal wires
    wire [15:0] Bin;
    wire [3:0] Carries;
    wire [3:0] Generates;
    wire [3:0] Propagates;
    wire [15:0] FullSum;
    wire PosOvfl;
    wire NegOvfl;

    // Assignments
    assign Bin = Sub ? ~B : B;
    assign Carries[0] = Sub;
    assign Carries[1] = Generates[0] | Propagates[0] & Carries[0];
    assign Carries[2] = Generates[1] | Propagates[1] & Carries[1];
    assign Carries[3] = Generates[2] | Propagates[2] & Carries[2];
    assign PosOvfl = (~A[15] & ~B[15] & FullSum[15] & ~Sub) | (~A[15] & B[15] & FullSum[15] & Sub);
    assign NegOvfl = (A[15] & ~B[15] & ~FullSum[15] & Sub) | (A[15] & B[15] & ~FullSum[15] & ~Sub);
    assign Ovfl = PosOvfl | NegOvfl;
    assign Sum = PosOvfl ? 16'h7fff : (NegOvfl ? 16'h8000 : FullSum[15:0]);

    // Instantiations
    CLA iCLA[3:0] (
        .A(A[15:0]),
        .B(Bin[15:0]),
        .Cin(Carries[3:0]),
        .Sum(FullSum[15:0]),
        .G(Generates[3:0]),
        .P(Propagates[3:0])
    );
endmodule
`default_nettype wire