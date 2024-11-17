/*
 * File name: CPU.v
 * File Type: Verilog Source
 * Module name: CPU(clk, rst_n, hlt, pc)
 * Testbench: project-phase1-testbench.sv
 * Author: Daniel Zhao
 * Date: 09/22/2023
 * Description: This module describes the CPU of the processor. The CPU contains a program counter, an instruction memory,
 *              a register file, an ALU, a flag register, and a data memory. The CPU resets synchronously. The CPU outputs
 *              a halt signal when halt and a program counter for debugging purposes. 
 * Dependent files: All files in the code folder
 */
`default_nettype none
module CPU(clk, rst_n, hlt, pc);
    
    // Inputs
    input wire clk; // Clock input
    input wire rst_n; // Active low synchronous reset

    // Outputs
    output wire hlt; // Halt signal
    output wire [15:0] pc; // Program counter

    // Internal data wires
    wire [15:0] next_pc_ID; // Next program counter from ID stage

    wire [15:0] incremented_pc_IF; // Incremented program counter (PC + 2) for IF stage
    wire [15:0] incremented_pc_ID; // Incremented program counter (PC + 2) for ID stage
    wire [15:0] incremented_pc_EX; // Incremented program counter (PC + 2) for EX stage
    wire [15:0] incremented_pc_MEM; // Incremented program counter (PC + 2) for MEM stage
    wire [15:0] incremented_pc_WB; // Incremented program counter (PC + 2) for WB stage

    wire [15:0] inst_IF; // Instruction from IF stage
    wire [15:0] inst_ID; // Instruction from ID stage

    wire [3:0] opcode_ID; // Opcode from ID stage
    wire [3:0] opcode_EX; // Opcode from EX stage
    wire [3:0] opcode_MEM; // Opcode from MEM stage
    wire [3:0] opcode_WB; // Opcode from WB stage

    wire [3:0] rd_ID; // Destination register from ID stage
    wire [3:0] rd_EX; // Destination register from EX stage
    wire [3:0] rd_MEM; // Destination register from MEM stage
    wire [3:0] rd_WB; // Destination register from WB stage

    wire [3:0] rs_ID; // Source register 1 from ID stage
    wire [3:0] rs_EX; // Source register 1 from EX stage
    wire [3:0] rs_MEM; // Source register 1 from MEM stage
    wire [3:0] rs_WB; // Source register 1 from WB stage

    wire [3:0] rt_ID; // Source register 2 from ID stage
    wire [3:0] rt_EX; // Source register 2 from EX stage
    wire [3:0] rt_MEM; // Source register 2 from MEM stage
    wire [3:0] rt_WB; // Source register 2 from WB stage

    wire [3:0] imm_4bit_ID; // 4-bit immediate from ID stage
    wire [7:0] imm_8bit_ID; // 8-bit immediate from ID stage
    wire [8:0] branch_imm_ID; // Branch immediate from ID stage
    wire [2:0] branch_cond_ID; // Branch condition from ID stage

    wire [15:0] write_data_WB; // Data to be written to register file from WB stage

    wire [15:0] register_s1_ID; // Register file source 1 data from ID stage
    wire [15:0] register_s1_EX; // Register file source 1 data from EX stage

    wire [15:0] register_s2_ID; // Register file source 2 data from ID stage
    wire [15:0] register_s2_EX; // Register file source 2 data from EX stage
    wire [15:0] register_s2_MEM; // Register file source 2 data from MEM stage

    wire [15:0] data_immediate_ID; // Data immediate from ID stage
    wire [15:0] data_immediate_EX; // Data immediate from EX stage

    wire [15:0] ALU_result_EX; // ALU result from EX stage
    wire [15:0] ALU_result_MEM; // ALU result from MEM stage
    wire [15:0] ALU_result_WB; // ALU result from WB stage

    wire [2:0] flags_EX; // Flags from EX stage

    wire [15:0] branch_pc_ID; // Branch program counter from ID stage

    wire [15:0] memory_data_out_MEM; // Data memory data output from MEM stage
    wire [15:0] memory_data_out_WB; // Data memory data output from WB stage

    // Internal control wires

    wire register_we_ID; // Register file write enable from ID stage
    wire register_we_EX; // Register file write enable from EX stage
    wire register_we_MEM; // Register file write enable from MEM stage
    wire register_we_WB; // Register file write enable from WB stage
    assign register_we_ID = ((opcode_ID[3] == 1'b0) | 
        ((opcode_ID[3:2] == 2'b10) & (opcode_ID[1:0] != 01)) | opcode_ID == 4'hE);

    wire ALU_select_ID; // Select the ALU operand from ID stage
    wire ALU_select_EX; // Select the ALU operand from EX stage
    assign ALU_select_ID = (opcode_ID[3:2] == 2'b10) | ((opcode_ID[3:2] == 2'b01) & (opcode_ID[1:0] != 2'b11));

    wire memory_en_ID; // Data memory enable from ID stage
    wire memory_en_EX; // Data memory enable from EX stage
    wire memory_en_MEM; // Data memory enable from MEM stage
    assign memory_en_ID = (opcode_ID[3:1] == 3'b100);

    wire memory_we_ID; // Data memory write enable from ID stage
    wire memory_we_EX; // Data memory write enable from EX stage
    wire memory_we_MEM; // Data memory write enable from MEM stage
    assign memory_we_ID = (opcode_ID == 4'h9);

    wire write_back_mode_ID; // mode of data to write back from ID stage
    wire write_back_mode_EX; // mode of data to write back from EX stage
    wire write_back_mode_MEM; // mode of data to write back from MEM stage
    wire write_back_mode_WB; // mode of data to write back from WB stage
    assign write_back_mode_ID = (opcode_ID == 4'hE);

    wire write_back_data_select_ID; // select data to write back
    wire write_back_data_select_EX; // select data to write back
    wire write_back_data_select_MEM; // select data to write back
    wire write_back_data_select_WB; // select data to write back
    assign write_back_data_select_ID = (opcode_ID == 4'h8);

    wire stall_cond; // stall condition

    wire halt_IF; // halt signal from IF stage
    wire halt_ID; // halt signal from ID stage
    wire halt_EX; // halt signal from EX stage
    wire halt_MEM; // halt signal from MEM stage
    wire halt_WB; // halt signal from WB stage
    assign hlt = halt_WB;

    // Instantiations

    // Fetch
    // Flush Control
    wire branch_ID; // Whether the instruction in ID stage is a branch instruction
    assign branch_ID = (opcode_ID[3:1] == 3'b110);
    wire flush_IF; // Whether to flush the processor determined in IF stage
    wire flush_ID; // Whether to flush the processor executed in ID stage
    assign flush_IF = branch_ID & (next_pc_ID != pc);
    wire [15:0] next_pc; // Next program counter
    assign next_pc = (branch_ID & (next_pc_ID == pc)) ? (next_pc_ID) : ((flush_IF) ? (next_pc_ID) : (incremented_pc_IF));
    assign halt_IF = (inst_IF[15:12] == 4'hF);

    Register PC(
        .clk(clk),
        .rst(~rst_n),
        .D(next_pc),
        .we(~halt_IF & ~halt_ID & ~halt_EX & ~halt_MEM & ~halt_WB),
        .re1(1'b1),
        .re2(),
        .line1(pc),
        .line2()
    );
    inst_memory IM(
        .clk(clk),
        .rst(~rst_n),
        .data_out(inst_IF),
        .data_in(),
        .addr(pc),
        .enable(1'b1),
        .wr(1'b0)
    );
    addsub PC_inc(
        .A(pc),
        .B(16'h2),
        .Sub(1'b0),
        .Sum(incremented_pc_IF),
        .Ovfl()
    );
    IF_ID IF_ID_pipeline(
        .clk(clk),
        .rst(~rst_n),
        .we(~stall_cond),
        .inst_IF(inst_IF),
        .incremented_pc_IF(incremented_pc_IF),
        .flush_IF(flush_IF),
        .inst_ID(inst_ID),
        .incremented_pc_ID(incremented_pc_ID),
        .flush_ID(flush_ID)
    );


    // Decode
    // Stall Control
    wire [15:0] inst_ID_ctrl; // Instruction from ID stage after controlling the stall/flush requirements
    wire load_to_use_stall; // Load to use stall condition
    wire ID_source_1_select; // Register file source 1 select
    assign ID_source_1_select = (inst_ID[15:13] == 3'b101);
    wire ID_source_2_select; // Register file source 2 select
    assign ID_source_2_select = (inst_ID[15:12] == 4'h9);
    assign load_to_use_stall = (memory_en_EX & ~memory_we_EX) & (rd_EX != 4'h0) & 
                                ((((ID_source_1_select) ? (rd_EX == inst_ID[11:8]) : (rd_EX == inst_ID[7:4])) | 
                                ((ID_source_2_select) ? (rd_EX == inst_ID[11:8]) : (rd_EX == inst_ID[3:0]))) & 
                                (~(inst_ID[15:12] == 4'h9)));
    wire branch_stall; // Branch stall condition
    wire flag_block; // whether to block the flag update
    wire EX_set_flag; // Whether Flags would be updated in EX stage
    assign EX_set_flag = ~flag_block & ((opcode_EX[3:1] == 3'b000) | (opcode_EX == 4'h2) | 
                                        (opcode_EX[3:1] == 3'b010) | (opcode_EX == 4'h6));
    assign branch_stall = (inst_ID[15:13] == 3'b110) & EX_set_flag;
    wire branch_register_stall; // Branch register stall condition
    assign branch_register_stall = (inst_ID[15:12] == 4'hD) & 
                                    ((register_we_EX & rd_EX == inst_ID[7:4]) | 
                                    (register_we_MEM & rd_MEM == inst_ID[7:4]));
    assign stall_cond = load_to_use_stall | branch_stall | branch_register_stall;
    assign inst_ID_ctrl = (stall_cond | flush_ID) ? (16'h7000) : (inst_ID);

    Decode D(
        .ins(inst_ID_ctrl),
        .rd(rd_ID),
        .rs(rs_ID),
        .rt(rt_ID),
        .opcode(opcode_ID),
        .imd_off(imm_4bit_ID),
        .bran_imd(branch_imm_ID),
        .imd_long(imm_8bit_ID),
        .bran_con(branch_cond_ID),
        .halt(halt_ID)
    );

    wire source_1_select; // Register file source 1 select
    assign source_1_select = (opcode_ID[3:1] == 3'b101);

    wire source_2_select; // Register file source 2 select
    assign source_2_select = (opcode_ID == 4'h9);

    RegisterFile regfile(
        .clk(clk),
        .rst(~rst_n),
        .Src1(source_1_select ? rd_ID : rs_ID),
        .Src2(source_2_select ? rd_ID : rt_ID),
        .Dst(rd_WB),
        .we(register_we_WB),
        .DstData(write_data_WB),
        .Src1Data(register_s1_ID),
        .Src2Data(register_s2_ID)
    );

    wire immediate_select; // Select data immediate
    assign immediate_select = opcode_ID[3:1] == 3'b101;

    assign data_immediate_ID = immediate_select ? {{8{imm_8bit_ID[7]}},imm_8bit_ID[7:0]}: {{12{imm_4bit_ID[3]}},imm_4bit_ID[3:0]};

    wire pc_select; // Select the program counter
    assign pc_select = (opcode_ID[3:1] == 3'b110);

    wire branch_mode; // Branch mode
    assign branch_mode = (opcode_ID == 4'hD);

    PC_control branch(
        .C(branch_cond_ID),
        .I(branch_imm_ID),
        .F(flags_EX),
        .PC_in(incremented_pc_ID),
        .mode(branch_mode),
        .reg_val(register_s1_ID),
        .PC_out(branch_pc_ID)
    );

    wire [15:0] pc_ID; // Program counter from ID stage without incrementing

    addsub PC_dec(
        .A(incremented_pc_ID),
        .B(16'h2),
        .Sub(1'b1),
        .Sum(pc_ID),
        .Ovfl()
    );

    assign next_pc_ID = stall_cond ? pc_ID : (pc_select ? branch_pc_ID: (halt_ID ? pc: incremented_pc_ID));

    ID_EX ID_EX_pipeline(
        .clk(clk),
        .rst(~rst_n),
        .we(1'b1),
        .incremented_pc_ID(incremented_pc_ID),
        .register_s1_ID(register_s1_ID),
        .register_s2_ID(register_s2_ID),
        .data_immediate_ID(data_immediate_ID),
        .halt_ID(halt_ID),
        .opcode_ID(opcode_ID),
        .rd_ID(rd_ID),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .register_we_ID(register_we_ID),
        .ALU_select_ID(ALU_select_ID),
        .memory_en_ID(memory_en_ID),
        .memory_we_ID(memory_we_ID),
        .write_back_mode_ID(write_back_mode_ID),
        .write_back_data_select_ID(write_back_data_select_ID),
        .incremented_pc_EX(incremented_pc_EX),
        .register_s1_EX(register_s1_EX),
        .register_s2_EX(register_s2_EX),
        .data_immediate_EX(data_immediate_EX),
        .halt_EX(halt_EX),
        .opcode_EX(opcode_EX),
        .rd_EX(rd_EX),
        .rs_EX(rs_EX),
        .rt_EX(rt_EX),
        .register_we_EX(register_we_EX),
        .ALU_select_EX(ALU_select_EX),
        .memory_en_EX(memory_en_EX),
        .memory_we_EX(memory_we_EX),
        .write_back_mode_EX(write_back_mode_EX),
        .write_back_data_select_EX(write_back_data_select_EX)
    );


    // Execute
    // Forwarding Control
    wire [15:0] register_s1_EX_FD; // final source 1 data after forwarding
    wire s1_source_EX; // 1 to indicate rd ia the source for register s1 in this stage
    assign s1_source_EX = (opcode_EX[3:1] == 3'b101);
    wire s1_EX_EX; // source 1 data from EX stage
    assign s1_EX_EX = register_we_MEM & (rd_MEM != 4'h0) & ((s1_source_EX) ? (rd_MEM == rd_EX) : (rd_MEM == rs_EX));
    wire s1_MEM_EX; // source 1 data from MEM stage
    assign s1_MEM_EX = register_we_WB & (rd_WB != 4'h0) & ((s1_source_EX) ? (rd_WB == rd_EX) : (rd_WB == rs_EX));
    assign register_s1_EX_FD = (s1_EX_EX) ? (ALU_result_MEM) : ((s1_MEM_EX) ? (write_data_WB) : (register_s1_EX));


    wire [15:0] register_s2_EX_FD; // final source 2 data after forwarding
    wire s2_source_EX; // 1 to indicate rd ia the source for register s2 in this stage
    assign s2_source_EX = (opcode_EX == 4'h9);
    wire s2_EX_EX; // source 2 data from EX stage
    assign s2_EX_EX = register_we_MEM & (rd_MEM != 4'h0) & ((s2_source_EX) ? (rd_MEM == rd_EX) : (rd_MEM == rt_EX));
    wire s2_MEM_EX; // source 2 data from MEM stage
    assign s2_MEM_EX = register_we_WB & (rd_WB != 4'h0) & ((s2_source_EX) ? (rd_WB == rd_EX) : (rd_WB == rt_EX));
    assign register_s2_EX_FD = (s2_EX_EX) ? (ALU_result_MEM) : ((s2_MEM_EX) ? (write_data_WB) : (register_s2_EX));
    
    // Flag block control logic
    wire source1dest1; // 1 source and 1 destination
    assign source1dest1 = (opcode_EX[3:2] == 2'b01);
    wire rs0_rd0; // rs and rd are both 0
    assign rs0_rd0 = (rs_EX == 4'h0) & (rd_EX == 4'h0);
    wire source2dest1; // 2 sources and 1 destination
    assign source2dest1 = (opcode_EX[3:2] == 2'b00);
    wire rs0_rt0_rd0; // rs, rt, and rd are all 0
    assign rs0_rt0_rd0 = rs0_rd0 & (rt_EX == 4'h0);
    assign flag_block = (source1dest1) ? (rs0_rd0) : ((source2dest1) ? (rs0_rt0_rd0) : 1'b0);

    ALU alu(
        .clk(clk),
        .rst(~rst_n),
        .In1(register_s1_EX_FD),
        .In2(ALU_select_EX ? data_immediate_EX: register_s2_EX_FD),
        .Opcode(opcode_EX),
        .Out(ALU_result_EX),
        .Flags(flags_EX),
        .flag_block(flag_block)
    );

    EX_MEM EX_MEM_pipeline(
        .clk(clk),
        .rst(~rst_n),
        .we(1'b1),
        .incremented_pc_EX(incremented_pc_EX),
        .ALU_result_EX(ALU_result_EX),
        .register_s2_EX(register_s2_EX),
        .opcode_EX(opcode_EX),
        .rd_EX(rd_EX),
        .rs_EX(rs_EX),
        .rt_EX(rt_EX),
        .halt_EX(halt_EX),
        .register_we_EX(register_we_EX),
        .memory_en_EX(memory_en_EX),
        .memory_we_EX(memory_we_EX),
        .write_back_mode_EX(write_back_mode_EX),
        .write_back_data_select_EX(write_back_data_select_EX),
        .incremented_pc_MEM(incremented_pc_MEM),
        .ALU_result_MEM(ALU_result_MEM),
        .register_s2_MEM(register_s2_MEM),
        .opcode_MEM(opcode_MEM),
        .rd_MEM(rd_MEM),
        .rs_MEM(rs_MEM),
        .rt_MEM(rt_MEM),
        .halt_MEM(halt_MEM),
        .register_we_MEM(register_we_MEM),
        .memory_en_MEM(memory_en_MEM),
        .memory_we_MEM(memory_we_MEM),
        .write_back_mode_MEM(write_back_mode_MEM),
        .write_back_data_select_MEM(write_back_data_select_MEM)
    );


    // Memory
    // Forwarding Control
    wire [15:0] register_s2_MEM_FD; // final source 2 data after forwarding
    wire s2_source_MEM; // 1 to indicate rd ia the source for register s2 in this stage
    assign s2_source_MEM = (opcode_MEM == 4'h9);
    wire s2_MEM_MEM; // source 2 data from MEM stage
    assign s2_MEM_MEM = register_we_WB & (rd_WB != 4'h0) & ((s2_source_MEM) ? (rd_WB == rd_MEM) : (rd_WB == rt_MEM));
    assign register_s2_MEM_FD = (s2_MEM_MEM) ? (write_data_WB) : (register_s2_MEM);

    data_memory DM(
        .clk(clk),
        .rst(~rst_n),
        .addr(ALU_result_MEM),
        .data_in(register_s2_MEM_FD),
        .data_out(memory_data_out_MEM),
        .enable(memory_en_MEM),
        .wr(memory_we_MEM)
    );

    MEM_WB MEM_WB_pipeline(
        .clk(clk),
        .rst(~rst_n),
        .we(1'b1),
        .incremented_pc_MEM(incremented_pc_MEM),
        .ALU_result_MEM(ALU_result_MEM),
        .memory_data_out_MEM(memory_data_out_MEM),
        .opcode_MEM(opcode_MEM),
        .rd_MEM(rd_MEM),
        .rs_MEM(rs_MEM),
        .rt_MEM(rt_MEM),
        .halt_MEM(halt_MEM),
        .register_we_MEM(register_we_MEM),
        .write_back_mode_MEM(write_back_mode_MEM),
        .write_back_data_select_MEM(write_back_data_select_MEM),
        .incremented_pc_WB(incremented_pc_WB),
        .ALU_result_WB(ALU_result_WB),
        .memory_data_out_WB(memory_data_out_WB),
        .opcode_WB(opcode_WB),
        .rd_WB(rd_WB),
        .rs_WB(rs_WB),
        .rt_WB(rt_WB),
        .halt_WB(halt_WB),
        .register_we_WB(register_we_WB),
        .write_back_mode_WB(write_back_mode_WB),
        .write_back_data_select_WB(write_back_data_select_WB)
    );

    // Write Back
    assign write_data_WB = (write_back_mode_WB) ? (incremented_pc_WB) : 
                        ((write_back_data_select_WB) ? (memory_data_out_WB) : (ALU_result_WB));
endmodule
`default_nettype wire