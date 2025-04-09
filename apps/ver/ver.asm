[org 0x3000]
[bits 32]

mov al, 0xE2
call change_color_attribute
mov ebx, ver_output
call print_string

jmp exit

ver_output db "FoxDOS Version 0.1.3", 10, "FoxDOS Shell version 0.1.2", 10, 0

%include "lib/foxlib.asm"
