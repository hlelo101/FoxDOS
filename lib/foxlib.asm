; String address in EBX
print_string:
	pusha
print_string_loop:
	mov al, [ebx]
	mov ah, 0 ; Mode
	int 0x40
	inc ebx
	cmp byte [ebx], 0
	jne print_string_loop
	
	popa
	ret

; Returns address in EBX
get_input:
	int 0x41
	ret

; New attribute in AL
change_color_attribute:
	pusha
	mov ah, 1
	int 0x40
	popa
	ret

; App index in AL
start_app:
	int 0x42

	; If we're here, it means that
	; something went wrong, exit
	jmp exit

exit:
	mov al, 0
	int 0x42

	jmp $

clear_screen:
	pusha
	mov ah, 2
	int 0x40
	popa
	ret

; BL = Key scancode
check_key:
	mov ah, 2
	int 0x41
	ret

; CX: Cursor Y
; BX: Cursor X
change_cursor_loc:
	mov ah, 3
	int 0x40 
	ret
