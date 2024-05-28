`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 23:34:00
// Design Name: 
// Module Name: CPU
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


module CPU(
   input clk,rst
    );
  wire[31:0] inst;
//Contol 模块输出的控制信号
 wire ct_rf_dst,ct_rf_wen,ct_alu_src,ct_data_rf,ct_branch,ct_jump,ct_mem_wen,ct_mem_ren;
wire[3:0] ct_alu;//RegFile 模块的输入输出
wire[4:0] rf_addr_w;
wire[31:0] rf_data_r1,rf_data_r2,rf_data_w;
 //ALU 模块的输入输出
  wire alu_zero;
 wire[31:0] alu_src2;
 wire[31:0] alu_res;
 //符号扩展的结果
 wire[31:0] ext_data;
 //DataMem 的输出
 wire[31:0] mem_data_o;
//选择要写的寄存器地址 
 assign rf_addr_w = ct_rf_dst?inst[15:11]:inst[20:16];
 //选择要写入寄存器堆的数据
 assign rf_data_w = ct_data_rf?mem_data_o:alu_res;
//alu_src2 是指令后 16 位符号扩展的结果或者寄存器堆读的第二寄存器的值
assign ext_data = {{16{inst[15]}},inst[15:0]};
assign alu_src2 = ct_alu_src?ext_data:rf_data_r2; 
 IFU ifu0(clk,rst,alu_zero,ct_branch,ct_jump,inst);
 Control ct0(rst,inst[31:26],inst[5:0],ct_rf_dst,ct_rf_wen,ct_alu_src,ct_alu,ct_mem_wen,ct_mem_ren,ct_data_rf,ct_branch,ct_jump);
 RegFile rf0(clk,ct_rf_wen,inst[25:21],inst[20:16],rf_addr_w,rf_data_w,rf_data_r1,rf_data_r2);
 ALU alu0(rst,ct_alu,rf_data_r1,alu_src2,alu_zero,alu_res);
 DataMem datamem0(clk,ct_mem_wen,ct_mem_ren,alu_res,rf_data_r2,mem_data_o);
endmodule  
