`timescale 1ns / 1ps

`include "bus.v"

module PipelineController(
  // stall request signals
  input   request_from_id,//暂停请求
  // stall whole pipeline
  input   stall_all,//cpu外部的暂停信号
  // stall signals for each mid-stage
  output  stall_pc,//暂停pc阶段
  output  stall_if,//暂停if阶段
  output  stall_id,//暂停id阶段
  output  stall_ex,//暂停ex阶段
  output  stall_mem,//暂停mem阶段
  output  stall_wb //暂停wb阶段
);

  reg[5:0] stall;

  // assign the output of the stall signal
  assign {stall_wb, stall_mem, stall_ex,
          stall_id, stall_if, stall_pc} = stall;

  always @(*) begin
    if (stall_all) begin
      stall <= 6'b111111;
    end
    else if (request_from_id) begin
      stall <= 6'b000111;
    end
    else begin
      stall <= 6'b000000;
    end
  end

endmodule // PipelineController
