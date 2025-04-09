[org 0x3000]
[bits 32]
cmp dl, 1
jne skip_welcome_msg

mov al, 0x12
call change_color_attribute
mov ebx, welcome_msg
call print_string
xor dl, dl
skip_welcome_msg:

shell_loop: ; Main program loop
mov al, 0x6E
call change_color_attribute
mov ebx, inputmsg
call print_string
mov al, 0x53
call change_color_attribute
call get_input

; VER command
mov eax, ver_command
call cmpstr
xor eax, eax
cmp cl, 0
je ver_command_skip
mov al, 1
jmp start_app
ver_command_skip:
; CLS command
mov eax, cls_command
call cmpstr
xor eax, eax
cmp cl, 0
je cls_command_skip
call clear_screen
cls_command_skip:

; Try to run the program
mov edx, ebx
call str_to_int
call start_app

mov ebx, linebreak
call print_string
jmp shell_loop
welcome_msg db "Welcome to the FoxDOS shell", 10, 0
inputmsg db "FD> ", 0
linebreak db 10, 0
; Commands
ver_command db "VER", 0
cls_command db "CLS", 0

%include "lib/foxlib.asm"
%include "lib/foxutils.asm"
