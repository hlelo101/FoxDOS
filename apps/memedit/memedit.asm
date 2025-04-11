[org 0x3000]
[bits 32]

COLOR_ONE equ 0xC0
COLOR_TWO equ 0x0C

mov al, COLOR_ONE
call change_color_attribute
call clear_screen

mov al, COLOR_TWO
call change_color_attribute
mov ebx, topbar
call print_string
mov al, COLOR_ONE
call change_color_attribute

call draw_mem_map
call reset_bottom_bar

%include "apps/memedit/loop.asm"

reset_bottom_bar:
	mov cx, 24
	mov bx, 0
	call change_cursor_loc
	
	mov al, COLOR_TWO
	call change_color_attribute
	mov ebx, bottombar
	call print_string
	mov al, COLOR_ONE
	call change_color_attribute
	mov byte [0xB8F9E], ' ' ; heh
	mov byte [0xB8F9F], COLOR_TWO
	
	call draw_loc
	ret

draw_loc:
	pusha
	xor ecx, ecx
	mov cx, 24
	mov bx, 43
	call change_cursor_loc
	mov eax, [current_mem_addr]
	mov ebx, current_mem_addr_str
	call int_to_string
	mov al, COLOR_TWO
	call change_color_attribute
	mov ebx, current_mem_addr_str
	call print_string
	mov al, COLOR_ONE
	call change_color_attribute
	popa
	ret

draw_mem_map:
	pusha
	mov cx, 1
	mov bx, 0
	call change_cursor_loc
	
	mov edx, [current_mem_addr]
	xor ecx, ecx
draw_mem_map_loop:
	xor ebx, ebx
	; Get the memory
	mov ax, [edx]
	mov ebx, current_bit_str
	push edx
	call hex_to_char
	mov byte [current_bit_str + 2], " "
	mov byte [current_bit_str + 3], 0
	; Print it
	cmp ecx, [cursor_loc_offset]
	jne draw_mem_map_skip_ch
	mov al, COLOR_TWO
	call change_color_attribute
	mov ebx, current_bit_str_space
	call print_string
	mov al, COLOR_ONE
	call change_color_attribute
	jmp draw_mem_map_after_ch
draw_mem_map_skip_ch:
	mov ebx, current_bit_str_space
	call print_string
draw_mem_map_after_ch:
	pop edx

	; Iterate
	inc edx
	inc ecx

	cmp ecx, 460
	jl draw_mem_map_loop

	popa
	ret

edit_mem:
	pusha
	; Get input from the user
	mov cx, 24
	mov bx, 0
	call change_cursor_loc
	mov al, COLOR_TWO
	call change_color_attribute
	mov ebx, prompt_edit
	call print_string
	mov cx, 24
	mov bx, 6
	call change_cursor_loc
	call get_input

	; Change the address
	mov edx, ebx
	call str_to_int
	mov ebx, [current_mem_addr]
	add ebx, [cursor_loc_offset]
	mov [ebx], al

	mov al, COLOR_ONE
	call change_color_attribute
	popa
	call draw_mem_map
	call reset_bottom_bar
	ret

jump_mem:
	pusha
	; Get input from the user
	mov cx, 24
	mov bx, 0
	call change_cursor_loc
	mov al, COLOR_TWO
	call change_color_attribute
	mov ebx, prompt_jump
	call print_string
	mov cx, 24
	mov bx, 6
	call change_cursor_loc
	call get_input

	; Jump
	mov edx, ebx
	call str_to_int
	mov [current_mem_addr], eax

	mov al, COLOR_ONE
	call change_color_attribute
	popa
	call draw_mem_map
	call reset_bottom_bar
	ret

topbar db "memEdit (use CTRL+D to exit)"
       %rep 52
       db " "
       %endrep
       db 0

bottombar db "E = Edit | J = Jump to | Current position: "
          %rep 36
          db " "
          %endrep
          db 0

space db " ", 0
current_bit_str_space db " "
current_bit_str dd 0
prompt_edit db "EDIT>"
            times 50 db ' '
            db 0

prompt_jump db "JUMP>"
            times 50 db ' '
            db 0

current_mem_addr dd 0
current_mem_addr_str times 12 db 0
cursor_loc_offset dd 0


%include "lib/foxlib.asm"
%include "lib/foxutils.asm"
