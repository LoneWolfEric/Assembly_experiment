DATA    SEGMENT  
        NUM1 DW 300,250,280,240,260
        ;RESULT DW 0,0,0,0,0
        ;COUNTER DB 0
        INPUT_NUM DW 5     ;����ڼ�����
        DIGIT DW 0         ;���뼸λ�����ݴ棩
        WEIGHT DB 0        ;Ȩ��
        TEMP_SUM DW 0      ;��ʱ��
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
        MOV SI,0
          
        
        
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
        CMP AL,0DH
        JZ IN_DONE
        SUB AL,30H
        PUSH AX       
        LOOP IN_LP

IN_DONE:MOV DIGIT,CX
        MOV CX,3
        SUB CX,DIGIT
        ADD WEIGHT,1
        
CAL_LP: POP AX
        MUL WEIGHT           ;����Ȩ��
        ADD TEMP_SUM,AX      ;���뵽��ʱ������
        MOV AL,WEIGHT
        MUL BL
        MOV WEIGHT,AL        ;�����µ�Ȩ��
        LOOP CAL_LP       
        ;MOV AH,01
        ;INT 21H  
        ;SUB AL,30H          ;���������
        ;ADD DL,AL           ;�ӵ�DL��
        ;LOOP LP1 
        PUSH AX
        
        MOV AX,TEMP_SUM
        MOV [SI],AX
        ADD SI,2       
        
        SUB INPUT_NUM,1
        JNZ NNM_LP
        

        
        MOV CX,5
LP1:    MOV AX,[SI] 
        CALL SHOW
          
        ;MOV DL,20H           ;����������DL��׼�����
        ;MOV AH,02H
        ;INT 21H
        
        ADD SI,2
        LOOP LP1                 
                                 ;��ʾ�������
        MOV CX,5
        MOV DI,CX                ;��ѭ����CX��DI����������CX�Ĺ���
LP3:    MOV CX,5
        PUSH BX
        MOV BL,10
        SUB BL,CL
        SUB BL,CL
        MOV SI,BX
        POP BX
LP2:    MOV AX,[SI]
        ADD SI,2  
        CMP SI,10                ;��ֹAX��û�д����ݵ��ڴ�Ƚϣ�AX�Ѿ��������ˣ����ñ���
        JNS NO_CMP
        CMP AX,[SI]
        JS NEXT                  ;ֱ�ӻ���һ������
        
        XCHG AX,[SI]             ;������Ԫ����
        MOV [SI-2],AX
        
NEXT:   MOV AX,[SI]              ;SIװ����һ������          
        LOOP LP2
        
        
        
NO_CMP: DEC DI                   ;��ѭ����CX����DI��һ
        MOV CX,DI                ;�ѱ����˵���ѭ����CX��ԭ
        LOOP LP3      
        
        MOV DL,0DH               ;�س�����
        MOV AH,02H
        INT 21H
        MOV DL,0AH
        MOV AH,02H
        INT 21H
        
        
        MOV SI,0
        MOV CX,5
LP0:    MOV AX,[SI] 
        CALL SHOW
        ADD SI,2
        LOOP LP0 
        
        MOV AH,4CH
        INT 21H
        
SHOW:   PROC  
        MOV BL,100
        DIV BL              ;��
        PUSH AX             ;AX������������
        MOV DL,AL           ;���̷ŵ�DL��
        ADD DL,30H          ;ת��Ϊascii��������ʮλ��
        MOV AH,02H
        INT 21H
          
        POP AX
        MOV AL,AH
        MOV AH,0
        MOV BL,10
        DIV BL              ;��
        PUSH AX             ;AX������������
        MOV DL,AL           ;���̷ŵ�DL��
        ADD DL,30H          ;ת��Ϊascii��������ʮλ��
        MOV AH,02H
        INT 21H  
        
        POP AX              ;��AX�ָ�������׼�������λ��
        MOV DL,AH           ;����������DL��׼�����
        ADD DL,30H          ;�����λ
        MOV AH,02H
        INT 21H 
      
        
        RET
ENDP  

CODE    ENDS 
        END START
