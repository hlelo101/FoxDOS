[org 0x3000]
[bits 32]

mov al, 0x05
call change_color_attribute
mov ebx, enter_num
call print_string
call get_input
mov edx, ebx
call str_to_int
mov [int_inst + 1], al

; YEH SELF-MODIFYING CODE >:3333
int_inst:
	db 0xCD
	db 0x00

mov ebx, newline
call print_string
call exit

enter_num db "Enter the interrupt number", 10, "int ", 0
newline db 10, 0

%include "lib/foxlib.asm"
%include "lib/foxutils.asm"
