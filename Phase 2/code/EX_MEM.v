/*
 * File name: EX_MEM.v
 * File Type: Verilog Source
 * Module name: EX_MEM(clk, rst, we, incremented_pc_EX, ALU_result_EX, register_s2_EX, opcode_EX, rd_EX, rs_EX, rt_EX,
 *                     halt_EX, register_we_EX, memory_en_EX, memory_we_EX, write_back_mode_EX, write_back_data_select_EX,
 *                     incremented_pc_MEM, ALU_result_MEM, register_s2_MEM, opcode_MEM, rd_MEM, rs_MEM, rt_MEM, halt_MEM,
 *                     register_we_MEM, memory_en_MEM, memory_we_MEM, write_back_mode_MEM, write_back_data_select_MEM)
 *                     
 * Testbench: None
 * Author: Daniel Zhao
 * Date: 11/10/2023
 * Description: This file contains a register module. being used for the storage of ID/EX pipeline registers. The register
 *              resets synchronously when the reset signal is asserted.
 * Dependent files: reg.v, bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module EX_MEM(clk, rst, we, incremented_pc_EX, ALU_result_EX, register_s2_EX, opcode_EX, rd_EX, rs_EX, rt_EX,
              halt_EX, register_we_EX, memory_en_EX, memory_we_EX, write_back_mode_EX, write_back_data_select_EX,
              incremented_pc_MEM, ALU_result_MEM, register_s2_MEM, opcode_MEM, rd_MEM, rs_MEM, rt_MEM, halt_MEM,
              register_we_MEM, memory_en_MEM, memory_we_MEM, write_back_mode_MEM, write_back_data_select_MEM);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire we; // write enable
    input wire [15:0] incremented_pc_EX; // incremented program counter from EX stage
    input wire [15:0] ALU_result_EX; // ALU result from EX stage
    input wire [15:0] register_s2_EX; // register file source 2 data from EX stage
    input wire [3:0] opcode_EX; // opcode from EX stage
    input wire [3:0] rd_EX; // destination register from EX stage
    input wire [3:0] rs_EX; // source register 1 from EX stage
    input wire [3:0] rt_EX; // source register 2 from EX stage
    input wire halt_EX; // halt signal from EX stage
    input wire register_we_EX; // register file write enable from EX stage
    input wire memory_en_EX; // memory enable from EX stage
    input wire memory_we_EX; // memory write enable from EX stage
    input wire write_back_mode_EX; // write back mode from EX stage
    input wire write_back_data_select_EX; // write back data select from EX stage

    // Outputs
    output wire [15:0] incremented_pc_MEM; // incremented program counter to MEM stage
    output wire [15:0] ALU_result_MEM; // ALU result to MEM stage
    output wire [15:0] register_s2_MEM; // register file source 2 data to MEM stage
    output wire [3:0] opcode_MEM; // opcode to MEM stage
    output wire [3:0] rd_MEM; // destination register to MEM stage
    output wire [3:0] rs_MEM; // source register 1 to MEM stage
    output wire [3:0] rt_MEM; // source register 2 to MEM stage
    output wire halt_MEM; // halt signal to MEM stage
    output wire register_we_MEM; // register file write enable to MEM stage
    output wire memory_en_MEM; // memory enable to MEM stage
    output wire memory_we_MEM; // memory write enable to MEM stage
    output wire write_back_mode_MEM; // write back mode to MEM stage
    output wire write_back_data_select_MEM; // write back data select to MEM stage

    // Instantiations
    // Instantiate 3 registers for incremented_pc, ALU_result, and register_s2
    Register iRd[2:0] (
        .clk({3{clk}}),
        .rst({3{rst}}),
        .D({incremented_pc_EX, ALU_result_EX, register_s2_EX}),
        .we({we, we, we}),
        .re1(3'h7),
        .re2(),
        .line1({incremented_pc_MEM, ALU_result_MEM, register_s2_MEM}),
        .line2()
    );

    // Instantiate 1 register for opcode, rd, rs, and rt
    Register iRo (
        .clk(clk),
        .rst(rst),
        .D({opcode_EX, rd_EX, rs_EX, rt_EX}),
        .we(we),
        .re1(1'b1),
        .re2(),
        .line1({opcode_MEM, rd_MEM, rs_MEM, rt_MEM}),
        .line2()
    );

    // Instantiate 6 bitcells for the control signals
    BitCell iBC[5:0] (
        .clk({6{clk}}),
        .rst({6{rst}}),
        .D({halt_EX, register_we_EX, memory_en_EX, memory_we_EX, write_back_mode_EX, write_back_data_select_EX}),
        .we({6{we}}),
        .re1(6'h3f),
        .re2(),
        .line1({halt_MEM, register_we_MEM, memory_en_MEM, memory_we_MEM, write_back_mode_MEM, write_back_data_select_MEM}),
        .line2()
    );
endmodule
`default_nettype wire