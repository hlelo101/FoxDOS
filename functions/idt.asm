%include "functions/err_handler.asm"

IDT equ 0x2200

idtr:
	dw 256*8 - 1
	dd IDT

irq7_isr:
	pusha
	mov al, 0x0B
	out 0x20, al
	in al, 0x20
	cmp al, 0x80
	jne irq7_isr_end

	mov al, 0x20
	out 0x20, al
irq7_isr_end:
	popa
	iret

; EAX = ISR address
; EBX = Index
set_entry:
	mov word [IDT + 8*ebx], ax
	mov word [IDT + 8*ebx + 32], dx
	ret

init_idt:
 	pusha
 	cli
 	; Fill in the IDT
 	xor edx, edx
 idt_fill_rep:
 	lea ebx, [edx + IDT]
 	
 	mov word [ebx], 0
 	mov word [ebx + 2], 0x08 ; Selector
 	mov byte [ebx + 4], 0
 	mov byte [ebx + 5], 0x8E ; Attribute + type
 	mov word [ebx + 6], 0

 	add edx, 8
 	cmp edx, 256*8
 	jl idt_fill_rep

	xor edx, edx
 err_handler_assign_loop:
 	lea eax, [error_handler_isr]
 	mov word [IDT + 8*edx], ax
	mov word [IDT + 8*edx + 32], dx
	inc edx
	cmp edx, 32
	jl err_handler_assign_loop
	
 	; IRQ0, PIT
 	lea eax, [pit_isr]
 	mov ebx, 0x20
 	call set_entry
 	; IRQ1, PS/2 keyboard
 	lea eax, [ps2_keyboard_isr]
 	mov ebx, 0x21
 	call set_entry
	; IRQ7
	lea eax, [irq7_isr]
	mov ebx, 0x27
	call set_entry
	; 0x40, Print char
	lea eax, [print_char_isr]
	mov ebx, 0x40
	call set_entry
	; 0x41, Get input
	lea eax, [input_isr]
	mov ebx, 0x41
	call set_entry
	; 0x42, Start app
	lea eax, [start_app_isr]
	mov ebx, 0x42
	call set_entry
	; 0x43, System disk
	lea eax, [disk_read_isr]
	mov ebx, 0x43
	call set_entry

	; Save the masks in AL & CL
	in al, 0x21
	mov [mask1], al
	in al, 0xA1
	mov [mask2], al
	; ICW1: Start initialization
	mov al, 0x11	; Start initialization in cascade mode
	out 0x20, al	; Master PIC command port
	out 0xA0, al	; Slave PIC command port
	; ICW2: Set offset (0x20 (32) and 0x28 (40))
	mov al, 0x20
	out 0x21, al
	mov al, 0x28 
	out 0xA1, al
	; ICW3: Slave/Master setup
	mov al, 4
	out 0x21, al
	mov al, 2
	out 0xA1, al
	; ICW4: Use 8086 mode
	mov al, 0x01
	out 0x21, al
	out 0xA1, al
	; Restore the masks
	mov al, mask1
	out 0x21, al
	mov al, mask2
	out 0xA1, al
	
 	; Unmask IRQ0, IRQ1
 	mov al, 0xFC
 	out 0x21, al
 	; Mask every interrupts
 	mov al, 0xFF
 	out 0xA1, al
 	; Send EOI
 	mov al, 0x20
 	out 0x20, al

 	lidt [idtr]
 	sti
 	popa
	ret

mask1 db 0
mask2 db 0
