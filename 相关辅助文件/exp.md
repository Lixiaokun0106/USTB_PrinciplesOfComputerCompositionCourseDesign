自陷指令：break、syscall异常行为由指令主动触发

break:触发中断异常

syscall:触发系统调用异常

op都是000000，所以要先生成相应的func码

pc正常取指，这两个指令只是为了触发例外，所以直接看exceptiongen生成相应的flag信号，标志信号传至exmem模块给cp0，cp0对异常进行处理



特权指令：eret、mfc0、mtc0

mfc0，mtc0：

正常取指，然后在ID级产生相应的信号，reggen，CP0Gen，对于cp0寄存器的实现已经提供

eret：

正常取指，在ID级expectiongen模块识别出异常，eret_flag=1，并将异常进行整合，在mem生成cp0exc信号，传入cp0，根据eretflag信号修改status状态寄存器，记录上次发生异常的pc也就是reg_epc不变，在pipcontroller模块中生成flush信号，这个信号贯穿始终，进行刷新。重新开始流水线，pc=cp0_epc，也就是cp0的最后一个输出信号reg_epc





一共要实现六种异常：中断、断点、系统调用、地址异常、保留指令、溢出

![image-20231102202536886](C:\Users\hp\AppData\Roaming\Typora\typora-user-images\image-20231102202536886.png)

实现异常处理的过程中实现了与异常相关的指令

收集与一场相关的信息：

![image-20231102203300331](C:\Users\hp\AppData\Roaming\Typora\typora-user-images\image-20231102203300331.png)

还有与地址有关的pc、mem

![image-20231102203518316](C:\Users\hp\AppData\Roaming\Typora\typora-user-images\image-20231102203518316.png)

对不同异常的处理：

![image-20231102204206651](C:\Users\hp\AppData\Roaming\Typora\typora-user-images\image-20231102204206651.png)







对异常的判断总结如下：

pc：对pc地址最后两位进行判断，是否对齐，未对齐则地址异常

![image-20231102204410490](C:\Users\hp\AppData\Roaming\Typora\typora-user-images\image-20231102204410490.png)

这个信号传到ID进行综合



ID：通过exceptionGen模块判断断点、系统调用、保留指令，初步溢出、eret，这些信息会与前面的pc地址异常信息进行综合，为exc，传到EX级



EX：进一步判断溢出，这些信息融合到exc中，同时还有currentpc信息，一起传到MEM级



MEM：进一步判断地址异常，并结合传进来的cp0寄存器内容，exc异常信息，这些信会回传到piplinecontroller模块和cp0寄存器，piplinecontroller会给出异常处理地址。cp0要修改其中寄存器的值。异常处理程序执行完或者eret异常时，flush与更新epc









对中断的总结：

中断是通过特权指令mfc0和mtc0来实现的。





