/*
 * File name: ID_EX.v
 * File Type: Verilog Source
 * Module name: ID_EX(clk, rst, we, incremented_pc_ID, register_s1_ID, register_s2_ID, data_immediate_ID, halt_ID, 
 *                    opcode_ID, rd_ID, rs_ID, rt_ID, register_we_ID, ALU_select_ID, memory_en_ID, memory_we_ID,
 *                    write_back_mode_ID, write_back_data_select_ID, incremented_pc_EX, register_s1_EX, register_s2_EX,
 *                    data_immediate_EX, halt_EX, opcode_EX, rd_EX, rs_EX, rt_EX, register_we_EX, ALU_select_EX,
 *                    memory_en_EX, memory_we_EX, write_back_mode_EX, write_back_data_select_EX)
 * Testbench: None
 * Author: Daniel Zhao
 * Date: 11/10/2023
 * Description: This file contains a register module. being used for the storage of ID/EX pipeline registers. The register
 *              resets synchronously when the reset signal is asserted.
 * Dependent files: reg.v, bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module ID_EX(clk, rst, we, incremented_pc_ID, register_s1_ID, register_s2_ID, data_immediate_ID, halt_ID, 
             opcode_ID, rd_ID, rs_ID, rt_ID, register_we_ID, ALU_select_ID, memory_en_ID, memory_we_ID,
             write_back_mode_ID, write_back_data_select_ID, incremented_pc_EX, register_s1_EX, register_s2_EX,
             data_immediate_EX, halt_EX, opcode_EX, rd_EX, rs_EX, rt_EX, register_we_EX, ALU_select_EX,
             memory_en_EX, memory_we_EX, write_back_mode_EX, write_back_data_select_EX);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire we; // write enable
    input wire [15:0] incremented_pc_ID; // incremented program counter from ID stage
    input wire [15:0] register_s1_ID; // register file source 1 data from ID stage
    input wire [15:0] register_s2_ID; // register file source 2 data from ID stage
    input wire [15:0] data_immediate_ID; // data immediate from ID stage
    input wire halt_ID; // halt signal from ID stage
    input wire [3:0] opcode_ID; // opcode from ID stage
    input wire [3:0] rd_ID; // destination register from ID stage
    input wire [3:0] rs_ID; // source register 1 from ID stage
    input wire [3:0] rt_ID; // source register 2 from ID stage
    input wire register_we_ID; // register file write enable from ID stage
    input wire ALU_select_ID; // ALU select from ID stage
    input wire memory_en_ID; // memory enable from ID stage
    input wire memory_we_ID; // memory write enable from ID stage
    input wire write_back_mode_ID; // write back mode from ID stage
    input wire write_back_data_select_ID; // write back data select from ID stage

    // Outputs
    output wire [15:0] incremented_pc_EX; // incremented program counter to EX stage
    output wire [15:0] register_s1_EX; // register file source 1 data to EX stage
    output wire [15:0] register_s2_EX; // register file source 2 data to EX stage
    output wire [15:0] data_immediate_EX; // data immediate to EX stage
    output wire halt_EX; // halt signal to EX stage
    output wire [3:0] opcode_EX; // opcode to EX stage
    output wire [3:0] rd_EX; // destination register to EX stage
    output wire [3:0] rs_EX; // source register 1 to EX stage
    output wire [3:0] rt_EX; // source register 2 to EX stage
    output wire register_we_EX; // register file write enable to EX stage
    output wire ALU_select_EX; // ALU select to EX stage
    output wire memory_en_EX; // memory enable to EX stage
    output wire memory_we_EX; // memory write enable to EX stage
    output wire write_back_mode_EX; // write back mode to EX stage
    output wire write_back_data_select_EX; // write back data select to EX stage

    // Instantiations

    // Instantiate 4 registers for incremented_pc, register_s1, register_s2, and data_immediate
    Register iRd[3:0] (
        .clk({4{clk}}),
        .rst({4{rst}}),
        .D({incremented_pc_ID, register_s1_ID, register_s2_ID, data_immediate_ID}),
        .we({4{we}}),
        .re1(4'hf),
        .re2(),
        .line1({incremented_pc_EX, register_s1_EX, register_s2_EX, data_immediate_EX}),
        .line2()
    );

    // Instantiate 1 register for opcode, rd, rs, and rt
    Register iRo (
        .clk(clk),
        .rst(rst),
        .D({opcode_ID, rd_ID, rs_ID, rt_ID}),
        .we(we),
        .re1(1'b1),
        .re2(),
        .line1({opcode_EX, rd_EX, rs_EX, rt_EX}),
        .line2()
    );

    // Instantiate 7 bitcells for the control signals
    BitCell iBC[6:0] (
        .clk({7{clk}}),
        .rst({7{rst}}),
        .D({register_we_ID, ALU_select_ID, memory_en_ID, memory_we_ID, write_back_mode_ID, write_back_data_select_ID, halt_ID}),
        .we({7{we}}),
        .re1(7'h7f),
        .re2(),
        .line1({register_we_EX, ALU_select_EX, memory_en_EX, memory_we_EX, write_back_mode_EX, write_back_data_select_EX, halt_EX}),
        .line2()
    );
endmodule
`default_nettype wire