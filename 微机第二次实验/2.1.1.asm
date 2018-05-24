DATA    SEGMENT
        A   DB 	90
        B   DB  -70
        C   DB 	5
        Y   DB 0

DATA    ENDS   

STACK   SEGMENT STACK      ; 堆栈段的定义
        BYTE 64 DUP(0)
STACK   ENDS  

CODE    SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX   
        MOV AL,A
        MOV BL,B
        ADD AL,BL
        MOV BL,AL
        MOV AL,02H
        IMUL BL
        MOV BL,AL     ;前半段计算结束，结果存入BL
        
        MOV AL,A
        MOV CL,C
        IMUL CL
        IDIV CL
        ADD AL,BL
        MOV Y,AL       ;计算结束
        
        PUSH AX 
        MOV CL,4
        SHR AL,CL
        ADD AL,30H
        MOV DL,AL
        MOV AH,02H
        INT 21H         ;输出高八位
        
        POP AX
        AND AL,0FH
        ADD AL,30H
        MOV DL,AL
        MOV AH,02H
        INT 21H          ;输出低八位
        
        MOV DL,'H'       ;输出H
        MOV AH,02H
        INT 21H
        
        MOV AH,4CH
        INT  21H
CODE    ENDS 
        END START
