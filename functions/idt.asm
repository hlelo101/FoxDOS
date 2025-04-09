%include "functions/err_handler.asm"

idt:
	; Fill in the entries
	%assign i 0
	%rep 32
	    dw 0
	    dw 0x08              ; code segment
	    db 0
	    db 0x8E              ; present, ring 0, 32-bit int gate
	    dw 0
	%assign i i+1
	%endrep
	; PIT
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
	; Keyboard
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
	; IDE drive
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
	times 11 dq 0
	; IDE drive
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
	times 17 dq 0
	; Print char
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
	; Get input
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
	; Start app
	dw 0 	; isr_low 
	dw 0x08	; code_segment
	db 0 	; reserved
	db 0x8E ; attribute
	dw 0 	; isr_high
idt_end: 

idtr:
	dw idt_end - idt - 1
	dd idt

init_idt:
 	pusha
 	cli
 	; Set up the interrupts
 	%assign i 0
 	%rep 32
 	lea eax, [error_handler_isr]
 	mov word [idt + 8*i], ax
	mov word [idt + 8*i + 32], dx
 	%assign i i+1
 	%endrep
 	; IRQ0, PIT
 	lea eax, [pit_isr]
 	mov word [idt + 8*32], ax
	mov word [idt + 8*32 + 32], dx
 	; IRQ1, PS/2 keyboard
 	lea eax, [ps2_keyboard_isr]
 	mov word [idt + 8*33], ax
	mov word [idt + 8*33 + 32], dx
	; 0x40, Print char
	lea eax, [print_char_isr]
	mov word [idt + 8*64], ax
	mov word [idt + 8*64 + 32], dx
	; 0x41, Get input
	lea eax, [input_isr]
	mov word [idt + 8*65], ax
	mov word [idt + 8*65 + 32], dx
	; 0x42, Start app
	lea eax, [start_app_isr]
	mov word [idt + 8*66], ax
	mov word [idt + 8*66 + 32], dx

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
