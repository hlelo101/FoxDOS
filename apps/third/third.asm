[org 0x3000]	; All FoxDOS apps get loaded at 0x3000
[bits 32]		; FoxDOS is a 32-bit system

mov al, 0x15				; Purple on blue
call change_color_attribute	; These functions are part of the foxlib
mov ebx, msg				; Print the message
call print_string
jmp exit					; Properly exit

msg db "This is the 3rd app!", 10, 0

%include "lib/foxlib.asm"
