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
    wire [15:0] next_pc; // Next program counter
    wire [15:0] incremented_pc; // Incremented program counter (PC + 2)
    wire [15:0] inst; // Instruction
    wire [3:0] opcode; // Opcode
    wire [3:0] rd; // Destination register
    wire [3:0] rs; // Source register 1
    wire [3:0] rt; // Source register 2
    wire [3:0] imm_4bit; // 4-bit immediate
    wire [7:0] imm_8bit; // 8-bit immediate
    wire [8:0] branch_imm; // Branch immediate
    wire [2:0] branch_cond; // Branch condition
    wire [15:0] write_data; // Data to be written to register file
    wire [15:0] register_s1; // Register file source 1 data
    wire [15:0] register_s2; // Register file source 2 data
    wire [15:0] data_immediate; // Data immediate
    wire [15:0] ALU_result; // ALU result
    wire [2:0] flags; // Flags
    wire [15:0] branch_pc; // Branch program counter
    wire [15:0] memory_data_out; // Data memory data output

    // Internal control wires

    wire source_1_select; // Register file source 1 select
    assign source_1_select = (opcode[3:1] == 3'b101);

    wire source_2_select; // Register file source 2 select
    assign source_2_select = (opcode == 4'h9);

    wire register_we; // Register file write enable
    assign register_we = ((opcode[3] == 1'b0) | ((opcode[3:2] == 2'b10) & (opcode[1:0] != 01)) | opcode == 4'hE);

    wire immediate_select; // Select data immediate
    assign immediate_select = opcode[3:1] == 3'b101;

    wire ALU_select; // Select the ALU operand
    assign ALU_select = (opcode[3:2] == 2'b10) | ((opcode[3:2] == 2'b01) & (opcode[1:0] != 2'b11));

    wire branch_mode; // Branch mode
    assign branch_mode = (opcode == 4'hD);

    wire pc_select; // Select the program counter
    assign pc_select = (opcode[3:1] == 3'b110);

    wire memory_en; // Data memory enable
    assign memory_en = (opcode[3:1] == 3'b100);

    wire memory_we; // Data memory write enable
    assign memory_we = (opcode == 4'h9);

    wire write_back_mode; // mode of data to write back
    assign write_back_mode = (opcode == 4'hE);

    wire write_back_data_select; // select data to write back
    assign write_back_data_select = (opcode == 4'h8);

    // Instantiations
    // Fetch
    Register PC(
        .clk(clk),
        .rst(~rst_n),
        .D(next_pc),
        .we(1'b1),
        .re1(1'b1),
        .re2(),
        .line1(pc),
        .line2()
    );
    inst_memory IM(
        .clk(clk),
        .rst(~rst_n),
        .data_out(inst),
        .data_in(),
        .addr(pc),
        .enable(1'b1),
        .wr(1'b0)
    );
    addsub PC_inc(
        .A(pc),
        .B(16'h2),
        .Sub(1'b0),
        .Sum(incremented_pc),
        .Ovfl()
    );

    // Decode
    Decode D(
        .ins(inst),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .opcode(opcode),
        .imd_off(imm_4bit),
        .bran_imd(branch_imm),
        .imd_long(imm_8bit),
        .bran_con(branch_cond),
        .halt(hlt)
    );
    RegisterFile regfile(
        .clk(clk),
        .rst(~rst_n),
        .Src1(source_1_select ? rd : rs),
        .Src2(source_2_select ? rd : rt),
        .Dst(rd),
        .we(register_we),
        .DstData(write_data),
        .Src1Data(register_s1),
        .Src2Data(register_s2)
    );
    assign data_immediate = immediate_select ? {{8{imm_8bit[7]}},imm_8bit[7:0]}: {{12{imm_4bit[3]}},imm_4bit[3:0]};

    // Execute
    ALU alu(
        .clk(clk),
        .rst(~rst_n),
        .In1(register_s1),
        .In2(ALU_select ? data_immediate: register_s2),
        .Opcode(opcode),
        .Out(ALU_result),
        .Flags(flags)
    );
    PC_control branch(
        .C(branch_cond),
        .I(branch_imm),
        .F(flags),
        .PC_in(incremented_pc),
        .mode(branch_mode),
        .reg_val(register_s1),
        .PC_out(branch_pc)
    );
    assign next_pc = pc_select ? branch_pc: (hlt ? pc: incremented_pc);

    // Memory
    data_memory DM(
        .clk(clk),
        .rst(~rst_n),
        .addr(ALU_result),
        .data_in(register_s2),
        .data_out(memory_data_out),
        .enable(memory_en),
        .wr(memory_we)
    );

    // Write Back
    assign write_data = write_back_mode ? incremented_pc : (write_back_data_select ? memory_data_out : ALU_result);
endmodule
`default_nettype wire