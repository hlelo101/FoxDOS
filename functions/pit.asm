pit_isr:
	cli
	pusha
	mov al, [dec_counter]
	cmp al, 1
	jne pit_isr_done
	
	mov eax, [pit_counter]
	dec eax
	mov [pit_counter], eax
	cmp eax, 0
	jnle pit_isr_done
	mov byte [dec_counter], 0
pit_isr_done:
	mov al, 0x20
	out 0x20, al
	popa
	sti
	iret

; eax: Sleep for
sleep:
	pusha
	mov [pit_counter], eax
	mov byte [dec_counter], 1
sleep_loop:
	mov al, [dec_counter]
	cmp al, 0
	jnle sleep_loop
sleep_done:
	mov byte [dec_counter], 0
	popa
	ret

; I/O port     Usage
; 0x40         Channel 0 data port (read/write)
; 0x41         Channel 1 data port (read/write)
; 0x42         Channel 2 data port (read/write)
; 0x43         Mode/Command register (write only, a read is ignored)
init_pit:
	cli
	; Set PIT control word to select channel 0 (base frequency)
	mov al, 0x36      ; Control word for 16-bit mode, channel 0, binary counting
	out 0x43, al      ; Write control word to PIT control register

	; Set PIT divisor for 1ms interrupt (1000 Hz)
	mov ax, 11932      ; 11932 = 0x2E8C, divisor for 1ms (PIT frequency is 1.193182 MHz)
	out 0x40, al      ; Send low byte of divisor to channel 0 data register
	mov al, ah         ; Get high byte of divisor
	out 0x40, al      ; Send high byte of divisor to channel 0 data register

	sti
	ret

pit_int_msg db '[PIT]: Decrementing', 10, 0
sleep_not_done_msg db '.', 0
pit_counter db 0
dec_counter db 0 ; 1: yes, 0: no
