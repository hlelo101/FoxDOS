prog_loop:

mov bl, 0x48
call check_key
cmp al, 0
je key_up_skip
mov eax, [cursor_loc_offset]
sub eax, 20
mov [cursor_loc_offset], eax
call draw_mem_map
key_up_wait:
mov bl, 0x48
call check_key
cmp al, 1
je key_up_wait
key_up_skip:

mov bl, 0x50
call check_key
cmp al, 0
je key_down_skip
mov eax, [cursor_loc_offset]
add eax, 20
mov [cursor_loc_offset], eax
call draw_mem_map
key_down_wait:
mov bl, 0x50
call check_key
cmp al, 1
je key_down_wait
key_down_skip:

mov bl, 0x4B
call check_key
cmp al, 0
je key_left_skip
mov eax, [cursor_loc_offset]
dec eax
mov [cursor_loc_offset], eax
call draw_mem_map
key_left_wait:
mov bl, 0x4B
call check_key
cmp al, 1
je key_left_wait
key_left_skip:

mov bl, 0x4D
call check_key
cmp al, 0
je key_right_skip
mov eax, [cursor_loc_offset]
inc eax
mov [cursor_loc_offset], eax
call draw_mem_map
key_right_wait:
mov bl, 0x4D
call check_key
cmp al, 1
je key_right_wait
key_right_skip:

mov bl, 18
call check_key
cmp al, 0
je key_e_skip
key_e_wait:
mov bl, 18
call check_key
cmp al, 1
je key_e_wait
call edit_mem
key_e_skip:

mov bl, 36
call check_key
cmp al, 0
je key_j_skip
key_j_wait:
mov bl, 36
call check_key
cmp al, 1
je key_j_wait
call jump_mem
key_j_skip:

cmp dword [cursor_loc_offset], 459
jg ajust_down
cmp dword [cursor_loc_offset], 0
jl ajust_up

jmp prog_loop

ajust_down:
	mov ebx, [cursor_loc_offset]
	sub ebx, 460
	mov [cursor_loc_offset], ebx
	jmp ajust_done
ajust_up:
	mov ebx, [cursor_loc_offset]
	add ebx, 460
	mov [cursor_loc_offset], ebx
ajust_done:
	call draw_mem_map
	jmp prog_loop
