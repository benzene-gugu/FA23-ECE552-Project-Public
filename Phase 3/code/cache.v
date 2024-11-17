/*
 * File name: cache.v
 * File Type: Verilog Source
 * Module name: cache(clk, rst, addr, data_in, data_out, data_valid, miss_en, enable, wr, mem_enable, mem_wr, mem_addr, mem_in, 
 *                    mem_out, mem_valid, mem_req)
 * Testbench: cache_tb.sv
 * Author: Daniel Zhao
 * Date: 12/15/2023
 * Description: This module contains the general construction of a L1 cache that is being used for the main memory system. 
 *              The cache is byte-addressable, 16-bit wide memory. The cache is a 2-way set associative cache with a total
 *              of 128 cache entries(blocks), 2 entry per 64 sets. Each block will have 8 words. The cache is write-through
 *              and write-allocate. The cache would have a LRU replacement policy. The cache has a 2-cycle hit latency and
 *              a 12-cycle miss latency. 
 * Dependent files: DataArray.v, MetaDataArray.v, D-Flip=Flop.v, decoder_6_64.v, decoder_3_8.v
 */
`default_nettype none
module cache(clk, rst, addr, data_in, data_out, data_valid, miss_en, enable, wr, mem_enable, mem_wr, mem_addr, mem_in, 
            mem_out, mem_valid, mem_req);

    // Inputs
    input wire clk; // Clock input
    input wire rst; // synchronous active high reset
    input wire [15:0] addr; // cache address input for read/write
    input wire [15:0] data_in; // data input for write
    input wire miss_en; // whether to enable the cache for handling a miss
    input wire enable; // whether to enable the cache
    input wire wr; // whether it is to read or write to the cache
    input wire [15:0] mem_out; // data output from the main memory, used for read miss
    input wire mem_valid; // whether the data from the main memory is valid, used for read miss

    // Outputs
    output wire [15:0] data_out; // data output from the cache
    output wire data_valid; // whether the data from the cache is valid
    output wire mem_enable; // whether to enable the main memory for read a block on a miss or write a byte on a write hit
    output wire mem_wr; // whether to write a byte to the main memory on a write hit
    output wire [15:0] mem_addr; // address output to the main memory, used for read miss
    output wire [15:0] mem_in; // data input to the main memory, used for write hit
    output wire [1:0] mem_req; // memory request type to the main memory, used for memory access request

    // Internal wires
    wire [15:0] data_in0; // data input to the first data array
    wire data_write0; // whether to write to the first data array
    wire [63:0] data_block_enable0; // which block to enable for the first data array
    wire [7:0] data_word_enable0; // which word to enable for the block for the first data array
    wire [15:0] data_out0; // data output from the first data array

    wire [15:0] data_in1; // data input to the second data array
    wire data_write1; // whether to write to the second data array
    wire [63:0] data_block_enable1; // which block to enable for the second data array
    wire [7:0] data_word_enable1; // which word to enable for the block for the second data array
    wire [15:0] data_out1; // data output from the second data array

    wire [7:0] meta_data_in0; // meta data input to the first meta data array
    wire meta_data_write0; // whether to write to the first meta data array
    wire [63:0] meta_data_block_enable0; // which block to enable for the first meta data array
    wire [7:0] meta_data_out0; // meta data output from the first meta data array

    wire [7:0] meta_data_in1; // meta data input to the second meta data array
    wire meta_data_write1; // whether to write to the second meta data array
    wire [63:0] meta_data_block_enable1; // which block to enable for the second meta data array
    wire [7:0] meta_data_out1; // meta data output from the second meta data array

    wire [5:0] addr_tag; // tag bits of the address
    wire [5:0] addr_set; // set bits of the address
    wire [3:0] addr_block; // block bits of the address

    wire [63:0] addr_set_decoded; // decoded set bits of the address
    wire [7:0] addr_block_decoded; // decoded block bits of the address

    wire hit0; // whether there is a hit in way 0
    wire hit1; // whether there is a hit in way 1
    wire next_way; // which way to replace in the case of a miss through LRU

    wire [3:0] state; // state of the cache
    wire [3:0] next_state; // next state of the cache
    reg [3:0] next_state_case; // next state of the cache from the case statement

    reg [15:0] state_data_in_0; // data input to the data array 0 from the state machine
    reg [15:0] state_data_in_1; // data input to the data array 1 from the state machine
    reg state_data_write_0; // whether to write to the data array 0 from the state machine
    reg state_data_write_1; // whether to write to the data array 1 from the state machine
    reg [7:0] state_data_word_enable_0; // which word to enable for the block for the data array 0 from the state machine
    reg [7:0] state_data_word_enable_1; // which word to enable for the block for the data array 1 from the state machine
    reg [15:0] state_data_out; // data output from the data arrays from the state machine
    reg state_data_valid; // whether the data from the data arrays is valid from the state machine
    reg [7:0] state_meta_data_in_0; // meta data input to the meta data array 0 from the state machine
    reg [7:0] state_meta_data_in_1; // meta data input to the meta data array 1 from the state machine
    reg state_meta_data_write_0; // whether to write to the meta data array 0 from the state machine
    reg state_meta_data_write_1; // whether to write to the meta data array 1 from the state machine
    reg state_mem_enable; // whether to enable the main memory for read a block on a miss or write a byte on a write hit from the state machine
    reg state_mem_wr; // whether to write a byte to the main memory on a write hit from the state machine
    reg [15:0] state_mem_addr; // address output to the main memory, used for read miss from the state machine
    reg [15:0] state_mem_in; // data input to the main memory, used for write hit from the state machine
    reg state_next_way; // which way to replace in the case of a miss through LRU from the state machine
    reg state_hit0; // whether there is a hit in way 0 from the state machine
    reg state_hit1; // whether there is a hit in way 1 from the state machine
    reg [7:0] state_meta_data_out0; // meta data output from the first meta data array from the state machine
    reg [7:0] state_meta_data_out1; // meta data output from the second meta data array from the state machine
    reg [1:0] state_mem_req; // memory request from the state machine
    reg state_req; // request for the cache from the state machine

    // Assignments
    // Decompose the address into tag, set, and block
    assign addr_tag = addr[15:10];
    assign addr_set = addr[9:4];
    assign addr_block = addr[3:0];

    // Assign control signals for the cache
    assign hit0 = (meta_data_out0[7:2] === 'z) ? '0 : ((meta_data_out0[7:2] == addr_tag) & meta_data_out0[1]);
    assign hit1 = (meta_data_out1[7:2] === 'z) ? '0 : ((meta_data_out1[7:2] == addr_tag) & meta_data_out1[1]);
    assign next_way = meta_data_out1[0]; 
    assign mem_req = state_mem_req;

    // Assign the data input to the data arrays
    assign data_in0 = state_data_in_0;
    assign data_in1 = state_data_in_1;
    
    // Assign additional control signals for the data arrays
    assign data_write0 = enable ? state_data_write_0 : 'b0;
    assign data_write1 = enable ? state_data_write_1 : 'b0;
    assign data_block_enable0 = enable ? addr_set_decoded : 'b0;
    assign data_block_enable1 = enable ? addr_set_decoded : 'b0;
    assign data_word_enable0 = enable ? state_data_word_enable_0 : 'b0;
    assign data_word_enable1 = enable ? state_data_word_enable_1 : 'b0;

    // Assign the data output from the data arrays
    assign data_out = state_data_out;
    assign data_valid = state_data_valid;

    // Assign the meta data input to the meta data arrays
    assign meta_data_in0 = enable ? state_meta_data_in_0 : 'b0;
    assign meta_data_in1 = enable ? state_meta_data_in_1 : 'b0;

    // Assign additional control signals for the meta data arrays
    assign meta_data_write0 = enable ? state_meta_data_write_0 : 'b0;
    assign meta_data_write1 = enable ? state_meta_data_write_1 : 'b0;
    assign meta_data_block_enable0 = enable ? addr_set_decoded : 'b0;
    assign meta_data_block_enable1 = enable ? addr_set_decoded : 'b0;

    // Assign communication signals with the main memory
    assign mem_enable = state_mem_enable;
    assign mem_wr = state_mem_wr;
    assign mem_addr = state_mem_addr;
    assign mem_in = state_mem_in;

    // Assign the output from state machine (reg) to some signals (wires)
    assign next_state = next_state_case;

    // Instantiations
    // 2 Data Arrays for the 2-way set associative cache
    DataArray iDataArray0 (
        .clk(clk),
        .rst(rst),
        .DataIn(data_in0),
        .Write(data_write0),
        .BlockEnable(data_block_enable0),
        .WordEnable(data_word_enable0),
        .DataOut(data_out0)
    );

    DataArray iDataArray1 (
        .clk(clk),
        .rst(rst),
        .DataIn(data_in1),
        .Write(data_write1),
        .BlockEnable(data_block_enable1),
        .WordEnable(data_word_enable1),
        .DataOut(data_out1)
    );

    // 2 Meta Data Arrays for the 2-way set associative cache
    MetaDataArray iMetaDataArray0 (
        .clk(clk),
        .rst(rst),
        .DataIn(meta_data_in0),
        .Write(meta_data_write0),
        .BlockEnable(meta_data_block_enable0),
        .DataOut(meta_data_out0)
    );

    MetaDataArray iMetaDataArray1 (
        .clk(clk),
        .rst(rst),
        .DataIn(meta_data_in1),
        .Write(meta_data_write1),
        .BlockEnable(meta_data_block_enable1),
        .DataOut(meta_data_out1)
    );

    // Use decoders to decode the set bits of the address to one-hot for the data arrays and meta data arrays
    decoder_6_64 iDecoderDataSet0 (
        .id(addr_set),
        .line(addr_set_decoded)
    );

    // Use decoders to decode the block bits of the address to one-hot for the data arrays
    decoder_3_8 iDecoderDataBlock0 (
        .id(addr_block[3:1]),
        .line(addr_block_decoded)
    );

    // D-Flip-Flop to manage the state of the cache
    dff iState[3:0] (
        .clk({4{clk}}),
        .rst({4{rst}}),
        .wen({4{1'b1}}),
        .d(next_state),
        .q(state)
    );

    // Case Statements for state machine for the cache to handle the replacement of the cache contents
    always @* begin
        // Default values for output of the state machine
        next_state_case = state;
        state_data_in_0 = 'b0;
        state_data_in_1 = 'b0;
        state_data_write_0 = 'b0;
        state_data_write_1 = 'b0;
        state_data_word_enable_0 = 'b0;
        state_data_word_enable_1 = 'b0;
        state_data_out = 'b0;
        state_data_valid = 'b0;
        state_meta_data_in_0 = 'b0;
        state_meta_data_in_1 = 'b0;
        state_meta_data_write_0 = 'b0;
        state_meta_data_write_1 = 'b0;
        state_mem_enable = 'bz;
        state_mem_wr = 'bz;
        state_mem_addr = 'bz;
        state_mem_in = 'bz;
        state_mem_req = 'b0;
        state_req = 'b0;
        // Case statement for the state machine
        case(state)
            4'h0: begin // IDLE state. Start transition to the miss states on a miss. Start transition to the hit state on a hit
                state_hit0 = hit0;
                state_hit1 = hit1;
                state_meta_data_out0 = meta_data_out0;
                state_meta_data_out1 = meta_data_out1;
                next_state_case = (enable) ? ((hit0 | hit1) ? 4'hF : ((miss_en) ? 4'h1 : 4'h0)) : 4'h0;
                state_mem_req = (enable) ? ((hit0 | hit1) ? 2'b01 : 2'b10) : 2'b00;
                state_req = (enable) ? ((hit0 | hit1) ? 1'b1 : ((miss_en) ? 1'b1 : 1'b0)) : 4'h0;
            end
            4'h1: begin // Send read request of word 1 to the main memory
                state_data_in_0 = 'b0;
                state_data_in_1 = 'b0;
                state_data_write_0 = 1'b0;
                state_data_write_1 = 1'b0;
                state_data_word_enable_0 = 'b0;
                state_data_word_enable_1 = 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = 'b0;
                state_meta_data_in_1 = 'b0;
                state_meta_data_write_0 = 1'b0;
                state_meta_data_write_1 = 1'b0;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'h0};
                state_mem_in = 'b0;
                state_next_way = next_way;
                state_mem_req = 2'b10;
                next_state_case = 4'h2;
            end
            4'h2: begin // Send read request of word 2 to the main memory
                state_data_in_0 = 'b0;
                state_data_in_1 = 'b0;
                state_data_write_0 = 1'b0;
                state_data_write_1 = 1'b0;
                state_data_word_enable_0 = 'b0;
                state_data_word_enable_1 = 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = 'b0;
                state_meta_data_in_1 = 'b0;
                state_meta_data_write_0 = 1'b0;
                state_meta_data_write_1 = 1'b0;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'h2};
                state_mem_in = 'b0;
                state_next_way = next_way;
                state_mem_req = 2'b10;
                next_state_case = 4'h3;
            end
            4'h3: begin // Send read request of word 3 to the main memory
                state_data_in_0 = 'b0;
                state_data_in_1 = 'b0;
                state_data_write_0 = 1'b0;
                state_data_write_1 = 1'b0;
                state_data_word_enable_0 = 'b0;
                state_data_word_enable_1 = 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = 'b0;
                state_meta_data_in_1 = 'b0;
                state_meta_data_write_0 = 1'b0;
                state_meta_data_write_1 = 1'b0;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'h4};
                state_mem_in = 'b0;
                state_next_way = next_way;
                state_mem_req = 2'b10;
                next_state_case = 4'h4;
            end
            4'h4: begin // Send read request of word 4 to the main memory
                state_data_in_0 = 'b0;
                state_data_in_1 = 'b0;
                state_data_write_0 = 1'b0;
                state_data_write_1 = 1'b0;
                state_data_word_enable_0 = 'b0;
                state_data_word_enable_1 = 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = 'b0;
                state_meta_data_in_1 = 'b0;
                state_meta_data_write_0 = 1'b0;
                state_meta_data_write_1 = 1'b0;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'h6};
                state_mem_in = 'b0;
                state_next_way = next_way;
                state_mem_req = 2'b10;
                next_state_case = 4'h5;
            end
            4'h5: begin // Send read request of word 5 to the main memory, and receive the data from the main memory for word 1
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h01 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h01 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'h8};
                state_mem_in = 'b0;
                state_mem_req = 2'b10;
                next_state_case = 4'h6;
            end
            4'h6: begin // Send read request of word 6 to the main memory, and receive the data from the main memory for word 2
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h02 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h02 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'hA};
                state_mem_in = 'b0;
                state_mem_req = 2'b10;
                next_state_case = 4'h7;
            end
            4'h7: begin // Send read request of word 7 to the main memory, and receive the data from the main memory for word 3
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h04 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h04 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'hC};
                state_mem_in = 'b0;
                state_mem_req = 2'b10;
                next_state_case = 4'h8;
            end
            4'h8: begin // Send read request of word 8 to the main memory, and receive the data from the main memory for word 4
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h08 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h08 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'b1;
                state_mem_wr = 1'b0;
                state_mem_addr = {addr_tag, addr_set, 4'hE};
                state_mem_in = 'b0;
                state_mem_req = 2'b10;
                next_state_case = 4'h9;
            end
            4'h9: begin // Receive the data from the main memory for word 5
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h10 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h10 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'bz;
                state_mem_wr = 1'bz;
                state_mem_addr = 'bz;
                state_mem_in = 'bz;
                state_mem_req = 2'b10;
                next_state_case = 4'hA;
            end
            4'hA: begin // Receive the data from the main memory for word 6
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h20 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h20 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'bz;
                state_mem_wr = 1'bz;
                state_mem_addr = 'bz;
                state_mem_in = 'bz;
                state_mem_req = 2'b10;
                next_state_case = 4'hB;
            end
            4'hB: begin // Receive the data from the main memory for word 7
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h40 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h40 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'bz;
                state_mem_wr = 1'bz;
                state_mem_addr = 'bz;
                state_mem_in = 'bz;
                state_mem_req = 2'b10;
                next_state_case = 4'hC;
            end
            4'hC: begin // Receive the data from the main memory for word 8
                state_data_in_0 = (~state_next_way) ? mem_out : 'b0;
                state_data_in_1 = (state_next_way) ? mem_out : 'b0;
                state_data_write_0 = (~state_next_way);
                state_data_write_1 = (state_next_way);
                state_data_word_enable_0 = (~state_next_way) ? 8'h80 : 'b0;
                state_data_word_enable_1 = (state_next_way) ? 8'h80 : 'b0;
                state_data_out = 'b0;
                state_data_valid = 1'b0;
                state_meta_data_in_0 = (~state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out0[7:1], 1'b0};
                state_meta_data_in_1 = (state_next_way) ? {addr_tag, 2'b10} : {state_meta_data_out1[7:1], 1'b1};
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = 1'bz;
                state_mem_wr = 1'bz;
                state_mem_addr = 'bz;
                state_mem_in = 'bz;
                state_mem_req = 2'b10;
                next_state_case = 4'h0;
            end
            4'hF: begin // Hit state. Send write request to the main memory on a write hit. Read the data from the data arrays on a read hit
                state_data_in_0 = (wr) ? ((state_hit0) ? data_in : 'b0) : 'b0;
                state_data_in_1 = (wr) ? ((state_hit1) ? data_in : 'b0) : 'b0;
                state_data_write_0 = (wr) ? (state_hit0) : 1'b0;
                state_data_write_1 = (wr) ? (state_hit1) : 1'b0;
                state_data_word_enable_0 = addr_block_decoded;
                state_data_word_enable_1 = addr_block_decoded;
                state_data_out = (wr) ? 'b0 : ((state_hit0) ? data_out0 : data_out1);
                state_data_valid = 1'b1;
                state_meta_data_in_0 = (state_hit0) ? {state_meta_data_out0[7:1], 1'b0} : ((state_hit1) ? {state_meta_data_out0[7:1], 1'b1} : 'b0);
                state_meta_data_in_1 = (state_hit0) ? {state_meta_data_out1[7:1], 1'b1} : ((state_hit1) ? {state_meta_data_out1[7:1], 1'b0} : 'b0);
                state_meta_data_write_0 = 1'b1;
                state_meta_data_write_1 = 1'b1;
                state_mem_enable = (wr) ? 1'b1 : 1'bz;
                state_mem_wr = (wr) ? 1'b1 : 1'bz;
                state_mem_addr = (wr) ? addr : 'bz;
                state_mem_in = (wr) ? data_in : 'bz;
                state_mem_req = (wr) ? 2'b01 : 2'b00;
                next_state_case = 4'h0;
            end
            default: begin
                next_state_case = 4'h0;
            end
        endcase
    end
endmodule
`default_nettype wire