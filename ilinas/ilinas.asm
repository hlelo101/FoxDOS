[org 0x1000]
[bits 32]

VIDEO_MEM_ADDR equ 0xB8000
DEFAULT_COLOR_ATTRIBUTE equ 0x14

; Welcome :3
mov ebx, fox_dos_ascii_art
mov ah, DEFAULT_COLOR_ATTRIBUTE
call clear_screen
mov ah, 0x21
call print_string_pm

; Initialize
mov bx, 0
mov ax, 0
call set_cursor_coordinates
call init_idt
call init_pit
call init_ide

; https://www.reddit.com/r/osdev/comments/70fcig/blinking_text/
mov dx, 0x03DA
in al, dx
mov dx, 0x03C0
mov al, 0x30
out dx, al
inc dx
in al, dx
and al, 0xF7
dec dx
out dx, al

mov ah, 0x2F
mov ebx, init_done_msg
call print_string_pm

mov al, 0
mov dl, 1 ; Print the welcome message
int 0x42
jmp $

; AL: App index
start_app_isr:
	cli
	pusha
	call get_app
	cmp bx, 0
	je start_app_isr_not_found
	mov dx, bx
read_loop:
	mov ecx, 0x3000
	mov ebx, eax
	call ide_read
	
	dec dx
	add ecx, 512
	cmp dx, 0
	jnle read_loop
	popa
	mov word [esp], 0x3000
	sti
	iret
start_app_isr_not_found:
	popa
	sti
	iret

init_done_msg db 'Successfully initialized.', 10, 0
fox_dos_ascii_art db 'FFFF         DDD   OOO   SSS  ', 10, 'F            D  D O   O S     ', 10, 'FFF  ooo x x D  D O   O  SSS  ', 10, 'F    o o  x  D  D O   O     S ', 10, 'F    ooo x x DDD   OOO  SSSS  ', 10, 'Welcome to FoxDOS!', 10, 0

%include "functions/print32.asm"
%include "apps/appdirparser.asm"
%include "functions/idt.asm"
%include "drivers/serial.asm"
%include "drivers/keyboard.asm"
%include "functions/pit.asm"
%include "drivers/ata.asm"
