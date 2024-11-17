//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/15 15:35:20
// Design Name: 
// Module Name: Decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decode(ins, rd, rs, rt, opcode, imd_off, bran_imd, imd_long, bran_con, halt);
input [15:0] ins;
output [3:0] rd, rs, rt;
output [3:0] opcode;
output [3:0] imd_off;
output [8:0] bran_imd;
output [7:0] imd_long;
output [2:0] bran_con;
output halt;

assign opcode = ins[15:12];
assign rd = ins[11:8];
assign rs = ins[7:4];
assign rt = ins[3:0];
assign imd_off = ins[3:0];
assign bran_imd = ins[8:0];
assign imd_long = ins[7:0];
assign bran_con = ins[11:9];
assign halt = opcode == 4'hF;
    
endmodule
