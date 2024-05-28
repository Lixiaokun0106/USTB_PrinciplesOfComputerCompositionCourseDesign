`timescale 1ns / 1ps

`include "bus.v"
`include "segpos.v"
`include "opcode.v"
`include "funct.v"

module ID(
  // from IF stage (PC)
  input   [`ADDR_BUS]     addr,//指令地址pc
  input   [`INST_BUS]     inst,//指令
  // load related signals
  input                   load_related_1,//ex中load指令标志
  input                   load_related_2,//mem中load指令标志
  // regfile channel #1
  output                  reg_read_en_1,
  output  [`REG_ADDR_BUS] reg_addr_1,
  input   [`DATA_BUS]     reg_data_1,
  // regfile channel #2
  output                  reg_read_en_2,
  output  [`REG_ADDR_BUS] reg_addr_2,
  input   [`DATA_BUS]     reg_data_2,
  // stall request
  output                  stall_request,//暂停
  // to IF stage
  output                  branch_flag,//跳转
  output  [`ADDR_BUS]     branch_addr,
  // to EX stage
  output  [`FUNCT_BUS]    funct,//操作码
  output  [`SHAMT_BUS]    shamt,//位移量
  output  [`DATA_BUS]     operand_1,//操作数
  output  [`DATA_BUS]     operand_2,
  // to MEM stage
  output                  mem_read_flag,//mem读信号
  output                  mem_write_flag,//mem写信号
  output                  mem_sign_ext_flag,//mem符号拓展信号
  output  [`MEM_SEL_BUS]  mem_sel,//mem写位置,处理数据的长度
  output  [`DATA_BUS]     mem_write_data,
  // to WB stage (write back to regfile)
  output                  reg_write_en,
  output  [`REG_ADDR_BUS] reg_write_addr,
  output  [`ADDR_BUS]     current_pc_addr//指令地址
);

  // extract information from instruction
  wire[`INST_OP_BUS]    inst_op     = inst[`SEG_OPCODE];//操作码
  wire[`REG_ADDR_BUS]   inst_rs     = inst[`SEG_RS];//寄存器地址
  wire[`REG_ADDR_BUS]   inst_rt     = inst[`SEG_RT];
  wire[`REG_ADDR_BUS]   inst_rd     = inst[`SEG_RD];
  wire[`SHAMT_BUS]      inst_shamt  = inst[`SEG_SHAMT];//偏移量
  wire[`FUNCT_BUS]      inst_funct  = inst[`SEG_FUNCT];//功能码
  wire[`HALF_DATA_BUS]  inst_imm    = inst[`SEG_IMM];//立即数

  // generate output signals
  assign shamt = inst_shamt;
  assign stall_request = load_related_1 || load_related_2;
  assign current_pc_addr = addr;

  // generate address of registers
  RegGen reg_gen(//与寄存器有关的读写信号
    .op             (inst_op),
    .rs             (inst_rs),
    .rt             (inst_rt),
    .rd             (inst_rd),
    .reg_read_en_1  (reg_read_en_1),
    .reg_read_en_2  (reg_read_en_2),
    .reg_addr_1     (reg_addr_1),
    .reg_addr_2     (reg_addr_2),
    .reg_write_en   (reg_write_en),
    .reg_write_addr (reg_write_addr)
  );

  // generate FUNCT signal
  FunctGen funct_gen(//生成功能码信号
    .op       (inst_op),
    .funct_in (inst_funct),
    .funct    (funct)
  );

  // generate operands
  OperandGen operand_gen(//生成操作数
    .addr       (addr),
    .op         (inst_op),
    .funct      (inst_funct),
    .imm        (inst_imm),
    .reg_data_1 (reg_data_1),
    .reg_data_2 (reg_data_2),
    .operand_1  (operand_1),
    .operand_2  (operand_2)
  );

  // generate branch address
  BranchGen branch_gen(//生成分支信号
    .addr         (addr),
    .inst         (inst),
    .op           (inst_op),
    .funct        (inst_funct),
    .reg_data_1   (reg_data_1),
    .reg_data_2   (reg_data_2),
    .branch_flag  (branch_flag),
    .branch_addr  (branch_addr)
  );

  // generate memory accessing signals
  MemGen mem_gen(//生成内存访问相关信号
    .op                 (inst_op),
    .reg_data_2         (reg_data_2),
    .mem_read_flag      (mem_read_flag),
    .mem_write_flag     (mem_write_flag),
    .mem_sign_ext_flag  (mem_sign_ext_flag),
    .mem_sel            (mem_sel),
    .mem_write_data     (mem_write_data)
  );

endmodule // ID
