	ORG 0
	mov DPTR, #SEG_TABLE
MAIN:
	; P1 for keyboard X3 X2 X1 X0 Y3 Y2 Y1 Y0
	; P2 for 7Seg Selector
	; P3 for 7Seg Content
	mov P1, #0EFh
	mov A, P1
	anl A, #0Fh ; A is the value
	
	; Show left digit
	ll A
	mov r1, A
	mov A, @DPTR + A
	mov P3, A
	setb P2.1
	clr P2.0
	call Delay
	
	; Show right digit
	mov A, r1
	inc A
	mov A, @DPTR + A
	mov P3, A
	setb P2.0
	clr P2.1
	call Delay
	
	jmp MAIN
	
Delay:
	push 4
	
	mov r4, #250
	djnz r4, $
	
	pop 4
	ret

SEG_TABLE:
	db 0
	db 0 ;
	db 0
	db 1 ;
	db 0
	db 2 ;
	db 0
	db 3 ;
	db 0
	db 4 ;
	db 0
	db 5 ;
	db 0
	db 6 ;
	db 0 
	db 7 ;
	db 0
	db 8 ;
	db 0
	db 9 ;
	db 1
	db 0 ;
	db 1
	db 1 ;
	db 1
	db 2 ;
	db 1
	db 3 ;
	db 1
	db 4 ;
	db 1
	db 5 ;
	
	end
