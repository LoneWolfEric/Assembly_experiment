DATA    SEGMENT
        A   DW 	15786
DATA    ENDS   

STACK   SEGMENT STACK      ; ��ջ�εĶ���
        BYTE 128 DUP(0)
STACK   ENDS  

CODE    SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK

START:  MOV AX,DATA
        MOV DS,AX 
        MOV AX,A            ;�����ִ���AX��
        MOV DX,0
        MOV CX,0            ;CX��Ϊ����������ʼ����֮�����ڼ�¼������λ��
        MOV BX,2            ;�������
         
LP1:    DIV BX              ;��������
        PUSH DX             ;ѹջ����DX
        MOV DX,0            ;���DX����
        INC CX              ;��¼ת����Ķ�����λ��
        CMP AX,0
        JNZ LP1             ;�����û���꣬������
         
LP2:    POP DX              ;��ջ
        ADD DL,30H          ;ת��ΪASCII��
        MOV AH,02H          ;��ʾ���
        INT 21H  
        LOOP LP2

        MOV AH,4CH
        INT  21H
CODE    ENDS 
        END START
