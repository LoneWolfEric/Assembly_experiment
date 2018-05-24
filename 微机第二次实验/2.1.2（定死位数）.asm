DATA    SEGMENT
        A   DW 	15786
DATA    ENDS   

STACK   SEGMENT STACK      ; ¶ÑÕ»¶ÎµÄ¶¨Òå
        BYTE 128 DUP(0)
STACK   ENDS  

CODE    SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK,DS:DATA 

START:  MOV AX,DATA
        MOV DS,AX 
        MOV AX,A
        MOV DX,0
        MOV BX,2
         
        MOV CX,14
LP1:    
        DIV BX
        PUSH DX
        MOV DH,0 
        CMP AX,0
        LOOP LP1
        
        MOV CX,14  
LP2:    POP DX
        ADD DL,30H
        MOV AH,02H
        INT 21H  
        LOOP LP2

        MOV AH,4CH
        INT  21H
CODE    ENDS 
        END START
