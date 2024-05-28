`timescale 1ns / 1ps

`include "bus.v"
`include "funct.v"

module EX(
  // from ID stage
  input       [`FUNCT_BUS]    funct,//操作码
  input       [`SHAMT_BUS]    shamt,//位移量
  input       [`DATA_BUS]     operand_1,//操作数
  input       [`DATA_BUS]     operand_2,
  input                       mem_read_flag_in,//mem读信号
  input                       mem_write_flag_in,//mem写信号
  input                       mem_sign_ext_flag_in,//mem符号拓展信号
  input       [`MEM_SEL_BUS]  mem_sel_in,//mem写位置
  input       [`DATA_BUS]     mem_write_data_in,//mem写数据
  input                       reg_write_en_in,//mem写使能
  input       [`REG_ADDR_BUS] reg_write_addr_in,//给wb的写地址
  input       [`ADDR_BUS]     current_pc_addr_in,//当前pc
  // to ID stage (solve data hazards)
  output                      ex_load_flag,//发生load指令
  // to MEM stage
  output                      mem_read_flag_out,//mem读信号
  output                      mem_write_flag_out,//mem写信号
  output                      mem_sign_ext_flag_out,//mem符号拓展信号
  output      [`MEM_SEL_BUS]  mem_sel_out,//mem写位置
  output      [`DATA_BUS]     mem_write_data_out,//mem写数据
  // to WB stage
  output  reg [`DATA_BUS]     result,//计算结果
  output                      reg_write_en_out,//reg写使能
  output      [`REG_ADDR_BUS] reg_write_addr_out,//写地址
  output      [`ADDR_BUS]     current_pc_addr_out//当前pc
);

  // to ID stage
  //在发生内存读时生成正确的访存相关控制信号
  assign ex_load_flag = mem_read_flag_in;
  // to MEM stage
  assign mem_read_flag_out = mem_read_flag_in;
  assign mem_write_flag_out = mem_write_flag_in;
  assign mem_sign_ext_flag_out = mem_sign_ext_flag_in;
  assign mem_sel_out = mem_sel_in;
  assign mem_write_data_out = mem_write_data_in;
  // to WB stage
  assign reg_write_en_out = reg_write_en_in && !mem_write_flag_in;
  assign reg_write_addr_out = reg_write_addr_in;
  assign current_pc_addr_out = current_pc_addr_in;


//计算op2的补码
  // calculate the complement of operand_2
  wire[`DATA_BUS] operand_2_mux =
      (funct == `FUNCT_SUBU || funct == `FUNCT_SLT)
        ? (~operand_2) + 1 : operand_2;

//计算 和
  // sum of operand_1 & operand_2
  wire[`DATA_BUS] result_sum = operand_1 + operand_2_mux;

//是否小于
  // flag of operand_1 < operand_2
  wire operand_1_lt_operand_2 = funct == `FUNCT_SLT ?
        // op1 is negative & op2 is positive
        ((operand_1[31] && !operand_2[31]) ||
          // op1 & op2 is positive, op1 - op2 is negative
          (!operand_1[31] && !operand_2[31] && result_sum[31]) ||
          // op1 & op2 is negative, op1 - op2 is negative
          (operand_1[31] && operand_2[31] && result_sum[31]))
      : (operand_1 < operand_2);



  // calculate result
  always @(*) begin
    case (funct)
      // jump with link & logic
      `FUNCT_JALR, `FUNCT_OR: result <= operand_1 | operand_2;//按位或
      `FUNCT_AND: result <= operand_1 & operand_2;//按位与
      `FUNCT_XOR: result <= operand_1 ^ operand_2;//按位异或
      // comparison
      `FUNCT_SLT, `FUNCT_SLTU: result <= {31'b0, operand_1_lt_operand_2};
      // arithmetic
      `FUNCT_ADDU, `FUNCT_SUBU: result <= result_sum;//加法和减法
      // shift移位操作
      `FUNCT_SLL: result <= operand_2 << shamt;
      `FUNCT_SLLV: result <= operand_2 << operand_1[4:0];
      `FUNCT_SRLV: result <= operand_2 >> operand_1[4:0];
      `FUNCT_SRAV: result <= ({32{operand_2[31]}} << (6'd32 - {1'b0, operand_1[4:0]})) | operand_2 >> operand_1[4:0];
      default: result <= 0;
    endcase
  end

endmodule // EX
