DATA    SEGMENT  
        NUM1 DB 300,250,280,240,260
        RESULT DB 0,0,0,0,0
DATA    ENDS   

STACK   SEGMENT STACK      ; ��ջ�εĶ���
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
        SUB AL,30H          ;���������
        ADD DL,AL           ;�ӵ�DL��
        LOOP LP1
        
        CMP DL,9            ;���û����9
        JNA DOUT            ;ֱ�����
                            ;��λ�����
        MOV AX,DX           ;��DX����AX׼������
        DIV BL              ;��
        PUSH AX             ;AX������������
        MOV DL,AL           ;���̷ŵ�DL��
        ADD DL,30H          ;ת��Ϊascii��������ʮλ��
        MOV AH,02H
        INT 21H
        POP AX              ;��AX�ָ�������׼�������λ��
        MOV DL,AH           ;����������DL��׼�����
        
DOUT:   ADD DL,30H          ;�����λ
        MOV AH,02H
        INT 21H
        
        MOV AH,4CH
        INT 21H
CODE    ENDS 
        END START
