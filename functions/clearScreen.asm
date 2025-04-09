; Requires VIDEO_MEM_ADDR and ah (color attribute) to be defined
clear_screen:
	pusha
	mov edx, VIDEO_MEM_ADDR
	mov [video_offset], edx
	mov ecx, 2000
	; 80x25 res = 2000 iterations
clear_screen_loop:
	mov al, ' '
	; mov ah, color_attribute
	mov [edx], ax
	add ebx, 1
	add edx, 2
	loop clear_screen_loop
	popa
	ret
