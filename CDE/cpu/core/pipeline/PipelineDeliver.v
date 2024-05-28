`timescale 1ns / 1ps
//带参数模块，其中 WIDTH 就是这里的可变参数，我们可以在实例化模
//块的时候对这一参数进行重新的定义，从而使得我们的D触发器可以存储不同宽度的数据
module PipelineDeliver #(
  parameter WIDTH = 1
) (
  input                     clk,
  input                     rst,
  input                     stall_current_stage,
  input                     stall_next_stage,
  input       [WIDTH - 1:0] in,
  output  reg [WIDTH - 1:0] out
);

  always @(posedge clk) begin
    if (rst) begin
      out <= 0;
    end
    else if (stall_current_stage && !stall_next_stage) begin
      out <= 0;
    end
    else if (!stall_current_stage) begin
      out <= in;
    end
  end

endmodule // PipelineDeliver
