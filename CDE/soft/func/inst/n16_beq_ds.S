#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n16_beq_ds_test)
    .set noreorder
    addiu s0, s0 ,1
    LI (s2, 0x00)
###test inst
    TEST_BEQ_DS(lui,   t0,0x800d)
    TEST_BEQ_DS(addiu, t1, t0, 0x8123)
    TEST_BEQ_DS(sw,    t1, -0x7120(t0))
    TEST_BEQ_DS(lw,    t2, -0x7120(t0))
    TEST_BEQ_DS(addu,  t3, t1, t2)
    TEST_BEQ_DS(or,    t4, s1, s2)
    TEST_BEQ_DS(slt,   t5, s2, s3)
    TEST_BEQ_DS(sltu,  t8, s2, s3)
    TEST_BEQ_DS(sll,   t1, s2, 0x11)
    TEST_BEQ_DS(subu,  t5, t0, s0)
    TEST_BEQ_DS(and,   t6, t0, s0)
    TEST_BEQ_DS(xor,   t2, t0, s0)
    TEST_BEQ_DS(sllv,  t4, t0, s0)
    TEST_BEQ_DS(srav,  t6, t0, s0)
    TEST_BEQ_DS(srlv,  t8, t0, s0)
###detect exception
    bne s2, zero, inst_error
    nop
###score ++
    addiu s3, s3, 1
###output (s0<<24)|s3
inst_error:  
    sll t1, s0, 24
    or t0, t1, s3 
    sw t0, 0(s1)
    JR (ra)
    nop
END(n16_beq_ds_test)
