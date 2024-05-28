`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 22:31:01
// Design Name: 
// Module Name: Control
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


module Control(
  input rst,
  input [5:0] ct_inst,
  input [5:0] aluct_inst,
  output ct_rf_dst,
  output ct_rf_wen,
  output ct_alu_src,
  output [3:0] ct_alu,
  output ct_mem_wen,
  output ct_mem_ren,
  output ct_data_rf,
  output ct_branch,
  output ct_jump
    );
    wire inst_r ,inst_lw,inst_sw,inst_beq,inst_j,inst_addiu;
    wire [1:0] ct_alu_op;
    ALUCt aluct0(rst,aluct_inst,ct_alu_op,ct_alu);
    assign inst_r = (!ct_inst[5])&&(!ct_inst[4])&&(!ct_inst[3])&&(!ct_inst[2])&&(!ct_inst[1])&&(!ct_inst[0]);
    assign inst_lw = (ct_inst[5])&&(!ct_inst[4])&&(!ct_inst[3])&&(!ct_inst[2])&&(ct_inst[1])&&(ct_inst[0]);
    assign inst_sw = (ct_inst[5])&&(!ct_inst[4])&&(ct_inst[3])&&(!ct_inst[2])&&(ct_inst[1])&&(ct_inst[0]);
    assign inst_beq = (!ct_inst[5])&&(!ct_inst[4])&&(!ct_inst[3])&&(ct_inst[2])&&(!ct_inst[1])&&(!ct_inst[0]);
    assign inst_j = (!ct_inst[5])&&(!ct_inst[4])&&(!ct_inst[3])&&(!ct_inst[2])&&(ct_inst[1])&&(!ct_inst[0]);
    assign inst_addiu= (!ct_inst[5])&&(!ct_inst[4])&&(ct_inst[3])&&(!ct_inst[2])&&(!ct_inst[1])&&(ct_inst[0]);
    assign ct_rf_dst = rst?inst_r:0;
    assign ct_rf_wen = rst?inst_r || inst_lw||inst_addiu:0;
    assign ct_alu_src = inst_lw || inst_sw||inst_addiu;
    assign ct_alu_op[1:0] = {inst_r,inst_beq};
    assign ct_branch = inst_beq;
    assign ct_mem_ren = inst_lw;
    assign ct_mem_wen = inst_sw;
    assign ct_data_rf = inst_lw;
    assign ct_jump = inst_j;
endmodule
