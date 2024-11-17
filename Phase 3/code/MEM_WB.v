/*
 * File name: MEM_WB.v
 * File Type: Verilog Source
 * Module name: MEM_WB(clk, rst, we, incremented_pc_MEM, ALU_result_MEM, memory_data_out_MEM, opcode_MEM, rd_MEM, rs_MEM,
 *                     rt_MEM, halt_MEM, register_we_MEM, write_back_mode_MEM, write_back_data_select_MEM, incremented_pc_WB,
 *                     ALU_result_WB, memory_data_out_WB, opcode_WB, rd_WB, rs_WB, rt_WB, halt_WB, register_we_WB,
 *                     write_back_mode_WB, write_back_data_select_WB)
 * Testbench: None
 * Author: Daniel Zhao
 * Date: 11/10/2023
 * Description: This file contains a register module. being used for the storage of ID/EX pipeline registers. The register
 *              resets synchronously when the reset signal is asserted.
 * Dependent files: reg.v, bitcell.v, D-Flip-Flop.v
 */
`default_nettype none
module MEM_WB(clk, rst, we, incremented_pc_MEM, ALU_result_MEM, memory_data_out_MEM, opcode_MEM, rd_MEM, rs_MEM,
              rt_MEM, halt_MEM, register_we_MEM, write_back_mode_MEM, write_back_data_select_MEM, incremented_pc_WB,
              ALU_result_WB, memory_data_out_WB, opcode_WB, rd_WB, rs_WB, rt_WB, halt_WB, register_we_WB,
              write_back_mode_WB, write_back_data_select_WB);

    // Inputs
    input wire clk; // clock
    input wire rst; // synchronous active high reset
    input wire we; // write enable
    input wire [15:0] incremented_pc_MEM; // incremented program counter from MEM stage
    input wire [15:0] ALU_result_MEM; // ALU result from MEM stage
    input wire [15:0] memory_data_out_MEM; // memory data out from MEM stage
    input wire [3:0] opcode_MEM; // opcode from MEM stage
    input wire [3:0] rd_MEM; // destination register from MEM stage
    input wire [3:0] rs_MEM; // source register 1 from MEM stage
    input wire [3:0] rt_MEM; // source register 2 from MEM stage
    input wire halt_MEM; // halt signal from MEM stage
    input wire register_we_MEM; // register file write enable from MEM stage
    input wire write_back_mode_MEM; // write back mode from MEM stage
    input wire write_back_data_select_MEM; // write back data select from MEM stage

    // Outputs
    output wire [15:0] incremented_pc_WB; // incremented program counter to WB stage
    output wire [15:0] ALU_result_WB; // ALU result to WB stage
    output wire [15:0] memory_data_out_WB; // memory data out to WB stage
    output wire [3:0] opcode_WB; // opcode to WB stage
    output wire [3:0] rd_WB; // destination register to WB stage
    output wire [3:0] rs_WB; // source register 1 to WB stage
    output wire [3:0] rt_WB; // source register 2 to WB stage
    output wire halt_WB; // halt signal to WB stage
    output wire register_we_WB; // register file write enable to WB stage
    output wire write_back_mode_WB; // write back mode to WB stage
    output wire write_back_data_select_WB; // write back data select to WB stage

    // Instantiations
    // Instantiate 3 registers for incremented_pc, ALU_result, and memory_data_out
    Register iRd[2:0] (
        .clk({3{clk}}),
        .rst({3{rst}}),
        .D({incremented_pc_MEM, ALU_result_MEM, memory_data_out_MEM}),
        .we({we, we, we}),
        .re1(3'h7),
        .re2(),
        .line1({incremented_pc_WB, ALU_result_WB, memory_data_out_WB}),
        .line2()
    );

    // Instantiate 1 register for opcode, rd, rs, and rt
    Register iRo (
        .clk(clk),
        .rst(rst),
        .D({opcode_MEM, rd_MEM, rs_MEM, rt_MEM}),
        .we(we),
        .re1(1'b1),
        .re2(),
        .line1({opcode_WB, rd_WB, rs_WB, rt_WB}),
        .line2()
    );

    // Instantiate 4 bitcells for the control signals
    BitCell iBC[3:0] (
        .clk({4{clk}}),
        .rst({4{rst}}),
        .D({halt_MEM, register_we_MEM, write_back_mode_MEM, write_back_data_select_MEM}),
        .we({4{we}}),
        .re1(4'hf),
        .re2(),
        .line1({halt_WB, register_we_WB, write_back_mode_WB, write_back_data_select_WB}),
        .line2()
    );
endmodule
`default_nettype wire