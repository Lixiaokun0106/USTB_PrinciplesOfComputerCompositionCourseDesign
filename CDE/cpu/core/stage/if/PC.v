`timescale 1ns / 1ps
//主要功能用于更新指令地址，并将指令地址传输给 ROM
`include "bus.v"
`include "pcdef.v"

module PC(
  input                       clk,
  input                       rst,
  // stall signal
  input                       stall_pc,//用于暂停pc
  // branch control
  input                       branch_flag,//跳转信号
  input       [`ADDR_BUS]     branch_addr,//跳转地址
  // to ID stage
  output  reg [`ADDR_BUS]     pc,//当前指令的pc值
  // ROM control
  output  reg                 rom_en,
  output      [`MEM_SEL_BUS]  rom_write_en,
  output      [`ADDR_BUS]     rom_addr,
  output      [`DATA_BUS]     rom_write_data
);

  reg[`ADDR_BUS] next_pc;

  assign rom_addr = next_pc;
  assign rom_write_en = 0;
  assign rom_write_data = 0;

  // generate value of next PC
  always @(*) begin
    if (!stall_pc) begin
      if (branch_flag) begin//处理跳转
        next_pc <= branch_addr;
      end
      else begin
        next_pc <= pc + 4;
      end
    end
    else begin
      // pc & rom_addr stall暂停
      next_pc <= pc;
    end
  end
//当 rst
//信号为 1 时，且在时钟上升沿时进行复位，将 rom_en 使能置为 0；当 rst 不为 1 时，rom_en
//置 1
  always @(posedge clk) begin
    rom_en <= !rst;
  end

  always @(posedge clk) begin
    if (!rom_en) begin
      pc <= `INIT_PC - 4;
    end
    else if (!stall_pc) begin
      pc <= next_pc;
    end
  end

endmodule // PC
