	ORG 0
MAIN:
	; P1 for keyboard

	
	jmp LOOP
	
Delay:
	push 4
	
	mov r4, #250
	djnz r4, $
	
	pop 4
	ret
	
	end
