	ORG 0
	mov r4, #0
MAIN:
	; P1 for keyboard X3 X2 X1 X0 Y3 Y2 Y1 Y0
	; P2 for 7Seg Selector
	; P3 for 7Seg Content
	mov DPTR, #BTN_TABLE
	
	; r2 for scanning selector reg
	; r3 for clicked value
	; r4 for mode reg. 0: digit clicked; 1: equal clicked
	; r5 for saved value
	mov r2, #10h
LOOP:
	; Make Selector
	mov A, #0FFh
	xrl A, r2
	mov P1, A
	
	; Read Button &
	; Get the offset number of that row: 0, 1, 2, or 3
	mov A, P1
	anl A, #0Fh
	xrl A, #0Fh
	movc A, @A+DPTR
	cjne A, #100, BTN_CLICKED
	jmp NO_CLICK_BTN
	
BTN_CLICKED:
	; Compute the base number of this column: 4, 8, or 16
	mov r7, A
	mov A, r2
	rr A
	rr A
	rr A
	anl A, #11111100b
	add A, r7
	
	cjne A, #19, NOT_EQUAL
	; EQUAL is clicked
	
	; Prevent keeping enter this section
	cjne r4, #0, SCAN_FINISH
	mov r4, #1
	
	mov A, r3
	add A, r5
	mov r3, A
	jmp SCAN_FINISH
	
NOT_EQUAL:
	mov r4, #0
	cjne A, #11, NOT_ADD
	; ADD is clicked
	
	mov A, r3
	mov r5, A
	jmp SCAN_FINISH
	
NOT_ADD:
	cjne A, #10, NOT_CLEAR
	; CLEAR is clicked
	
	mov r3, #0
	mov r5, #0
	jmp SCAN_FINISH
	
NOT_CLEAR:
	; So it is a digit
	mov r3, A
	jmp SCAN_FINISH
	
NO_CLICK_BTN:
	mov A, r2
	rl A
	anl A, #0F0h
	mov r2, A
	jnz LOOP
	
SCAN_FINISH:
	; Show the clicked value
	mov A, r3
	call SHOW_DIGIT
	jmp MAIN
	
SHOW_DIGIT:
	; The value is in A
	mov B, #10
	div AB
	
	; Show left digit
	mov P3, A
	setb P2.1
	clr P2.0
	call Delay
	
	; Show right digit
	mov P3, B
	setb P2.0
	clr P2.1
	call Delay
	
	ret
	
Delay:
	push 4
	push 6
	
	mov r6, #100
D1:
	mov r4, #250
	djnz r4, $
	djnz r6, D1
	
	pop 6
	pop 4
	ret
	
BTN_TABLE:
	db 100
	db 0 ;
	db 1 ;
	db 0
	db 2 ;
	db 0
	db 0
	db 0
	db 3 ;
	
	end
