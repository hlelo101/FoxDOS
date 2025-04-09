error_handler_isr:
	mov edx, [esp]
	cmp edx, 0x3000
	jge error_handler_app_err
	mov ebx, error_msg
	mov ah, 0x4F
	call clear_screen
	call print_string_pm
	jmp $
error_handler_app_err:
	; Pop the things the CPU pushed
	add esp, 12
	mov ebx, app_error_msg
	mov ah, 0x4F
	call print_string_pm
	mov al, 0
	int 0x42

error_msg db "An fatal exception occured", 10, "System stopped", 0
app_error_msg db 10, "The application commited a fault and has been terminated.", 10, "You will now be redirected to the shell.", 10, 0
