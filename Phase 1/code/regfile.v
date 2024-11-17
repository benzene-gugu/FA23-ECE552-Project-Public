/*
 * File name: regfile.v
 * File Type: Verilog Source
 * Module name: RegisterFile(clk, rst, Src1, Src2, Dst, we, DstData, Src1Data, Src2Data)
 * Testbench: regfile_tb.sv
 * Author: Daniel Zhao
 * Date: 10/12/2023
 * Description: This file contains a register file module. The module stores 16 registers. Each register is 16 bits wide.
 *              The data is stored at the corresponding register on the rising edge of the clock if write enable is asserted.
 *              The data read from the register is available on the line if the source register is selected. By default,
 *              bypassing the register is disabled. Register 0 would be hard wired to 0. 
 * Dependent files: reg.v, bitcell.v, D-Flip-Flop.v, decoder_en.v, decoder.v
 */
`default_nettype none
module RegisterFile (clk, rst, Src1, Src2, Dst, we, DstData, Src1Data, Src2Data);
    
    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire [3:0] Src1; // source register 1
    input wire [3:0] Src2; // source register 2
    input wire [3:0] Dst; // destination register
    input wire we; // write enable
    input wire [15:0] DstData; // data input

    // Outputs
    output wire [15:0] Src1Data; // data output 1
    output wire [15:0] Src2Data; // data output 2

    // Internal wires
    wire [15:0] write_enable; // write enable signal for each register
    wire [15:0] read_enable_1; // read enable 1 signal for each register
    wire [15:0] read_enable_2; // read enable 2 signal for each register
    wire [15:0] write_data; // data to be written to register
    
    // Assignments
    assign write_data = Dst == 4'b000 ? 16'b0 : DstData; // If the destination register is 0, write 0 to the register

    // Instantiations
    decoder_4_16 iRD1 (.id(Src1), .line(read_enable_1)); // Instantiate a 4:16 decoder for read enable 1
    decoder_4_16 iRD2 (.id(Src2), .line(read_enable_2)); // Instantiate a 4:16 decoder for read enable 2
    decoder_en_4_16 iWD (.id(Dst), .en(we), .line(write_enable)); // Instantiate a 4:16 decoder with enable for write enable
    // Instantiate 16 registers
    Register iReg[15:0] (
        .clk({16{clk}}),
        .rst({16{rst}}),
        .D(write_data[15:0]),
        .we(write_enable[15:0]),
        .re1(read_enable_1[15:0]),
        .re2(read_enable_2[15:0]),
        .line1(Src1Data[15:0]),
        .line2(Src2Data[15:0])
    );
endmodule
`default_nettype wire