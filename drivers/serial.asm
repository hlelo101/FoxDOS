COM1_ADDRESS equ 0x3F8

init_serial:
	; COM1 port is 0x3F8
	pusha
	mov dx, COM1_ADDRESS+1
	mov al, 0x00
	out dx, al
	mov al, 0x80
	mov dx, COM1_ADDRESS+3
	out dx, al
	mov al, 0x03
	mov dx, COM1_ADDRESS
	out dx, al
	mov al, 0x00
	mov dx, COM1_ADDRESS+1
	out dx, al
	mov al, 0x03
	mov dx, COM1_ADDRESS+3
	out dx, al
	mov al, 0xC7
	mov dx, COM1_ADDRESS+2
	out dx, al
	mov al, 0x0B
	mov dx, COM1_ADDRESS+4
	out dx, al
	mov al, 0x1E
	out dx, al
	; Test
	mov al, 0xAE
	out dx, al
	in al, dx
	cmp al, 0xAE
	je serial_done
	jmp serial_err
serial_err:
	mov ebx, serial_err_msg
	mov ah, 0x4F
	call print_string_pm
	jmp serial_return
serial_done:
	mov al, 0x0F
	out dx, al
serial_return:
	popa
	ret

serial_err_msg db 'Serial test failed.', 0
