ORG  0000H 
MAIN:   
   RS  EQU P1.0
   RW  EQU P1.1
   ENBL  EQU P1.2
   MOV SP,#70H 
   MOV PSW,#00H 
   MOV R0,#50H		
   MOV R6,#3
   CLR P1.6
   CLR P1.7
   
LCD_IN:  
   MOV  A, #38H   ;init. LCD 2 lines, 5x7 matrix 
   ACALL COMNWRT   ;call command subroutine 
   ACALL  DELAY   ;give LCD some time 
   MOV   A, #0FH   ;dispplay on, cursor on 
   ACALL COMNWRT   ;call command subroutine 
   ACALL  DELAY   ;give LCD some time 
   MOV  A, #01    ;clear LCD 
   ACALL COMNWRT   ;call command subroutine 
   ACALL  DELAY   ;give LCD some time 
   MOV  A, #06H   ;shift cursor right 
   ACALL COMNWRT   ;call command subroutine 
   ACALL  DELAY   ;give LCD some time 
   MOV  A, #80H   ;cursor at line 1 postion 4 
   ACALL COMNWRT   ;call command subroutine 
   ACALL  DELAY   ;give LCD some time 	
   MOV DPTR, #MSG1
LOADING:
   CLR A   
   MOVC A, @A+DPTR
   JZ K0
   ACALL DATAWRT
   ACALL DELAY
   INC DPTR
   SJMP LOADING
;--------------------KEYPAD PORTION-----------------------
K0: 
   SETB P2.0
   SETB P2.1
   SETB P2.2
   SETB P2.3  
K1:   
   CLR P2.4
   CLR P2.5
   CLR P2.6
   CLR P2.7
   MOV  A, P2    ;read all columns.ensure all keys open 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE  A, #00001111B,K1  ;check till all keys released  
K2:  
   ACALL  DELAY   ;call 20ms delay 
   MOV  A, P2    ;see if any key is pressed 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE   A, #00001111B, OVER ;key pressed, await closure 
   SJMP  K2    ;check is key pressed 
OVER:  
   ACALL  DELAY   ;wait 20ms debounce time 
   MOV  A, P2    ;check key closure 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE  A, #00001111B, OVER1 ;key pressed, find row 
   SJMP  K2    ;if none, keep polling 
OVER1:  
   CLR P2.4
   SETB P2.5
   SETB P2.6
   SETB P2.7
   MOV  A, P2    ;read all columns 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE  A, #00001111B, ROW_0 ;key row 0, find the column 
   SETB P2.4
   CLR P2.5
   SETB P2.6
   SETB P2.7
   MOV  A, P2    ;reall all columns 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE  A, #00001111B, ROW_1 ;key row 1, find the column 
   SETB P2.4
   SETB P2.5
   CLR P2.6
   SETB P2.7   
   MOV  A, P2    ;read all columns 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE  A, #00001111B, ROW_2 ;key row 2, find column 
   SETB P2.4
   SETB P2.5
   SETB P2.6
   CLR P2.7
   MOV  A, P2    ;read all columns 
   ANL  A, #00001111B  ;mask unused bits 
   CJNE  A, #00001111B, ROW_3 ;key row 3, find column 
   LJMP  K2     ;if none, false input, repeat 
ROW_0:  
   MOV  DPTR,  #KCODE0  ;set DPTR=start of row 0 
   SJMP  FIND    ;find column.key belongs to 
ROW_1:   
   MOV  DPTR, #KCODE1  ;set DPTR=start of row 1 
   SJMP  FIND    ;find column.key belongs to 
ROW_2:  
   MOV  DPTR, #KCODE2  ;set DPTR=start of row 2 
   SJMP  FIND    ;find column.key belongs to 
ROW_3:  
   MOV  DPTR, #KCODE3  ;set DPTR=start of row 3 
FIND:  
   RRC  A    ;see if any CY bit is low 
   JNC  MATCH   ;if zero, get the ASCII code 
   INC  DPTR    ;point to the next column address 
   SJMP  FIND    ;keep searching 
MATCH: 
   CLR  A    ;set A=0 (match found) 
   MOVC  A, @A+DPTR  ;get ASCII code from table
   
   CJNE A, #'=', MATCH1
   LJMP NEXT
MATCH1:      
   ACALL DATAWRT   ;call display subroutine 
   ACALL  DELAY   ;give LCD some time
   MOV @R0, A
   INC R0
   DEC R6
   MOV A, R6
   CJNE A, #0,J1
   SJMP NEXTT
J1:
   LJMP K0
NEXTT:
   MOV A, #0C0H
   ACALL COMNWRT
   ACALL DELAY
   MOV DPTR, #MSG2
J2:
   CLR A
   MOVC A, @A+DPTR
   JZ J1
   ACALL DATAWRT
   ACALL DELAY
   INC DPTR
   SJMP J2
      
     
NEXT:
   SETB P1.6
   CLR C
   MOV A, 50H 
   SUBB A, #30H
   MOV 50H, A
   CLR C
   MOV A, 51H 
   SUBB A, #30H
   MOV 51H, A
   CLR C
   MOV A, 52H 
   SUBB A, #30H
   MOV 52H, A

   MOV A, 50H
   CJNE A, #0,LOP1
   MOV 50H, A
   MOV A, 51H
   CJNE A, #6, LOP2
   MOV 51H, A
   SJMP LOP1
LOP2:
   JNC LOP1
   LJMP LOP3     
LOP1:
   MOV A, #01H
   ACALL COMNWRT
   ACALL DELAY
   MOV A, #080H
   ACALL COMNWRT
   ACALL DELAY
   MOV DPTR, #MSG4
J4:
   CLR A
   MOVC A, @A+DPTR
   JZ TIMEE
   ACALL DATAWRT
   ACALL DELAY
   INC DPTR
   SJMP J4

LOP3:
   MOV A, #01H
   ACALL COMNWRT
   ACALL DELAY
   MOV A, #080H
   ACALL COMNWRT
   ACALL DELAY
   MOV DPTR, #MSG3
J5:
   CLR A
   MOVC A, @A+DPTR
   JZ NEXT1
   ACALL DATAWRT
   ACALL DELAY
   INC DPTR
   SJMP J5

TIMEE:
   MOV R5, #20
   MOV 60H, #0  
NEXT1:
   MOV DPTR, #DRIVE_PATTERN
NEXT2:   
   MOV R6, #2
NEXT3:   
   MOV R4, #173  
TIMEEE:   
   MOV A, 50H 
   CLR P1.3
   MOVC A, @A+DPTR
   MOV P0, A
   LCALL DELAY1
   SETB P1.3
   MOV A, 51H
   CLR P1.4
   MOVC A, @A+DPTR
   MOV P0, A
   LCALL DELAY1
   SETB P1.4
   MOV A, 52H
   CLR P1.5
   MOVC A, @A+DPTR
   MOV P0, A
   LCALL DELAY1
   SETB P1.5
   MOV A, 50H
   CJNE A, #0, CHECK
   MOV A, 51H
   CJNE A, #0, CHECK
   MOV A, 52H
   CJNE A, #0, CHECK
   CLR P1.6
   SETB P1.7
   SJMP TIMEEE
CHECK:        
   DJNZ R4, TIMEEE  
   DJNZ R6, NEXT3
   
BACK:
   DEC R5
   MOV A, R5
   CJNE A, #0, BACK1
   MOV R5, #20
   LJMP PRINT
BACK1:   
   MOV A, 52H
   CJNE A, #0,J6
   MOV 52H, #9
   MOV A, 51H
   CJNE A, #0, J7
   MOV 51H, #9
   MOV A, 50H
   CJNE A, #0, J8
   LJMP NEXT1
J6:
   DEC A
   MOV 52H, A
   LJMP NEXT1
J7:
   DEC A 
   MOV 51H, A
   LJMP NEXT1
J8:
   DEC A
   MOV 50H, A
   LJMP NEXT1
   
   
READY:  
   SETB  P3.7 
   CLR  RS 
   SETB  RW 
WAIT:  
   CLR  ENBL 
   LCALL DELAY 
   SETB  ENBL 
   JB  P3.7, WAIT 
   RET 



PRINT:
   MOV A, #01H
   ACALL COMNWRT
   ACALL DELAY
   MOV A, #80H
   ACALL COMNWRT
   ACALL DELAY
   MOV A, 60H
   INC A
   MOV 60H, A
   CJNE A, #1, SHOW1
   MOV DPTR, #MSG5
   SJMP MESSAGE_PRINT
SHOW1:
   CJNE A, #2, SHOW2
   MOV DPTR, #MSG6
   SJMP MESSAGE_PRINT
SHOW2:
   CJNE A, #3, SHOW3
   MOV DPTR, #MSG7
   SJMP MESSAGE_PRINT  
SHOW3:
   CJNE A, #4, SHOW4
   MOV DPTR, #MSG8  
   SJMP MESSAGE_PRINT
SHOW4:
   CJNE A, #5, SHOW5
   MOV DPTR, #MSG9  
   SJMP MESSAGE_PRINT 
SHOW5:
   CJNE A, #6, SHOW6
   MOV DPTR, #MSG10
   SJMP MESSAGE_PRINT
SHOW6:
   CJNE A, #7, SHOW7
   MOV DPTR, #MSG11
   SJMP MESSAGE_PRINT
SHOW7:
   CJNE A, #8, SHOW8
   MOV DPTR, #MSG12
   SJMP MESSAGE_PRINT
SHOW8:
   CJNE A, #9, SHOW9
   MOV DPTR, #MSG13
   SJMP MESSAGE_PRINT
SHOW9:
   CJNE A, #10, SHOW10
   MOV DPTR, #MSG14
   SJMP MESSAGE_PRINT
SHOW10:
   MOV DPTR, #MSG15
  
MESSAGE_PRINT:
   CLR A
   MOVC A, @A+DPTR
   JZ RISHAD
   ACALL DATAWRT
   ACALL DELAY
   INC DPTR
   SJMP MESSAGE_PRINT         
RISHAD:
   LJMP BACK1
   
   
COMNWRT: 
   LCALL READY   ;send command to LCD 
   MOV  P3, A    ;copy reg A to port 1 
   CLR  RS    ;RS=0 for command 
   CLR  RW    ;R/W=0 for write 
   SETB  ENBL    ;E-1 for high pulse  
   ACALL DELAY   ;give LCD some time 
   CLR  ENBL    ;E=0 for H-to-L pulse 
   RET 

 
DATAWRT: 
   LCALL READY   ;write data to LCD 
   MOV  P3, A    ;copy reg A to port1 
   SETB  RS    ;RS=1 for data 
   CLR  RW    ;R/W=0 for write 
   SETB  ENBL    ;E=1 for high pulse 
   ACALL DELAY   ;give LCD some time 
   CLR  ENBL    ;E=0 for H-to-L pulse 
   RET 
   
DELAY:  MOV  R3, #50   ;50 or higher for fast CPUs 
D5: MOV  R4, #255  ;R4=255 
D4: DJNZ  R4, D4 ;stay untill R4 becomes 0 
    DJNZ   R3,D5
    RET

DELAY1: MOV R3, #02H
D1:MOV R2, #0FAH
D2: DJNZ R2, D2
DJNZ R3, D1
RET  


ORG 800H
;ASCII LOOK-UP TABLE FOR EACH ROW  
KCODE0: DB '7','8','9','/'    ;ROW 0 
KCODE1: DB '4','5','6','*'    ;ROW 1 
KCODE2: DB '1','2','3','-'    ;ROW 2 
KCODE3: DB 'C','0','=','+'    ;ROW 3 

ORG 900H

DRIVE_PATTERN: DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH


MSG1: DB 'TIME:',0
MSG2: DB '', 0
MSG3: DB 'LESS THAN 60s', 0
MSG4: DB 'MORE THAN 60s', 0
MSG5: DB 'OVEN HEATING...', 0
MSG6: DB 'COOKING..', 0
MSG7: DB 'TEMP. STABLE', 0
MSG8: DB 'REMAINING...', 0
MSG9: DB 'DONT OPEN', 0
MSG10: DB 'SAFETY FIRST', 0
MSG11: DB 'GETTING READY', 0
MSG12: DB 'CHECKING TEMP.', 0
MSG13: DB 'STEAM UP', 0
MSG14: DB 'NEAR COMPLETION', 0
MSG15: DB 'READY TO SERVE', 0

END
