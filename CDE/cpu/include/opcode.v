//存放opcode字段的内容
`ifndef TINYMIPS_OPCODE_V_
`define TINYMIPS_OPCODE_V_

// r-type (SPECIAL)//r型指令 开头相同 进一步通过funct段进行区别
`define OP_SPECIAL    6'b000000//

// j-type//j型指令
`define OP_JAL        6'b000011

//I型指令 
// branch
`define OP_BEQ        6'b000100
`define OP_BNE        6'b000101

// arithmetic
`define OP_ADDIU      6'b001001//addiu

// immediate
`define OP_LUI        6'b001111

// memory accessing
`define OP_LB         6'b100000
`define OP_LW         6'b100011
`define OP_LBU        6'b100100
`define OP_SB         6'b101000
`define OP_SW         6'b101011

`endif  // TINYMIPS_OPCODE_V_
