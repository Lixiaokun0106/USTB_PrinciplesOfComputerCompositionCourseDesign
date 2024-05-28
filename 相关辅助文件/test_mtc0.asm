.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start
_start:
    ori $1,$0,0xf # $1=0xf
    mtc0 $1,$11 # 将0xf写入CP0的compare寄存器
    lui $1,0x1000
    ori $1,$1,0x401 # $1=0x10000401
    mtc0 $1,$12 # 将0x10000401写入CP0的status寄存器

_loop:
    j _loop
    nop
