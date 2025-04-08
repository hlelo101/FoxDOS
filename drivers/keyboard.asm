%include "drivers/ps2keyboard.asm"

disable_kbd:
	mov al, 0x00
	mov [kbd_enabled], al
	ret

enable_kbd:
	mov al, 0x01
	mov [kbd_enabled], al
	ret

new_key:
	test al, 0x80
	jnz input_in_progress_done

    cmp byte [input_in_progress], 0
    je input_in_progress_done
    mov si, [input_buffer_index]
    cmp si, 0
    jl new_key_reset_index
    cmp si, 49
    jge new_user_key_clear

    mov al, [scancode_table_uppercase + eax]
    mov ah, [current_color_attribute]
    call print_single_char_pm
    cmp al, 10
    je new_user_key_clear
    cmp al, 8
    je new_user_key_backspace

    mov [input_buffer + si], al
    inc si

	mov [input_buffer_index], si
    jmp input_in_progress_done
new_key_reset_index:
	mov word [input_buffer_index], 0
	jmp input_in_progress_done
new_user_key_backspace:
	dec si
	mov [input_buffer_index], si
	jmp input_in_progress_done	
new_user_key_clear:
    mov byte [input_in_progress], 0
input_in_progress_done:
	mov byte [input_buffer + si], 0
    ret

; Input ISR
input_isr:
    sti
    mov byte [input_in_progress], 1
input_loop:
    cmp byte [input_in_progress], 0
    jne input_loop

    mov word [input_buffer_index], 0
    mov ebx, input_buffer
    iret

kbd_enabled db 0x01	; 0x01: Enabled, 0x00: Disabled
scancode_table_uppercase db '²1234567890  ', 8, ' AZERTYUIOP  ', 10, ' QSDFGHJKLM    WXCVBN?./§         '
input_in_progress db 0 ; 0: No, 1: Yes
input_buffer times 50 db 0
input_buffer_index dw 0
