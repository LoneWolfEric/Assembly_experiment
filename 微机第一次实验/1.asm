DATA	SEGMENT
A	DB	9,6,8,7,5
B	DB	5
C	DB 	5 DUP (0)
N	EQU	5
DATA	ENDS
CODE	SEGMENT
ASSUME	CS:CODE;DS:DATA;ES:DATA,

START:	MOV	AX,DATA
    	MOV	DS, AX
    	MOV	ES, AX
    	CLD
    	LEA	SI, A
    	LEA	DI, C
    	MOV	CX, N
    	MOV	AH, 0
LP1:    LODSB          ;一位位除
    	AAD
    	DIV	B
    	STOSB
    	LOOP	LP1
    	MOV	CX, N
    	LEA	DI, C
LP2:    MOV	DL, [DI]    ;显示结果
    	ADD	DL,30H
    	MOV	AH, 2 
    	INT	21H
    	INC	DI
    	LOOP	LP2
    	MOV	AH, 4CH
        INT	21H
CODE    ENDS
	    END	START
