%include "functions/clearScreen.asm"

; Character in AL, color attribute in AH
print_single_char_pm: ; PRINT SINGLE CHAR START
	pusha
	xor bx, bx
	mov edx, [video_offset]

	cmp al, 10
	je print_single_char_pm_newline
	cmp al, 8
	je print_single_char_pm_backspace
	jmp special_chars_skip

	; Backspace
print_single_char_pm_backspace:
	sub edx, 2
	mov al, ' '
	mov bx, 1 ; Do not increment edx
	jmp special_chars_skip
	; Newline
print_single_char_pm_newline:
	push eax
	push ecx
	sub edx, VIDEO_MEM_ADDR
	mov eax, edx
	mov ecx, 160
	xor edx, edx
	div ecx
	inc eax
	mul ecx
	add eax, VIDEO_MEM_ADDR
	mov edx, eax
	pop eax
	pop ecx
	jmp print_single_char_skip_add

special_chars_skip:
	mov [edx], al
	mov [edx + 1], ah

	cmp bx, 1
	je print_single_char_skip_add
	add edx, 2
	
print_single_char_skip_add:
	cmp edx, 0xB8FA0
	jnge print_single_char_pm_skip_scroll
	call scroll_screen_pm
	mov edx, 0xB8F00
print_single_char_pm_skip_scroll:
	mov [video_offset], edx
	sub edx, VIDEO_MEM_ADDR
	shr edx, 1
	mov ebx, edx
	call set_cursor_offset
	popa
	ret ; PRINT SINGLE CHAR END

scroll_screen_pm:
	pusha
	mov ebx, 0xB8000
scroll_screen_pm_loop:
	mov ecx, [ebx]
	mov [ebx - 160], ecx
	inc ebx
	cmp ebx, 0xB8FA0
	jnge scroll_screen_pm_loop

; Clear the last line
	mov ebx, 0xB8F00
	mov ah, DEFAULT_COLOR_ATTRIBUTE
scroll_screen_pm_clear_last_line:
	mov byte [ebx], ' '
	mov [ebx + 1], ah ; That's where the color attribute should be
	add ebx, 2
	cmp ebx, 0xB8FA0
	jnge scroll_screen_pm_clear_last_line
	popa
	ret

; String address in ebx
print_string_pm:
	pusha
print_string_pm_loop:
	mov al, [ebx]
	call print_single_char_pm
	inc ebx
	cmp byte [ebx], 0
	jne print_string_pm_loop

	popa
	ret

update_cursor_pos:
	pusha
	mov ebx, [video_offset]
	sub ebx, VIDEO_MEM_ADDR
	shr ebx, 1
	call set_cursor_offset
	popa
	ret
	
; bx = x, ax = y
set_cursor_coordinates:
	mov dl, 80
	mul dl
	add bx, ax
; bx = cursor offset
set_cursor_offset:
	mov dx, 0x3D4
	mov al, 0x0F
	out dx, al
	inc dl
	mov al, bl
	out dx, al
	dec dl
	mov al, 0x0E
	out dx, al
	inc dl
	mov al, bh
	out dx, al
	ret

; Character in al, mode in ah
; (0 = Print, 1 = Change color attribute, 2 = Clear screen)
print_char_isr:
	pusha
	cmp ah, 0
	je print_char_isr_print
	cmp ah, 1
	je print_char_isr_change_ca
print_char_isr_clear_scr:
	call clear_screen
print_char_isr_change_ca:
	mov [current_color_attribute], al
	jmp print_char_isr_done
print_char_isr_print:
	mov ah, [current_color_attribute]
	call print_single_char_pm
print_char_isr_done:
	popa
	iret

video_offset dd VIDEO_MEM_ADDR
empty db 0
current_color_attribute db 0x07
