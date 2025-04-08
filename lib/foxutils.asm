; ## Options ##
; EAX: Address of string 1
; EBX: Address of string 2
; ## Returns ##
; In CL: 1 = true; 0 = false
cmpstr:
	pusha
cmpstr_loop:
	mov cl, [ebx]
	mov ch, [eax]
	
	cmp cl, ch
	jne cmpstr_false
	cmp cl, 0 ; End of the string
	je cmpstr_true
	inc ebx
	inc eax
	jmp cmpstr_loop

	; True
cmpstr_true:
	popa
	mov cl, 1
	ret
	; False
cmpstr_false:
	popa
	xor cl, cl
	ret

; ### Options ###
; EDX: Address of the string
; ## Returns ##
; EAX: Integer
str_to_int:
	push ecx
	xor eax, eax
str_to_int_loop:
	movzx ecx, byte [edx]
	inc edx
	cmp ecx, 0
	je str_to_int_done
	sub ecx, '0'
	imul eax, 10
	add eax, ecx
	jmp str_to_int_loop
str_to_int_done:
	pop ecx
	ret
