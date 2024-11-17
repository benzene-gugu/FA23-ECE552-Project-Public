/*
 * File name: PC_ctrl.v
 * File Type: Verilog Source
 * Module name: PC_control(C, I, F, PC_in, PC_out)
 * Testbench: 
 * Author: Daniel Zhao
 * Date: 10/15/2023
 * Description: This module describes the PC control logic. The next PC is determined by the current signal, the control
 *              signal, and the values in the flag registers. The next PC is either PC or PC+(I<<1), depending on the
 *              outcome of the branch. The flag register store the values of Z, N, and V, from high to low. 
 * Dependent files: addsub.v, CLA.v, PFA.v
 */
`default_nettype none
module PC_control(C, I, F, PC_in, mode, reg_val, PC_out);

    // Inputs
    input wire [2:0] C; // Control signal
    input wire [8:0] I; // Immediate value
    input wire [2:0] F; // Flag register values, assuming Z, N, V from high to low
    input wire [15:0] PC_in; // Current incremented PC
    input wire mode; // Mode of branch, 0 for immediate and 1 for register
    input wire [15:0] reg_val; // Register value

    // Outputs
    output wire [15:0] PC_out; // Next PC

    // Internal wires
    wire [15:0] PC_branch_offset; // PC+(I<<1)
    reg condition; // Condition for branch

    // Assignments
    assign PC_out = (condition) ? ((mode) ? (reg_val) : (PC_branch_offset)) : PC_in;

    // Instantiations
    addsub iBranch (
        .A(PC_in[15:0]),
        .B({{6{I[8]}}, I[8:0], 1'b0}),
        .Sub(1'b0),
        .Sum(PC_branch_offset[15:0]),
        .Ovfl()
    );

    // Case statements
    // Case on C to check for branch conditions
    always @(*) begin
        casex (C)
            3'b000: begin // Not Equal
                condition = ~F[2]; // Z = 0
            end
            3'b001: begin // Equal
                condition = F[2]; // Z = 1
            end
            3'b010: begin // Greater Than
                condition = ~F[2] & ~F[1]; // Z = N = 0
            end
            3'b011: begin // Less Than
                condition = F[1]; // N = 1
            end
            3'b100: begin // Greater Than or Equal To
                condition = (F[2]) | (~F[2] & ~F[1]); // Z = 1 or Z = N = 0
            end
            3'b101: begin // Less Than or Equal To
                condition = F[2] | F[1]; // Z = 1 or N = 1
            end
            3'b110: begin // Overflow
                condition = F[0]; // V = 1
            end
            3'b111: begin // Unconditional
                condition = 1'b1;
            end
            default: begin // Default
                condition = 1'b0;
            end
        endcase
    end
endmodule
`default_nettype wire