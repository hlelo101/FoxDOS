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

; ### Options ###
; AX: Integer
; EBX: Pointer to the buffer where the string will be stored
hex_to_char_table:
    db "0123456789ABCDEF", 0
hex_to_char:
	pusha
	movzx ecx, al
	shr cl, 4
	mov dl, [hex_to_char_table + ecx]
	mov [ebx], dl
	movzx ecx, al
	and cl, 0Fh
	mov dl, [hex_to_char_table + ecx]
	mov [ebx+1], dl
	mov byte [ebx+2], 0
	popa
	ret

; EAX = number to convert
; EBX = pointer to output buffer
int_to_string:
    push ecx
    push edx
    push esi
    xor ecx, ecx
    mov esi, ebx
int_to_string_loop:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    push edx
    inc ecx
    test eax, eax
    jnz int_to_string_loop
int_to_string_write:
    pop edx
    mov [esi], dl
    inc esi
    loop int_to_string_write

    mov byte [esi], 0

    pop esi
    pop edx
    pop ecx
    ret
