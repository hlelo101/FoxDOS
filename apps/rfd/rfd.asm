[org 0x3000]
[bits 32]

mov ebx, load_to_msg
call print_string
call get_input
mov edx, ebx
call str_to_int
mov ecx, eax

mov ebx, load_from_msg
call print_string
call get_input
mov edx, ebx
call str_to_int
mov ebx, eax

call read_disk

mov ebx, loaded_msg
call print_string

call exit

load_to_msg db "Load to (enter an address): ", 0
load_from_msg db 10, "Load from (sectors): ", 0
loaded_msg db 10, "Loaded!", 10, 0
%include "lib/foxlib.asm"
%include "lib/foxutils.asm"
