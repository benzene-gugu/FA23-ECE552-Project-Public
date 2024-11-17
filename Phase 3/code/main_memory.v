/*
 * File name: main_memory.v
 * File Type: Verilog Source
 * Module name: main_memory(clk, rst, inst_addr, inst_out, inst_miss, data_addr, data_in, data_out, data_enable, data_wr, 
 *                         data_miss)
 * Testbench: None
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This module contains the main memory that is being used with a multi-cycle read memory with two independent
 *              L1 caches for instruction and data. The memory is byte-addressable, 16-bit wide memory. 
 * Dependent files: cache.v, multicycle_memory.v
 */
`default_nettype none
module main_memory(clk, rst, inst_addr, inst_out, inst_miss, data_addr, data_in, data_out, data_enable, data_wr, data_miss);

    // Inputs
    input wire clk; // Clock input
    input wire rst; // synchronous active high reset
    input wire [15:0] inst_addr; // Address for instruction cache
    input wire [15:0] data_addr; // Address for data cache
    input wire [15:0] data_in; // Data input for data cache
    input wire data_enable; // Enable for data cache
    input wire data_wr; // Write enable for data cache

    // Outputs
    output wire [15:0] inst_out; // Data output for instruction cache
    output wire inst_miss; // Instruction cache miss
    output wire [15:0] data_out; // Data output for data cache
    output wire data_miss; // Data cache miss

    // Internal wires
    
    wire [15:0] instruction_out; // Instruction cache output
    wire instruction_valid; // Instruction cache valid
    wire instruction_miss_en; // Instruction cache enable miss handling
    wire instruction_mem_en; // Instruction cache enable memory
    wire instruction_mem_wr; // Instruction cache write enable memory
    wire [15:0] instruction_mem_addr; // Instruction cache address memory
    wire [15:0] instruction_mem_data_in; // Instruction cache data input memory
    wire [15:0] instruction_mem_data_out; // Instruction cache data output memory
    wire instruction_mem_data_valid; // Instruction cache data valid memory
    wire [1:0] instruction_mem_req; // Instruction cache request

    wire [15:0] data_mem_out; // Data cache output
    wire data_valid; // Data cache valid
    wire data_miss_en; // Data cache enable miss handling
    wire data_mem_en; // Data cache enable memory
    wire data_mem_wr; // Data cache write enable memory
    wire [15:0] data_mem_addr; // Data cache address memory
    wire [15:0] data_mem_data_in; // Data cache data input memory
    wire [15:0] data_mem_data_out; // Data cache data output memory
    wire data_mem_data_valid; // Data cache data valid memory
    wire [1:0] data_mem_req; // Data cache request

    wire [15:0] mem_addr; // Memory address
    wire [15:0] mem_data_in; // Memory data input
    wire [15:0] mem_data_out; // Memory data output
    wire mem_data_valid; // Memory data valid
    wire mem_enable; // Memory enable
    wire mem_wr; // Memory write enable

    wire state; // State of the bus for cache-memory communication
    wire next_state; // Next state of the bus for cache-memory communication
    reg next_state_case; // Next state of the bus for cache-memory communication from the state machine
    reg state_instruction_miss_en; // Instruction cache enable miss handling from the state machine
    reg state_data_miss_en; // Data cache enable miss handling from the state machine
    reg state_mem_enable; // Memory enable from the state machine
    reg state_mem_wr; // Memory write enable from the state machine
    reg [15:0] state_mem_addr; // Memory address from the state machine
    reg [15:0] state_mem_data_in; // Memory data input from the state machine
    reg [1:0] state_source; // Source of the bus for cache-memory communication from the state machine

    // Assignments

    assign inst_out = instruction_out; // Instruction cache output
    assign data_out = data_mem_out; // Data cache output
    assign inst_miss = ~instruction_valid; // Instruction cache miss
    assign data_miss = data_enable ? ~data_valid : 1'b0; // Data cache miss

    assign instruction_mem_data_out = mem_data_out; // Instruction cache data output memory
    assign instruction_mem_data_valid = mem_data_valid; // Instruction cache data valid memory
    assign data_mem_data_out = mem_data_out; // Data cache data output memory
    assign data_mem_data_valid = mem_data_valid; // Data cache data valid memory

    assign next_state = next_state_case; // Next state of the bus for cache-memory communication
    assign mem_enable = state_mem_enable; // Memory enable
    assign mem_wr = state_mem_wr; // Memory write enable
    assign mem_addr = state_mem_addr; // Memory address
    assign mem_data_in = state_mem_data_in; // Memory data input
    assign instruction_miss_en = state_instruction_miss_en; // Instruction cache enable miss handling
    assign data_miss_en = state_data_miss_en; // Instruction cache enable memory

    // Instantiations
    // Instruction cache
    cache inst_cache(
        .clk(clk),
        .rst(rst),
        .addr(inst_addr),
        .data_in(16'b0),
        .data_out(instruction_out),
        .data_valid(instruction_valid),
        .miss_en(instruction_miss_en),
        .enable(1'b1),
        .wr(1'b0),
        .mem_enable(instruction_mem_en),
        .mem_wr(instruction_mem_wr),
        .mem_addr(instruction_mem_addr),
        .mem_in(instruction_mem_data_in),
        .mem_out(instruction_mem_data_out),
        .mem_valid(instruction_mem_data_valid),
        .mem_req(instruction_mem_req)
    );

    // Data cache
    cache data_cache(
        .clk(clk),
        .rst(rst),
        .addr(data_addr),
        .data_in(data_in),
        .data_out(data_mem_out),
        .data_valid(data_valid),
        .miss_en(data_miss_en),
        .enable(data_enable),
        .wr(data_wr),
        .mem_enable(data_mem_en),
        .mem_wr(data_mem_wr),
        .mem_addr(data_mem_addr),
        .mem_in(data_mem_data_in),
        .mem_out(data_mem_data_out),
        .mem_valid(data_mem_data_valid),
        .mem_req(data_mem_req)
    );

    // Main memory
    memory4c main_mem(
        .clk(clk),
        .rst(rst),
        .enable(mem_enable),
        .wr(mem_wr),
        .addr(mem_addr),
        .data_in(mem_data_in),
        .data_out(mem_data_out),
        .data_valid(mem_data_valid)
    );

    // State machine through D-Flip-Flop
    dff iState(
        .clk(clk),
        .rst(rst),
        .d(next_state),
        .wen(1'b1),
        .q(state)
    );

    // Case statement for state machine
    always @* begin
        // Default values
        next_state_case = state;
        state_instruction_miss_en = 1'b0;
        state_data_miss_en = 1'b0;
        state_mem_enable = 1'b0;
        state_mem_wr = 1'b0;
        state_mem_addr = 16'b0;
        state_mem_data_in = 16'b0;
        state_source = 2'b00;
        // Case statement for state machine
        case(state)
            1'b0: begin // The bus is idle
                state_instruction_miss_en = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? 1'b0 : (((data_mem_req == 2'b10)) ? 1'b0 : (((instruction_mem_req == 2'b10)) ? 1'b1 : 1'b0));
                state_data_miss_en = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? 1'b0 : (((data_mem_req == 2'b10)) ? 1'b1 : (((instruction_mem_req == 2'b10)) ? 1'b0 : 1'b0));
                state_mem_enable = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? data_mem_en : (((data_mem_req == 2'b10)) ? data_mem_en : (((instruction_mem_req == 2'b10)) ? instruction_mem_en : 1'b0));
                state_mem_wr = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? data_mem_wr : (((data_mem_req == 2'b10)) ? data_mem_wr : (((instruction_mem_req == 2'b10)) ? instruction_mem_wr : 1'b0));
                state_mem_addr = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? data_mem_addr : (((data_mem_req == 2'b10)) ? data_mem_addr : (((instruction_mem_req == 2'b10)) ? instruction_mem_addr : 16'b0));
                state_mem_data_in = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? data_mem_data_in : (((data_mem_req == 2'b10)) ? data_mem_data_in : (((instruction_mem_req == 2'b10)) ? instruction_mem_data_in : 16'b0));
                state_source = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? 2'b01 : (((data_mem_req == 2'b10)) ? 2'b01 : (((instruction_mem_req == 2'b10)) ? 2'b10 : 2'b00));
                next_state_case = ((data_mem_req == 2'b01) & (data_wr == 1'b1)) ? 1'b1 : (((data_mem_req == 2'b10)) ? 1'b1 : (((instruction_mem_req == 2'b10)) ? 1'b1 : 1'b0));
            end
            1'b1: begin // The bus is busy
                state_mem_enable = (state_source == 2'b01) ? data_mem_en : instruction_mem_en;
                state_mem_wr = (state_source == 2'b01) ? data_mem_wr : instruction_mem_wr;
                state_mem_addr = (state_source == 2'b01) ? data_mem_addr : instruction_mem_addr;
                state_mem_data_in = (state_source == 2'b01) ? data_mem_data_in : instruction_mem_data_in;
                state_source = (state_source == 2'b01) ? 2'b01 : 2'b10;
                next_state_case = (state_source == 2'b01) ? ((data_mem_req == 2'b00 | data_valid) ? 1'b0 : 1'b1) : ((instruction_mem_req == 2'b00 | data_valid) ? 1'b0 : 1'b1);
            end
            default: begin
                next_state_case = 1'b0;
            end
        endcase
    end

endmodule
`default_nettype wire