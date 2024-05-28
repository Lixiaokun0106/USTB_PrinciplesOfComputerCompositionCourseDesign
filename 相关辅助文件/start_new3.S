#include <asm.h>             ## 包含 asm.h 头文件
#include <regdef.h>          ## 包含 regdef.h 头文件
#include <cpu_cde.h>         ## 包含 cpu_cde.h 头文件

#define TEST_NUM 2           ## 定义宏 TEST_NUM 并设置其值为 2

## 寄存器分配说明:s0, number  s1, number adress  s2, exception use  s3, score  s4, exception pc
## s0, 用于存储数字
## s1, 用于存储数字地址
## s2, 用于异常处理
## s3, 用于分数
## s4, 用于异常程序计数器

.set	noreorder              ## 设置汇编指令不允许重排序
.globl	_start                ## 声明全局标签 _start
.globl	start                ## 声明全局标签 start
.globl	__main                ## 声明全局标签 __main

_start:                       ## 入口标签 _start:
start:                        ## 入口标签 start:

    LI (t0, 0xffffffff)        ## 将 t0 寄存器初始化为 0xffffffff
    addiu t0, zero, 0xffff    ## 将 t0 寄存器的低16位设置为 0xffff
    b locate                   ## 无条件跳转到 locate 标签
    nop                        ## 空操作，什么都不做

## 避免 "j locate" 指令未执行
    lui   t0, 0x8000            ## 将 t0 寄存器的高16位设置为 0x8000
    addiu t1, t1, 1             ## 将 t1 寄存器加1
    or    t2, t0, zero          ## 将 t2 寄存器设置为 t0 和 zero 的按位或
    addu  t3, t5, t6            ## 将 t3 寄存器设置为 t5 和 t6 的无符号整数相加
    lw    t4, 0(t0)             ## 将 t4 寄存器设置为 t0 地址处的32位字的内容
    nop                        ## 空操作，什么都不做

## 避免 CPU 运行错误
.org 0x0ec                    ## 设置当前位置为 0x0ec，可能是特定地址
    lui   t0, 0x8000            ## 将 t0 寄存器的高16位设置为 0x8000
    addiu t1, t1, 1             ## 将 t1 寄存器加1
    or    t2, t0, zero          ## 将 t2 寄存器设置为 t0 和 zero 的按位或
    addu  t3, t5, t6            ## 将 t3 寄存器设置为 t5 和 t6 的无符号整数相加
    lw    t4, 0(t0)             ## 将 t4 寄存器设置为 t0 地址处的32位字的内容

.org 0x100                    ## 设置当前位置为 0x100，可能是特定地址
test_finish:                  ## test_finish 标签
    addiu t0, t0, 1             ## 将 t0 寄存器加1
    LI (t1, 0xff)               ## 将 t1 寄存器设置为 0xff
    LI (t2, UART_ADDR)          ## 将 t2 寄存器设置为 UART_ADDR
    sw t1, 0x0(t2)              ## 将 t1 寄存器的内容存储到 t2 地址处的32位字
    b test_finish                ## 无条件跳转到 test_finish 标签
    nop                         ## 空操作，什么都不做

## 避免 CPU 运行错误
    lui   t0, 0x8000            ## 将 t0 寄存器的高16位设置为 0x8000
    addiu t1, t1, 1             ## 将 t1 寄存器加1
    or    t2, t0, zero          ## 将 t2 寄存器设置为 t0 和 zero 的按位或
    addu  t3, t5, t6            ## 将 t3 寄存器设置为 t5 和 t6 的无符号整数相加
    lw    t4, 0(t0)             ## 将 t4 寄存器设置为 t0 地址处的32位字的内容

/*
 * 异常处理
 */
.org 0x380                      ## 设置当前位置为 0x380，可能是特定地址
1:                            ## 1 标签
    mfhi k0                    ## 将 HI 寄存器的值加载到 k0 寄存器
    mflo k1                    ## 将 LO 寄存器的值加载到 k1 寄存器
    li  k0, 0x800d0000          ## 将 k0 寄存器设置为 0x800d0000
    lw  k1, 0x0(k0)             ## 将 k1 寄存器设置为地址为 k0 加上偏移 0 的32位字的内容
    li  k0, 0x01                ## 将 k0 寄存器设置为 0x01
    beq k1, k0, syscall_ex      ## 如果 k1 和 k0 相等，则跳转到 syscall_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x02                ## 将 k0 寄存器设置为 0x02
    beq k1, k0, break_ex        ## 如果 k1 和 k0 相等，则跳转到 break_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x03                ## 将 k0 寄存器设置为 0x03
    beq k1, k0, overflow_ex     ## 如果 k1 和 k0 相等，则跳转到 overflow_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x04                ## 将 k0 寄存器设置为 0x04
    beq k1, k0, adel_load_ex    ## 如果 k1 和 k0 相等，则跳转到 adel_load_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x05                ## 将 k0 寄存器设置为 0x05
    beq k1, k0, ades_ex         ## 如果 k1 和 k0 相等，则跳转到 ades_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x06                ## 将 k0 寄存器设置为 0x06
    beq k1, k0, adel_if_ex      ## 如果 k1 和 k0 相等，则跳转到 adel_if_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x07                ## 将 k0 寄存器设置为 0x07
    beq k1, k0, reserved_inst_ex ## 如果 k1 和 k0 相等，则跳转到 reserved_inst_ex 标签
    nop                         ## 空操作，什么都不做
    li  k0, 0x08                ## 将 k0 寄存器设置为 0x08
    beq k1, k0, int_ex          ## 如果 k1 和 k0 相等，则跳转到 int_ex 标签
    nop                         ## 空操作，什么都不做

syscall_ex:                   ## syscall_ex 标签
    addu  s2, zero, zero       ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc            ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish      ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做
    mfc0 k0, c0_cause          ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c          ## 将 k0 寄存器的值按位与上 0x7c
    li   k1, 0x20              ## 将 k1 寄存器设置为 0x20
    bne  k0, k1, ex_finish      ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做
    mfc0 k0, c0_status         ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02          ## 将 k0 寄存器的值按位与上 0x02
    li   k1, 0x02              ## 将 k1 寄存器设置为 0x02
    bne  k0, k1, ex_finish      ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做
    lui  s2, 0x1                ## 将 s2 寄存器的高16位设置为 0x1
    b ex_finish                  ## 无条件跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做

break_ex:                     ## break_ex 标签
    addu  s2, zero, zero       ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc            ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish      ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做
    mfc0 k0, c0_cause          ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c          ## 将 k0 寄存器的值按位与上 0x7c
    li   k1, 0x24              ## 将 k1 寄存器设置为 0x24
    bne  k0, k1, ex_finish      ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做
    mfc0 k0, c0_status         ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02          ## 将 k0 寄存器的值按位与上 0x02
    li   k1, 0x02              ## 将 k1 寄存器设置为 0x02
    bne  k0, k1, ex_finish      ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做
    lui  s2, 0x2                ## 将 s2 寄存器的高16位设置为 0x2
    b ex_finish                  ## 无条件跳转到 ex_finish 标签
    nop                         ## 空操作，什么都不做

overflow_ex:               ## overflow_ex 标签
    addu s2, zero, zero    ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc         ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish   ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    mfc0 k0, c0_cause       ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c       ## 将 k0 寄存器的值按位与上 0x7c，提取异常代码位(6到2位)
    li   k1, 0x30           ## 将 k1 寄存器设置为 0x30
    bne  k0, k1, ex_finish   ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_status      ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02       ## 将 k0 寄存器的值按位与上 0x02，检查异常级别(exl位)
    li k1, 0x02             ## 将 k1 寄存器设置为 0x02，表示 exl = 1
    bne k0, k1, ex_finish    ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    lui s2, 0x3             ## 将 s2 寄存器的高16位设置为 0x3
    b ex_finish             ## 无条件跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做

adel_load_ex:              ## adel_load_ex 标签
    addu s2, zero, zero    ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc         ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish   ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_cause       ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c       ## 将 k0 寄存器的值按位与上 0x7c，提取异常代码位(6到2位)
    li   k1, 0x10           ## 将 k1 寄存器设置为 0x10
    bne  k0, k1, ex_finish   ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_status      ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02       ## 将 k0 寄存器的值按位与上 0x02，检查异常级别(exl位)
    li k1, 0x02             ## 将 k1 寄存器设置为 0x02，表示 exl = 1
    bne k0, k1, ex_finish    ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    lui s2, 0x4             ## 将 s2 寄存器的高16位设置为 0x4
    b ex_finish             ## 无条件跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做

ades_ex:                   ## ades_ex 标签
    addu s2, zero, zero    ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc         ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish   ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_cause       ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c       ## 将 k0 寄存器的值按位与上 0x7c，提取异常代码位(6到2位)
    li   k1, 0x14           ## 将 k1 寄存器设置为 0x14
    bne  k0, k1, ex_finish   ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_status      ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02       ## 将 k0 寄存器的值按位与上 0x02，检查异常级别(exl位)
    li k1, 0x02             ## 将 k1 寄存器设置为 0x02，表示 exl = 1
    bne k0, k1, ex_finish    ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    lui s2, 0x5             ## 将 s2 寄存器的高16位设置为 0x5
    b ex_finish             ## 无条件跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做

adel_if_ex:                ## adel_if_ex 标签
    addu s2, zero, zero    ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc         ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish   ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mtc0 s5, c0_epc         ## 将 s5 寄存器的值写入 c0_epc 寄存器
    mfc0 k0, c0_cause       ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c       ## 将 k0 寄存器的值按位与上 0x7c，提取异常代码位(6到2位)
    li   k1, 0x10           ## 将 k1 寄存器设置为 0x10
    bne  k0, k1, ex_finish   ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_status      ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02       ## 将 k0 寄存器的值按位与上 0x02，检查异常级别(exl位)
    li k1, 0x02             ## 将 k1 寄存器设置为 0x02，表示 exl = 1
    bne k0, k1, ex_finish    ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    lui s2, 0x6             ## 将 s2 寄存器的高16位设置为 0x6
    b ex_finish             ## 无条件跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做

reserved_inst_ex:           ## reserved_inst_ex 标签，处理保留指令异常
    addu s2, zero, zero    ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc         ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish   ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_cause       ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x7c       ## 将 k0 寄存器的值按位与上 0x7c，提取异常代码位(6到2位)
    li   k1, 0x28           ## 将 k1 寄存器设置为 0x28
    bne  k0, k1, ex_finish   ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_status      ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02       ## 将 k0 寄存器的值按位与上 0x02，检查异常级别(exl位)
    li k1, 0x02             ## 将 k1 寄存器设置为 0x02，表示 exl = 1
    bne k0, k1, ex_finish    ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    lui s2, 0x7             ## 将 s2 寄存器的高16位设置为 0x7
    b ex_finish             ## 无条件跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做

int_ex:                     ## int_ex 标签，处理中断异常
    addu s2, zero, zero    ## 将 s2 寄存器设置为零
    mfc0 k0, c0_epc         ## 将 c0_epc 寄存器的值加载到 k0 寄存器
    bne  k0, s4, ex_finish   ## 如果 k0 和 s4 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    addiu k0, k0, 8         ## 将 k0 寄存器的值加 8
    mtc0  k0, c0_epc        ## 将 k0 寄存器的值写入 c0_epc 寄存器 (epc+8)
    disable_trace_cmp_s     ## 禁用跟踪比较异常
    mfc0 k0, c0_cause       ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    enable_trace_cmp_s      ## 启用跟踪比较异常
    andi k0, k0, 0x7c       ## 将 k0 寄存器的值按位与上 0x7c，提取异常代码位(6到2位)
    li   k1, 0x00           ## 将 k1 寄存器设置为 0x00
    bne  k0, k1, ex_finish   ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    mfc0 k0, c0_status      ## 将 c0_status 寄存器的值加载到 k0 寄存器
    andi k0, k0, 0x02       ## 将 k0 寄存器的值按位与上 0x02，检查异常级别(exl位)
    li k1, 0x02             ## 将 k1 寄存器设置为 0x02，表示 exl = 1
    bne k0, k1, ex_finish    ## 如果 k0 和 k1 不相等，则跳转到 ex_finish 标签
    nop                    ## 空操作，什么都不做
    li   k0, 0xffffffff     ## 将 k0 寄存器设置为 0xffffffff
    li   k1, 0x00000000     ## 将 k1 寄存器设置为 0x00000000
    mtc0 k0, c0_compare     ## 将 k0 寄存器的值写入 c0_compare 寄存器 (清除比较寄存器)
    mtc0 k1, c0_cause       ## 将 k1 寄存器的值写入 c0_cause 寄存器
    lui s2, 0x8             ## 将 s2 寄存器的高16位设置为 0x8
    b ex_ret                ## 无条件跳转到 ex_ret 标签
    nop                    ## 空操作，什么都不做

ex_finish:                  ## ex_finish 标签，异常处理结束
    mfc0 k0,c0_cause        ## 将 c0_cause 寄存器的值加载到 k0 寄存器
    lui k1,0x8000            ## 将 k1 寄存器的高16位设置为 0x8000
    and k0,k0,k1            ## 将 k0 寄存器的值与 k1 寄存器的值按位与
    mfc0 k1,c0_epc           ## 将 c0_epc 寄存器的值加载到 k1 寄存器
    addiu k1,k1,0x4          ## 将 k1 寄存器的值加 4
    beq k0,zero, 1f          ## 如果 k0 和零相等，则跳转到标签 1f
    nop                      ## 空操作，什么都不做
    addiu k1,k1,0x4          ## 将 k1 寄存器的值加 4
1:                          ## 标签 1
    mtc0  k1,c0_epc          ## 将 k1 寄存器的值写入 c0_epc 寄存器
    nop                      ## 空操作，什么都不做
    bne s2, zero, ex_ret     ## 如果 s2 和零不相等，则跳转到 ex_ret 标签
    nop                      ## 空操作，什么都不做
    lui s2, 0xffff           ## 将 s2 寄存器的高16位设置为 0xffff
ex_ret:                     ## ex_ret 标签，异常处理结束返回
    .set mips32              ## 切换到 MIPS32 指令集
    eret                     ## 执行异常返回指令
    .set mips1               ## 切换回 MIPS1 指令集
    nop                      ## 空操作，什么都不做

locate:
    .set noreorder
    # 初始化一些寄存器
    LI (a0, LED_RG1_ADDR)   # 将 LED_RG1_ADDR 地址加载到寄存器 a0
    LI (a1, LED_RG0_ADDR)   # 将 LED_RG0_ADDR 地址加载到寄存器 a1
    LI (s1, NUM_ADDR)       # 将 NUM_ADDR 地址加载到寄存器 s1
    LI (s7, LED_ADDR)       # 将 LED_ADDR 地址加载到寄存器 s7
    LI (s4, BTN_KEY_ADDR)   # 将 BTN_KEY_ADDR 地址加载到寄存器 s4

    # 为一些常量赋值
    # 双色 LED 灯常量值
    LI (t1, 0x0002)
    LI (t2, 0x0001)

    # 设置 LED 位移量常量值
    LI (t7, 0x0001)

    # 用于清除 LED 的掩码常量值
    LI (t8, 0xffff)

    # 按钮键的常量值
    LI (s8, 0x8000)

    # 用于循环计数的常量
    LI (s6, 1)

    # 用于存储中断状态的变量初始化为 0
    LI (a3, 0)

    # 初始化运行次数的寄存器
    lui s3, 0

    # 将一些常量值存储到相应的寄存器中
    sw t1, 0(a0)  # 将 t1 中的值存储到 LED_RG1_ADDR 地址
    sw t2, 0(a1)  # 将 t2 中的值存储到 LED_RG0_ADDR 地址
    sw s3, 0(s1)  # 将 s3 中的值存储到 NUM_ADDR 地址
    sw t7, 0(s2)  # 将 t7 中的值存储到 BTN_KEY_ADDR 地址

    # 初始化运行次数的寄存器
    lui s0, 0      # 初始化运行次数寄存器 s0 为 0

    LI(t4, 0)      # 初始化 t4 为 0

    LA (t1, kseg1_kseg0)  # 载入 kseg1_kseg0 标签地址到 t1 寄存器
    LI (t2, 0x20000000)   # 设置常量值到 t2

    subu t9, t1, t2      # t9 = t1 - t2，将 kseg1 转换为 kseg0 地址
    JR (t9)              # 跳转到 t9 存储的地址
    nop                  # 空操作

kseg1_kseg0:
inst_test:
    LA (t9, kseg0_kseg1)  # 载入 kseg0_kseg1 标签地址到 t9 寄存器
    JR (t9)              # 跳转到 t9 存储的地址，将 kseg0 转换为 kseg1 地址
    nop                  # 空操作

kseg0_kseg1:
    jal toleft   # 跳转到 toleft 子程序
    nop

kkk:
    lui t4, 0x100  # 将常量 0x100 加载到寄存器 t4
    addu s3, s3, t4  # 计算 s3 + t4 的结果并存储在 s3 中
    sw s3, 0(s1)  # 将 s3 中的值存储到 NUM_ADDR 地址

    jal toright  # 跳转到 toright 子程序
    nop

jjj:
    addiu s3, s3, 1  # 将 s3 加 1
    sw s3, 0(s1)  # 将 s3 中的值存储到 NUM_ADDR 地址

LA (t9, kseg0_kseg1)  # 载入 kseg0_kseg1 标签地址到 t9 寄存器
JR (t9)              # kseg0 -> kseg1，跳转到 kseg1 地址
nop                  # 空操作

### 检查 I/O 访问
LI (a0, IO_SIMU_ADDR)  # 将 IO_SIMU_ADDR 地址加载到寄存器 a0
LI (t0, 0x1234)        # 设置常量 0x1234 到寄存器 t0
sw t0, 0(a0)           # 将 t0 中的值存储到 IO_SIMU_ADDR 地址
lw t1, 0(a0)           # 从 IO_SIMU_ADDR 地址加载值到 t1（t1=0x12340000）
sll t0, t0, 16         # 左移 16 位，将 t0 变为 0x12340000
bne t0, t1, io_err     # 检查 t0 和 t1 是否相等，如果不相等跳转到 io_err
nop

LI (t0, 0x56780000)    # 设置常量 0x56780000 到寄存器 t0
sw t0, 0(a0)           # 将 t0 中的值存储到 IO_SIMU_ADDR 地址
LI (t1, 16)            # 设置常量 16 到寄存器 t1
srlv t0, t0, t1        # 逻辑右移 t0，右移 16 位
lw t1, 0(a0)           # 从 IO_SIMU_ADDR 地址加载值到 t1（t1=0x5678）
bne t0, t1, io_err     # 检查 t0 和 t1 是否相等，如果不相等跳转到 io_err
nop

b test_end  # 跳转到 test_end
nop

io_err:
    addiu s0, s0, 1  # 运行次数加 1
    sw s0, 0(s1)  # 将 s0 中的值存储到 NUM_ADDR 地址

test_end:
    #LI (s0, TEST_NUM)  # 设置常量 TEST_NUM 到寄存器 s0
    #beq s0, s3, 1f  # 如果 s0 和 s3 相等，跳转到标签 1
    #nop

    #LI (a0, LED_ADDR)  # 将 LED_ADDR 地址加载到寄存器 a0
    LI (a1, LED_RG1_ADDR)  # 将 LED_RG1_ADDR 地址加载到寄存器 a1
    LI (a2, LED_RG0_ADDR)  # 将 LED_RG0_ADDR 地址加载到寄存器 a2

    LI (t1, 0x0002)  # 设置常量 0x0002 到寄存器 t1

    #sw zero, 0(a0)  # 将零值存储到 LED 地址
    sw t1, 0(a1)  # 将 t1 中的值存储到 LED_RG1_ADDR 地址
    sw t1, 0(a2)  # 将 t1 中的值存储到 LED_RG0_ADDR 地址

    b 2f  # 跳转到标签 2
    nop

1:
    LI (t1, 0x0001)  # 设置常量 0x0001 到寄存器 t1
    LI (a0, LED_RG1_ADDR)  # 将 LED_RG1_ADDR 地址加载到寄存器 a0
    LI (a1, LED_RG0_ADDR)  # 将 LED_RG0_ADDR 地址加载到寄存器 a1
    sw t1, 0(a0)  # 将 t1 中的值存储到 LED_RG1_ADDR 地址
    sw t1, 0(a1)  # 将 t1 中的值存储到 LED_RG0_ADDR 地址

2:
    jal test_finish  # 调用 test_finish 子程序
    nop

wait_1s:
    LI (t0, SW_INTER_ADDR)  # 加载 SW_INTER_ADDR 地址到寄存器 t0
    LI (t1, 0xaaaa)         # 设置常量 0xaaaa 到寄存器 t1

    # 初始化 t3
    lw t2, 0x0(t0)  # 从 SW_INTER_ADDR 地址加载值到 t2（switch_interleave: {switch[7],1'b0, switch[6],1'b0...switch[0],1'b0}）
    xor t2, t2, t1   # t2 = t2 XOR t1
    sll t3, t2, 9     # t3 = switch interleave 左移 9 位
    addiu t3, t3, 1

sub1:
    addiu t3, t3, -1  # t3 减 1

    # 选择 min{t3, switch_interleave}
    lw t2, 0x0(t0)  # 从 SW_INTER_ADDR 地址加载值到 t2（switch_interleave: {switch[7],1'b0, switch[6],1'b0...switch[0],1'b0}）
    xor t2, t2, t1   # t2 = t2 XOR t1
    sll t2, t2, 9     # switch interleave 左移 9 位
    sltu t4, t3, t2   # 比较 t3 和 t2，将结果存储在 t4 中
    bnez t4, 1f  # 如果 t4 不等于零，跳转到标签 1
    nop
    addu t3, t2, 0

1:
    bne t3, zero, sub1  # 如果 t3 不等于零，跳转到 sub1
    nop
    JR (ra)  # 返回到调用者
    nop

.data
isPaused: .word 0  # 用于表示 LED 流动状态的变量，0 表示继续，1 表示暂停

.text
toleft:
    # 切换 LED 流动状态（暂停/继续）
    lw t0, isPaused
    xori t0, t0, 1
    sw t0, isPaused

    jal wait_1s
    nop

    # 其余 toleft 逻辑
    lw a3, 0(s4)
    LI (t5, 0x8000)
    beq a3, t5, toright
    nop
    bne t7, s8, toleft
    nop
    J kkk
    nop

toright:
    # 切换 LED 流动状态（暂停/继续）
    lw t0, isPaused
    xori t0, t0, 1
    sw t0, isPaused

    jal wait_1s
    nop
    lw a3, 0(s4)
    LI (t5, 0x1)
    beq a3, t5, toleft
    nop
    bne t7, s6, toright
    nop
    J jjj
    nop
