`timescale 1ns / 1ps
//对跳转进行判断产生跳转相关信号
`include "bus.v"
`include "opcode.v"
`include "funct.v"

module BranchGen(
  input       [`ADDR_BUS]     addr,//当前指令地址
  input       [`INST_BUS]     inst,//当前指令
  input       [`INST_OP_BUS]  op,//操作码
  input       [`FUNCT_BUS]    funct,//功能码
  input       [`DATA_BUS]     reg_data_1,
  input       [`DATA_BUS]     reg_data_2,
  output  reg                 branch_flag,//跳转标志
  output  reg [`ADDR_BUS]     branch_addr//跳转地址
);

  wire[`ADDR_BUS] addr_plus_4 = addr + 4;
  wire[25:0] jump_addr = inst[25:0];//J型指令的跳转地址
  //offset16进行符号拓展
  wire[`DATA_BUS] sign_ext_imm_sll2 = {{14{inst[15]}}, inst[15:0], 2'b00};//符号拓展并左移两位，处理BEQ或BNQ

  always @(*) begin
    case (op)
      `OP_JAL: begin//跳转到函数
        branch_flag <= 1;
        branch_addr <= {addr_plus_4[31:28], jump_addr, 2'b00};
      end
      `OP_SPECIAL: begin
        if (funct == `FUNCT_JALR) begin//跳转到函数
          branch_flag <= 1;
          branch_addr <= reg_data_1;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      `OP_BEQ: begin//相等跳转
        if (reg_data_1 == reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      `OP_BNE: begin//不等跳转
        if (reg_data_1 != reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
      default: begin
        branch_flag <= 0;
        branch_addr <= 0;
      end
    endcase
  end

endmodule // BranchGen
