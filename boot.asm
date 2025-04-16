[org 0x7C00]
[bits 16]

KERNEL_ADDR equ 0x1000
COLOR_ATTRIBUTE equ 0xE0

; Save the boot disk
mov [boot_drive], dl
; Print boot message
mov si, msg
call print_string
; Should now be loaded at KERNEL_ADDR
call loadFDOS
call load_gdt
mov si, gdt_loaded
call print_string
jmp set_protected_mode

; Load additional sectors
loadFDOS:
    mov ah, 0x02		; BIOS read sectors
    mov dl, [boot_drive]; Boot disk
    mov ch, 0 			; First cylinder
    mov dh, 0 			; First head
    mov cl, 02h 		; 2nd sector
    mov al, 9 			; Read 9 sectors
 	; Set the destionation address
	xor bx, bx
   	mov es, bx
    mov bx, KERNEL_ADDR
    int 0x13
    jc load_error		; Jump to error handler
    ret

load_error:
    mov si, disk_err
    call print_string	; Print error message
    jmp $				; Retry loading

align 8
gdt:
	; Null
    dq 0
    ; Code segment
    dq 0x00CF9A000000FFFF
    ; Data segment
    dq 0x00CF92000000FFFF

gdtr:
    dw gdt_end - gdt - 1
    dd gdt
    
gdt_end:

load_gdt:
	lgdt [gdtr]
	ret

hang:
    jmp hang

halt:
	hlt
	jmp halt
set_protected_mode:
	cli
	mov eax, cr0
	or al, 1
	mov cr0, eax

	jmp 08h:init_protected_mode

[bits 32]
VIDEO_MEM_ADDR equ 0xB8000

init_protected_mode:
	mov ax, 0x10
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0xFFF
	mov esp, ebp
	jmp protected_mode

protected_mode:
	; At this point, protected mode should be enabled
	jmp KERNEL_ADDR

	jmp $

%include "functions/printBIOS.asm"

msg db 'Booting FoxDOS... ', 0
disk_err db 'Disk read error, retrying...', 13, 10, 0
gdt_loaded db 'GDT Loaded.', 0
boot_drive db 0

times 510-($-$$) db 0
dw 0xAA55

