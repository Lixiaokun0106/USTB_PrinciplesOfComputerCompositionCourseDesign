// CPU 内部的寄存器堆，用于存放 MIPS 中使用的 32 个通用寄存器
`timescale 1ns / 1ps

`include "bus.v"

module RegFile(
  input                       clk,//时钟
  input                       rst,//复位
  // read channel #1
  input                       read_en_1,//读使能
  input       [`REG_ADDR_BUS] read_addr_1,//读地址
  output  reg [`DATA_BUS]     read_data_1,//读数据
  // read channel #2
  input                       read_en_2,
  input       [`REG_ADDR_BUS] read_addr_2,
  output  reg [`DATA_BUS]     read_data_2,
  // write channel
  input                       write_en,
  input       [`REG_ADDR_BUS] write_addr,
  input       [`DATA_BUS]     write_data
);
//0 号寄存器不允许写入，任何试图写入 0 号寄存器的操作都应该被忽略
  reg[`DATA_BUS] registers[0:31];
  integer i;

  // writing//写数据操作同步时钟上升沿
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        registers[i] <= 0;
      end
    end
    else if (write_en && |write_addr) begin//排除写地址为0号寄存器
      registers[write_addr] <= write_data;
    end
  end

  // reading #1
  always @(*) begin
    if (rst) begin
      read_data_1 <= 0;
    end
    else if (read_addr_1 == write_addr && write_en && read_en_1) begin
      // forward data to output
      read_data_1 <= write_data;
    end
    else if (read_en_1) begin
      read_data_1 <= registers[read_addr_1];
    end
    else begin
      read_data_1 <= 0;
    end
  end

  // reading @2
  always @(*) begin
    if (rst) begin
      read_data_2 <= 0;
    end
    else if (read_addr_2 == write_addr && write_en && read_en_2) begin
      // forward data to output
      read_data_2 <= write_data;
    end
    else if (read_en_2) begin
      read_data_2 <= registers[read_addr_2];
    end
    else begin
      read_data_2 <= 0;
    end
  end

endmodule // RegFile
