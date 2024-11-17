/*
 * File name: PSA.v
 * File Type: Verilog Source
 * Module name: PSA(A, B, Sum, Ovfl)
 * Testbench: PSA_tb.sv
 * Author: Daniel Zhao
 * Date: 10/14/2023
 * Description: This module describes a 16-bit parallel adder. It takes two 16-bit inputs and treats each half-byte
 *              (4 bits) as separate numbers. It then adds the numbers at the corresponding locations separately and
 *              stores the result in the corresponding location in the output. The module would use saturation arithmetic
 *              to prevent overflow. A Ovfl signal is used to indicate whether an overflow has occurred and only used for
 *              debugging purposes.
 * Dependent files: CLA.v, PFA.v
 */
`default_nettype none
module PSA(A, B, Sum, Ovfl);

    // Inputs
    input wire [15:0] A; // 16-bit input A
    input wire [15:0] B; // 16-bit input B

    // Outputs
    output wire [15:0] Sum; // 16-bit output Sum
    output wire Ovfl;

    // Internal wires
    wire [15:0] RawSum; // 16-bit raw sum
    wire [3:0] PosOvfl; // Array of positive overflow
    wire [3:0] NegOvfl; // Array of negative overflow

    // Assignments
    assign PosOvfl[0] = ~A[3] & ~B[3] & RawSum[3];
    assign PosOvfl[1] = ~A[7] & ~B[7] & RawSum[7];
    assign PosOvfl[2] = ~A[11] & ~B[11] & RawSum[11];
    assign PosOvfl[3] = ~A[15] & ~B[15] & RawSum[15];
    assign NegOvfl[0] = A[3] & B[3] & ~RawSum[3];
    assign NegOvfl[1] = A[7] & B[7] & ~RawSum[7];
    assign NegOvfl[2] = A[11] & B[11] & ~RawSum[11];
    assign NegOvfl[3] = A[15] & B[15] & ~RawSum[15];
    assign Sum[3:0] = PosOvfl[3] ? 4'h7 : (NegOvfl[3] ? 4'h8 : RawSum[3:0]);
    assign Sum[7:4] = PosOvfl[2] ? 4'h7 : (NegOvfl[2] ? 4'h8 : RawSum[7:4]);
    assign Sum[11:8] = PosOvfl[1] ? 4'h7 : (NegOvfl[1] ? 4'h8 : RawSum[11:8]);
    assign Sum[15:12] = PosOvfl[0] ? 4'h7 : (NegOvfl[0] ? 4'h8 : RawSum[15:12]);
    assign Ovfl = PosOvfl[3] | PosOvfl[2] | PosOvfl[1] | PosOvfl[0] | NegOvfl[3] | NegOvfl[2] | NegOvfl[1] | NegOvfl[0];

    // Instantiations
    CLA iCLA[3:0] (.A(A[15:0]), .B(B[15:0]), .Cin(4'h0), .Sum(RawSum[15:0]), .G(), .P());

endmodule
`default_nettype wire