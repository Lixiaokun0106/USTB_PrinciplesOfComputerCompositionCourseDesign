.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start
_start:
    lui $1,0x1000
    ori $1,$1,0x401 # $1=0x10000401
    mtc0 $1,$12 # 将0x10000401写入CP0的status寄存器

_loop:
    j _loop
    nop


