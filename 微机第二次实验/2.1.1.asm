DATA    SEGMENT
        A   DB 	90
        B   DB  -70
        C   DB 	5
        Y   DB 0

DATA    ENDS   

STACK   SEGMENT STACK      ; ��ջ�εĶ���
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
        MOV BL,AL     ;ǰ��μ���������������BL
        
        MOV AL,A
        MOV CL,C
        IMUL CL
        IDIV CL
        ADD AL,BL
        MOV Y,AL       ;�������
        
        PUSH AX 
        MOV CL,4
        SHR AL,CL
        ADD AL,30H
        MOV DL,AL
        MOV AH,02H
        INT 21H         ;����߰�λ
        
        POP AX
        AND AL,0FH
        ADD AL,30H
        MOV DL,AL
        MOV AH,02H
        INT 21H          ;����Ͱ�λ
        
        MOV DL,'H'       ;���H
        MOV AH,02H
        INT 21H
        
        MOV AH,4CH
        INT  21H
CODE    ENDS 
        END START
