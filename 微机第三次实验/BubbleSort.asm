DATA    SEGMENT  
        NUM1 DB 300,250,280,240,260
        RESULT DB 0,0,0,0,0
DATA    ENDS   

STACK   SEGMENT STACK      ; 堆栈段的定义
        BYTE 128 DUP(0)
STACK   ENDS  

CODE    SEGMENT
ASSUME  CS:CODE,DS:DATA,SS:STACK

START:  MOV AX,DATA
        MOV DS,AX  
        MOV AX,0
        MOV DX,0
        MOV CX,0 
        MOV BX,0
        
        
        
        
        
        
        
LP1:    MOV AH,01
        INT 21H  
        SUB AL,30H          ;换算成数字
        ADD DL,AL           ;加到DL里
        LOOP LP1
        
        CMP DL,9            ;结果没超过9
        JNA DOUT            ;直接输出
                            ;两位数输出
        MOV AX,DX           ;将DX放入AX准备除法
        DIV BL              ;除
        PUSH AX             ;AX保护余数和商
        MOV DL,AL           ;把商放到DL里
        ADD DL,30H          ;转化为ascii输出，输出十位数
        MOV AH,02H
        INT 21H
        POP AX              ;将AX恢复过来，准备输出个位数
        MOV DL,AH           ;将余数放入DL，准备输出
        
DOUT:   ADD DL,30H          ;输出个位
        MOV AH,02H
        INT 21H
        
        MOV AH,4CH
        INT 21H
CODE    ENDS 
        END START
