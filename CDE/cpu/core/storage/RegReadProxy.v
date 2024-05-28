`timescale 1ns / 1ps

`include "bus.v"
//先处理ex前递 在处理mem

module RegReadProxy(
  // input from ID stage
  input                       read_en_1,//来自ID阶段读信号与地址
  input                       read_en_2,
  input       [`REG_ADDR_BUS] read_addr_1,
  input       [`REG_ADDR_BUS] read_addr_2,
  // input from regfile
  input       [`DATA_BUS]     data_1_from_reg,//来自寄存器文件的数据
  input       [`DATA_BUS]     data_2_from_reg,
  // input from EX stage (solve data hazards)
  input                       ex_load_flag,
  input                       reg_write_en_from_ex,
  input       [`REG_ADDR_BUS] reg_write_addr_from_ex,
  input       [`DATA_BUS]     data_from_ex,
  // input from MEM stage (solve data hazards)
  input                       mem_load_flag,
  input                       reg_write_en_from_mem,
  input       [`REG_ADDR_BUS] reg_write_addr_from_mem,
  input       [`DATA_BUS]     data_from_mem,
  // load related signals//是否有与加载相关的数据冒险
  output                      load_related_1,
  output                      load_related_2,
  // reg data output (WB stage)//从寄存器读取的数据或者代理的数据
  output  reg [`DATA_BUS]     read_data_1,
  output  reg [`DATA_BUS]     read_data_2
);

  // generate load related signals
  assign load_related_1 =
      (ex_load_flag && read_en_1 && read_addr_1 == reg_write_addr_from_ex) ||
      (mem_load_flag && read_en_1 && read_addr_1 == reg_write_addr_from_mem);
  assign load_related_2 =
      (ex_load_flag && read_en_2 && read_addr_2 == reg_write_addr_from_ex) ||
      (mem_load_flag && read_en_2 && read_addr_2 == reg_write_addr_from_mem);

  // generate output read_data_1
  always @(*) begin
    if (read_en_1) begin
      if (reg_write_en_from_ex &&
          read_addr_1 == reg_write_addr_from_ex) begin
        read_data_1 <= data_from_ex;
      end
      else if (reg_write_en_from_mem &&
          read_addr_1 == reg_write_addr_from_mem) begin
        read_data_1 <= data_from_mem;
      end
      else begin
        read_data_1 <= data_1_from_reg;
      end
    end
    else begin
      read_data_1 <= 0;
    end
  end

  // generate output read_data_2
  always @(*) begin
    if (read_en_2) begin
      if (reg_write_en_from_ex &&
          read_addr_2 == reg_write_addr_from_ex) begin
        read_data_2 <= data_from_ex;
      end
      else if (reg_write_en_from_mem &&
          read_addr_2 == reg_write_addr_from_mem) begin
        read_data_2 <= data_from_mem;
      end
      else begin
        read_data_2 <= data_2_from_reg;
      end
    end
    else begin
      read_data_2 <= 0;
    end
  end

endmodule // RegReadProxy
