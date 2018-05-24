DATA    SEGMENT
        A   DW 	15786
DATA    ENDS   

STACK   SEGMENT STACK      ; 堆栈段的定义
        BYTE 128 DUP(0)
STACK   ENDS  

CODE    SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK

START:  MOV AX,DATA
        MOV DS,AX 
        MOV AX,A            ;将数字存入AX中
        MOV DX,0
        MOV CX,0            ;CX作为计数器，初始化，之后用于记录二进制位数
        MOV BX,2            ;导入除数
         
LP1:    DIV BX              ;除法运算
        PUSH DX             ;压栈保存DX
        MOV DX,0            ;清除DX数据
        INC CX              ;记录转化后的二进制位数
        CMP AX,0
        JNZ LP1             ;如果还没除完，继续除
         
LP2:    POP DX              ;出栈
        ADD DL,30H          ;转化为ASCII码
        MOV AH,02H          ;显示输出
        INT 21H  
        LOOP LP2

        MOV AH,4CH
        INT  21H
CODE    ENDS 
        END START
