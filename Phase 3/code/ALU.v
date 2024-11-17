/*
 * File name: ALU.v
 * File Type: Verilog Source
 * Module name: ALU(clk, rst, In1, In2, Opcode, Out, Flags, flag_block)
 * Testbench: ALU_tb.sv
 * Author: Daniel Zhao
 * Date: 09/22/2023
 * Description: This module describes the ALU being used for the processor. The ALU takes in two 16-bit inputs and a 4-bit
 *              opcode. The opcode determines the operation to be performed on the two inputs. The ALU outputs a 16-bit
 *              output and a 3-bit flag. The flag is in order of Z, N, V from high to low. The ALU is synchronous and resets
 *              synchronously. Flag would not be enabled if all source registers and the destination registers are all 
 *              register 0. By default, bypassing the Flag is disabled.
 * Dependent files: flag.v, bitcell.v, D-Flip-Flop.v, addsub.v, CLA.v, PFA.v, PSA.v, RED.v, shifter.v
 */
`default_nettype none
module ALU(clk, rst, In1, In2, Opcode, Out, Flags, flag_block);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire [15:0] In1; // input 1
    input wire [15:0] In2; // input 2
    input wire [3:0] Opcode; // opcode
    input wire flag_block; // Whether to block the flag from updates

    // Outputs
    output wire [15:0] Out; // output
    output wire [2:0] Flags; // flags in order of Z, N, V from high to low

    // Internal wires
    wire [15:0] addsubOut; // output of addsub
    wire addsubOvfl; // overflow flag of addsub
    wire [15:0] PSAOut; // output of PSA
    wire [15:0] REDOut; // output of RED
    wire [15:0] shifterOut; // output of shifter
    wire [15:0] DataAddressOut; // output of Data Address Calculation
    wire [2:0] new_flags; // new flags
    wire write_enable; // write enable for flags

    reg [15:0] OutReg; // output register
    reg [2:0] NewFlags; // new flags
    reg SetFlags; // signals whether to set new flags

    // Assignments
    assign Out = OutReg;
    assign new_flags = NewFlags;
    assign write_enable = SetFlags;

    // Instantiations
    // Flag Register
    Flag iFlag (
        .clk(clk),
        .rst(rst),
        .we(write_enable),
        .new_flag(new_flags),
        .flag(Flags)
    );
    // Adder/Subtractor for ADD/SUB
    addsub iaddsub (
        .A(In1),
        .B(In2),
        .Sub(Opcode[0]),
        .Sum(addsubOut),
        .Ovfl(addsubOvfl)
    );
    // Adder/Subtractor for Data Address Calculation
    addsub iDataAddress (
        .A(In1 & 16'hfffe),
        .B({In2[14:0], 1'b0}),
        .Sub(1'b0),
        .Sum(DataAddressOut),
        .Ovfl()
    );
    // Parallel Adder
    PSA iPSA (
        .A(In1),
        .B(In2),
        .Sum(PSAOut),
        .Ovfl()
    );
    // Reducer
    RED iRED (
        .A(In1),
        .B(In2),
        .Sum(REDOut)
    );
    // Shifter
    shifter ishifter (
        .in(In1),
        .amount(In2[3:0]),
        .mode(Opcode[1:0]),
        .out(shifterOut)
    );

    // Case statement
    // Case on Opcode to determine output and flags
    always @* begin
        casex (Opcode)
            4'b000?: begin // addsub
                OutReg = addsubOut;
                NewFlags = {addsubOut == 16'h0000, addsubOut[15], addsubOvfl};
                SetFlags = ~flag_block;
            end
            4'b0010: begin // XOR
                OutReg = In1 ^ In2;
                NewFlags = {OutReg == 16'h0000, Flags[1:0]};
                SetFlags = ~flag_block;
            end
            4'b0011: begin // Reduction
                OutReg = REDOut;
                NewFlags = Flags;
                SetFlags = 1'b0;
            end
            4'b0111: begin // PSA
                OutReg = PSAOut;
                NewFlags = Flags;
                SetFlags = 1'b0;
            end
            4'b01??: begin // shifter
                OutReg = shifterOut;
                NewFlags = {shifterOut == 16'h0000, Flags[1:0]};
                SetFlags = ~flag_block;
            end
            4'b100?: begin // Data Address Calculation
                OutReg = DataAddressOut;
                NewFlags = Flags;
                SetFlags = 1'b0;
            end
            4'b1010: begin // Load Lower Byte
                OutReg = (In1 & 16'hff00) | In2[7:0];
                NewFlags = Flags;
                SetFlags = 1'b0;
            end
            4'b1011: begin // Load Upper Byte
                OutReg = (In1 & 16'h00ff) | {In2[7:0], 8'h00};
                NewFlags = Flags;
                SetFlags = 1'b0;
            end
            default: begin // default
                OutReg = 16'h0000;
                NewFlags = Flags;
                SetFlags = 1'b0;
            end
        endcase
    end
endmodule
`default_nettype wire