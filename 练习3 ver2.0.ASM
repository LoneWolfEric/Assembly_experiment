DATA SEGMENT
	SUM DW 10
DATA ENDS 
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX
    	CALL SHURU     ;调用输入子程序
	MOV SI,DX
	INC SI	       ;SI加一指向存储输入了多少个字符的位置
	XOR CX,CX      ;将CX清零
	MOV CL,[SI]    ;将实际输入的字符数存入CX做为循环相加次数
	XOR AX,AX      ;将AX清零，做为运算结果的存放之处
	CALL LEIJIA    ;调用累加子程序
	MOV  SUM,AX   ;将运算结果存入SUM中
	CALL XIANSHI   ;调用显示子程序

SHURU PROC
	MOV AH,0AH
	INT 21H
	RET 		;输入子程序结束
SHURU ENDP

LEIJIA PROC
ACC:	INC SI
	MOV BL,[SI]
	SUB BL,30H     ;将ASCII转为非压缩BCD  
	ADC AL,BL      ;累加
	AAA	       ;BCD码调整
	LOOP ACC
	RET
LEIJIA ENDP
	
XIANSHI PROC
	MOV BX,AX      ;将结果存入BX中保护起来
	MOV DL,AH      ;将结果中的十位显示出来
	ADD DL,30H    ;调整为ASCII
	MOV AH,2
	INT 21H
	MOV DL,BL      ;将结果的个位显示出来
	ADD DL,30H     ;调整为ASCII
	MOV AH,02H
	INT 21H
	RET
XIANSHI ENDP

	
CODE ENDS
END START


 
