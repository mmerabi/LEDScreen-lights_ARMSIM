;Michael Merabi CS122
;Project #3

.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01
.equ SEG_P,0x10
.text

start:

	mov r3, #1000		; start with 1000
	mov r4, #0		;last number pushed is stored in r4
	mov r5, #0		; lit LED stored in r5

	mov r0, #0		;display 1000 on LCD	
	mov r1, #0
	mov r2, r3		
	swi 0x205		;Set the Display

;Start Loop

Loop:
	mov r1, #0
	swi 0x203		;read num pad key pressed
	cmp r0, #1
	bne K1
	mov r0, #0
	bl Display8Segment
	mov r4, #0
	b BtnCmp        ; Jump to button compare
K1:
	cmp r0, #2
	bne K2
	mov r0, #1
	bl Display8Segment
	mov r4, #1
	b BtnCmp
K2:
	cmp r0, #4
	bne K3
	mov r0, #2
	bl Display8Segment
	mov r4, #2
	b BtnCmp
K3:
	cmp r0, #8
	bne K4
	mov r0, #3
	bl Display8Segment
	mov r4, #3
	b BtnCmp
K4:
	cmp r0, #16
	bne K5
	mov r0, #4
	bl Display8Segment
	mov r4, #4
	b BtnCmp
K5:
	cmp r0, #32
	bne K6
	mov r0, #5
	bl Display8Segment
	mov r4, #5
	b BtnCmp
K6:
	cmp r0, #64
	bne K7
	mov r0, #6
	bl Display8Segment
	mov r4, #6
	b BtnCmp
K7:
	cmp r0, #128
	bne K8
	mov r0, #7
	bl Display8Segment
	mov r4, #7
	b BtnCmp
K8:
	cmp r0, #256
	bne K9
	mov r0, #8
	bl Display8Segment
	mov r4, #8
	b BtnCmp
K9:
	cmp r0, #512
	bne K10
	mov r0, #9
	bl Display8Segment
	mov r4, #9
	b BtnCmp
K10:
	cmp r0, #1024
	bne K11
	mov r0, #10
	bl Display8Segment
	mov r4, #10
	b BtnCmp
K11:
	cmp r0, #2048
	bne K12
	mov r0, #11
	bl Display8Segment
	mov r4, #11
	b BtnCmp
K12:
	cmp r0, #4096
	bne K13
	mov r0, #12
	bl Display8Segment
	mov r4, #12
	b BtnCmp
K13:
	cmp r0, #8192
	bne K14
	mov r0, #13
	bl DisplaySegment
	mov r4, #13
	b BtnCmp
K14:
	cmp r0, #16384
	bne K15
	mov r0, #14
	bl DisplaySegment
	mov r4, #14
	b BtnCmp
K15:
	cmp r0, #32768
	bne BtnCmp
	mov r0, #15
	bl DisplaySegment
	mov r4, #15
	b BtnCmp

BtnCmp:
	swi 0x202		;which button is pressed?
	cmp r0, #1		;compare
	bne LeftButton
	swi 0x201		;light up LED
	mov r5, #1
	b Next2

LeftButton:
	cmp r0, #2		;left button
	bne Next2
	swi 0x201		;light up the left LED
	mov r5, #2

Next2:
	cmp r5, #1		;right LED lit
	bne LeftLED
	add r3, r3, r4	
	b UpdateLCD

LeftLED:
	cmp r5, #2		;left LED lit
	bne UpdateLCD
	sub r3, r3, r4		;subtract r4 from r3 and put result back in r3

UpdateLCD:
	mov r0, #0		;clear line 0 of LCD
	swi 0x208 
	
	mov r0, #0		;display updated value on LCD
	mov r1, #0
	mov r2, r3		
	swi 0x205
	
	b Loop          ; start from top
	swi 0x11		;exit 


DisplaySegment:
	stmfd sp!,{r0-r2,lr}
	ldr r2,=Digits
	ldr r0,[r2,r0,lsl#2]
	tst r1,#0x01 		
	orrne r0,r0,#SEG_P 	
	swi 0x200
	ldmfd sp!,{r0-r2,pc}
.data

Digits:

.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G 	;0
.word SEG_B|SEG_C 				;1
.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D 		;2
.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D 		;3
.word SEG_G|SEG_F|SEG_B|SEG_C 			;4
.word SEG_A|SEG_G|SEG_F
.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C 	;6
.word SEG_A|SEG_B|SEG_C 			;7
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G ;8
.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C 		;9
.word SEG_A|SEG_B|SEG_C|SEG_E|SEG_F|SEG_G 	;letter A
.word SEG_C|SEG_D|SEG_E|SEG_F|SEG_G	 	;letter b
.word SEG_A|SEG_D|SEG_E|SEG_G 			;letter C
.word SEG_B|SEG_C|SEG_D|SEG_E|SEG_F	 	;letter d
.word SEG_A|SEG_D|SEG_E|SEG_F|SEG_G 		;letter E
.word SEG_A|SEG_E|SEG_F|SEG_G		 	;letter F
.word 0 ;Blank display