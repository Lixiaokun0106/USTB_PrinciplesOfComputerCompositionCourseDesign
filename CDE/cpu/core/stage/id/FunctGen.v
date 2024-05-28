`timescale 1ns / 1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"

module FunctGen(
  input       [`INST_OP_BUS]  op,
  input       [`FUNCT_BUS]    funct_in,
  output  reg [`FUNCT_BUS]    funct
);

  // generating FUNCT signal in order for the ALU to perform operations
  always @(*) begin
    case (op)
      `OP_SPECIAL: funct <= funct_in;//i型指令
      `OP_LUI: funct <= `FUNCT_OR;//逻辑或
      `OP_LB, `OP_LBU, `OP_LW,
      `OP_SB, `OP_SW, `OP_ADDIU: funct <= `FUNCT_ADDU;//逻辑加
      `OP_JAL: funct <= `FUNCT_OR;
      default: funct <= `FUNCT_NOP;//6’b111111
    endcase
  end

endmodule // FunctGen
