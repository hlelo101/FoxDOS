[org 0x3000]
[bits 32]

reset_ui:
mov al, 0x07
call change_color_attribute
call clear_screen

mov al, 0x1F
call change_color_attribute
mov ebx, menu_top
call print_string

mov al, 0x07
call change_color_attribute
mov ebx, options
call print_string
call get_input

mov al, [ebx]
cmp al, 'A'
je div_by_zero
cmp al, 'B'
je kernel_crash
cmp al, 'C'
je invalid_opcode
cmp al, 'D'
je exit_prog

jmp reset_ui

exit_prog:
mov ebx, lb
call print_string
jmp exit

invalid_opcode:
db 0x23

kernel_crash:
int 0x25

div_by_zero:
mov eax, 0
mov ebx, 0
div ebx

%include "lib/foxlib.asm"
menu_top db "                                     ERR APP                                    ", 10, 10, 0
options:
	db "A. Division by 0", 10, "B. Crash from the kernel (int 0x25)", 10, "C. Invalid opcode", 10, "D. Exit"
	times 18 db 10
	db '> ', 0
lb db 10, 0
