`timescale 1ns / 1ps

`include "bus.v"

module IFID(
  input               clk,
  input               rst,
  input               stall_current_stage,//暂停当前
  input               stall_next_stage,//暂停下个
  input   [`ADDR_BUS] addr_in,//地址输入
  input   [`INST_BUS] inst_in,//指令输入
  output  [`ADDR_BUS] addr_out,//地址输出
  output  [`INST_BUS] inst_out//指令输出
);
//D触发器
  PipelineDeliver #(`ADDR_BUS_WIDTH) ff_addr(
    clk, rst,
    stall_current_stage, stall_next_stage,
    addr_in, addr_out
  );

  PipelineDeliver #(`INST_BUS_WIDTH) ff_inst(
    clk, rst,
    stall_current_stage, stall_next_stage,
    inst_in, inst_out
  );

endmodule // IFID
