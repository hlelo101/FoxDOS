error_handler_isr:
	mov ebx, error_msg
	mov ah, 0x4F
	call clear_screen
	call print_string_pm
	jmp $

error_msg db 'An exception occured', 10, 'System stopped', 0
