DATA    SEGMENT  
        NUM1 DW 300,250,280,240,260
        ;RESULT DW 0,0,0,0,0
        ;COUNTER DB 0
        INPUT_NUM DW 0              ;输入第几个数  
        INPUT_NUM_COUNTER DW 0      ;用于计数
        DIGIT DW 0                  ;输入几位数（暂存）
        WEIGHT DB 0                 ;权重
        TEMP_SUM DW 0               ;临时和
        
        INPUT_NUM_STRING DB 'How many number do you want to input:$'    ;提示输入多少个数字
        START_INPUT DB 'You can input now:(if your input less than 100,you can input space to stop input)$'
        INPUT_SHOW DB 'What you have just input are showed below:$' 
        SORTED_RESULT DB 'the sorted version is showed below:$' 
        
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
        MOV SI,0
          
        MOV DX,OFFSET INPUT_NUM_STRING
        MOV AH,09H
        INT 21H
        
        MOV AH,01
        INT 21H
        SUB AL,30H
        
        MOV AH,0
        
        MOV INPUT_NUM,AX
        MOV INPUT_NUM_COUNTER,AX
        
        MOV DL,0DH               ;回车换行
        MOV AH,02H
        INT 21H
        MOV DL,0AH
        MOV AH,02H
        INT 21H
        
        MOV DX,OFFSET START_INPUT
        MOV AH,09H
        INT 21H
        
NNM_LP: 
        MOV AX,0
        MOV DX,0
        MOV CX,0 
        MOV BX,0
        MOV DIGIT,0
        MOV WEIGHT,0
        MOV TEMP_SUM,0
          
        MOV BL,10
INPUT:  MOV CX,03
IN_LP:  MOV AH,01
        INT 21H 
        MOV AH,0
        CMP AL,20H
        JZ IN_DONE
        SUB AL,30H
        PUSH AX       
        LOOP IN_LP

IN_DONE:MOV DIGIT,CX
        MOV CX,3
        SUB CX,DIGIT
        ADD WEIGHT,1
        
CAL_LP: POP AX
        MUL WEIGHT           ;设置权重
        ADD TEMP_SUM,AX      ;加入到临时计算区
        MOV AL,WEIGHT
        MUL BL
        MOV WEIGHT,AL        ;更新新的权重
        LOOP CAL_LP       
        ;MOV AH,01
        ;INT 21H  
        ;SUB AL,30H          ;换算成数字
        ;ADD DL,AL           ;加到DL里
        ;LOOP LP1 
        PUSH AX
        
        MOV AX,TEMP_SUM
        MOV [SI],AX
        ADD SI,2       
        
        SUB INPUT_NUM_COUNTER,1
        JNZ NNM_LP
        
        
        
        MOV DL,0DH               ;回车换行
        MOV AH,02H
        INT 21H
        MOV DL,0AH
        MOV AH,02H
        INT 21H
        
        
        MOV CX,INPUT_NUM
        MOV SI,0 
        
        MOV DX,OFFSET INPUT_SHOW
        MOV AH,09H
        INT 21H
        
LP1:    MOV AX,[SI] 
        CALL SHOW
          
        ;MOV DL,20H           ;将余数放入DL，准备输出
        ;MOV AH,02H
        ;INT 21H
        
        ADD SI,2
        LOOP LP1                 
                                 ;显示输出结束
        MOV CX,5
        MOV DI,CX                ;外循环的CX用DI做代理，代替CX的功能
LP3:    MOV CX,5
        PUSH BX
        MOV BL,10
        SUB BL,CL
        SUB BL,CL
        MOV SI,BX
        POP BX
LP2:    MOV AX,[SI]
        ADD SI,2  
        CMP SI,10                ;防止AX和没有存数据的内存比较：AX已经是最大的了，不用比了
        JNS NO_CMP
        CMP AX,[SI]
        JS NEXT                  ;直接换下一个数字
        
        XCHG AX,[SI]             ;两个单元互换
        MOV [SI-2],AX
        
NEXT:   MOV AX,[SI]              ;SI装入下一个数字          
        LOOP LP2
        
        
        
NO_CMP: DEC DI                   ;外循环的CX代理DI减一
        MOV CX,DI                ;把保护了的外循环的CX复原
        LOOP LP3      
        
        MOV DL,0DH               ;回车换行
        MOV AH,02H
        INT 21H
        MOV DL,0AH
        MOV AH,02H
        INT 21H
        
        
        MOV DX,OFFSET SORTED_RESULT
        MOV AH,09H
        INT 21H
        
        MOV CX,INPUT_NUM
        MOV SI,0
LP0:    MOV AX,[SI] 
        CALL SHOW
        ADD SI,2
        LOOP LP0 
        
        MOV AH,4CH
        INT 21H
        
SHOW:   PROC  
        MOV BL,100
        DIV BL              ;除
        PUSH AX             ;AX保护余数和商
        MOV DL,AL           ;把商放到DL里
        ADD DL,30H          ;转化为ascii输出，输出十位数
        MOV AH,02H
        INT 21H
          
        POP AX
        MOV AL,AH
        MOV AH,0
        MOV BL,10
        DIV BL              ;除
        PUSH AX             ;AX保护余数和商
        MOV DL,AL           ;把商放到DL里
        ADD DL,30H          ;转化为ascii输出，输出十位数
        MOV AH,02H
        INT 21H  
        
        POP AX              ;将AX恢复过来，准备输出个位数
        MOV DL,AH           ;将余数放入DL，准备输出
        ADD DL,30H          ;输出个位
        MOV AH,02H
        INT 21H 
        
        MOV DL,20H
        MOV AH,02H
        INT 21H
      
        
        RET
ENDP  

CODE    ENDS 
        END START
