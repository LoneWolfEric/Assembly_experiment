DATA SEGMENT
	SR DB 40,?,20 DUP(0)
	VAR DW 0
	D DW 2
	XS1 DB 'QING SHU RU YI GE BU DA YU 65535 DE SHU ZI:','$'
	XS2 DB 0DH,0AH,'ER JIN ZHI SHU JI SHI:','$'
	M DW 10D       ;10
DATA ENDS
STACK SEGMENT
	DW 100 DUP (?)
STACK ENDS
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA,SS:STACK,ES:DATA
START:	MOV AX,DATA
	MOV DS,AX
	MOV ES,AX
	MOV DX,OFFSET XS1
	MOV AH,09H
	INT 21H
	LEA DX,SR
	MOV AH,0AH
	INT 21H
	CLD
	LEA SI,SR
	LEA DI,VAR
	INC SI      ;指向实际输入的字符数也就是位数
	MOV BL,[SI]  ;BX中存入要转化的字符数
	DEC BL
	INC SI	    ;SI此时指向第一个数字也就是最高位
	CALL SRZH
	LEA DX,XS2
	MOV AH,09H
	INT 21H
	MOV AX,VAR  ;将要输出的字存入AX
	CALL XS
	MOV AH,4CH
	INT 21H
	

SRZH PROC             ;输入转换子程序,将输入的ASCII转为实际数值
	MOV   DX,0    ;累加数存放地
ZH1:    MOV   AX,0
        LODSB             ;从SR串中读出数据
        SUB   AL,30H
        ADD   DX,AX
        MOV   AX,DX
        MUL   M
        MOV   DX,AX
        DEC   BX
        JNZ   ZH1       ;执行到这里的时候已经将百位和十位放置在DX中，且SI指向的是个位
	XOR   AX,AX     ;AX清零
	LODSB           ;将个位数取到AL中  此时si指向的是空格
	SUB AL,30H      ;ASCII转为实际值
	ADD   DX,AX     ;将个位加入，得到正确的数值
        MOV   AX,DX
        STOSW           ;把字数据以16进制存入VAR数据串中
        RET             ;输入转化子程序结束
SRZH    ENDP  
	
XS      PROC		;显示子程序，用于将十六进制的一个字用二进制显示出来
        MOV BX,16D        ;十六位故要循环十六次
ZL1:	CWD		;AX扩展为双字 DX:AX 
	IDIV  D		;采用除以2的方法不断得到每一位数
	PUSH DX		;DX中是余数，也就是当前数字的最低位，入栈
	DEC BX
	JNZ ZL1		;循环执行16次后就转换完毕
	MOV BX,16D
ZL2:	POP DX		;压完一个数后立即出栈进行显示，先出栈的是最高位
	ADD DL,30H      ;从BCD调整为ASCII
	DEC BX          
	MOV AH,2
	INT 21H
	JNZ ZL2         ;循环
	RET		;显示子程序结束
XS ENDP
CODE       ENDS
           END   START