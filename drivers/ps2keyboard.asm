init_ps2_keyboard:
	in al, 0x60
	mov al, 0xFF
	out 0x60, al
ps2_keyboard_wait_selftest:
	in al, 0x60
	; in al, 0x64
	test al, 1
	jz ps2_keyboard_wait_selftest
	call print_string_pm
	ret

ps2_keyboard_isr:
	cli
	pusha
	xor eax, eax ; ?
    in al, 0x60
    call new_key
    
	mov al, 0x20
	out 0x20, al
	cmp dl, 1
	je ps2_keyboard_isr_start_shell
	popa
	sti
	iret
ps2_keyboard_isr_start_shell:
	popa
	mov word [esp], new_key_start_shell
	sti
	iret
