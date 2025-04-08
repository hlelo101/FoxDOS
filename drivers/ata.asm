; IDE primary channel registers start at 0x1F0
; IDE secondary channel registers start at 0x170
; FoxDOS will use only the primary device

ata_drive_isr:
	cli
	pusha
	mov ebx, ide_interrupt_msg
	mov ah, DEFAULT_COLOR_ATTRIBUTE
	call print_string_pm
	popa
	sti
	iret

ide_sleep_1:
	mov eax, 1
	call sleep

ide_busy_wait:
	mov dx, 0x1F7
	in  al, dx
	test al, 0x80
	jnz ide_busy_wait
	ret

ide_ready_wait:
	mov dx, 0x1F7
	in al, dx
	test al, 0x08
	jz ide_ready_wait
	ret

init_ide:
	; Wait for it to not be busy
	call ide_busy_wait
	; Select the master drive
	mov dx, 0x1F6
	mov al, 0xA0
	out dx, al
	call ide_busy_wait
	; Check if the drive is present
	mov dx, 0x1F7
	in al, dx
	cmp al, 0x00
	je no_drive_present
	cmp al, 0xFF
	je no_drive_present
	
	; IDENTIFY
	; TODO: Maste identify
	jmp init_ide_done
no_drive_present:
	mov ah, 0x21
	mov ebx, ide_no_drive_present
	call print_string_pm
init_ide_done:
	ret

; Load from		in ebx
; Load to		in ecx
ide_read:
	cli
	pusha
	push ebx
	; Compute high nibble of LBA from EBX
	mov eax, ebx
	shr eax, 24
	and al, 0x0F
	mov cl, al

	; Set up drive/head register (0x1F6) for Master drive in LBA mode
	mov al, 0xE0
	or  al, cl
	mov dx, 0x1F6
	out dx, al

	; 1 sector
	mov al, 0x01
	mov dx, 0x1F2
	out dx, al

	pop ebx

	; Send the LBA
	; LBA 0-7 (lowest byte of EBX)
	mov dx, 0x1F3
	mov al, bl
	out dx, al
	; LBA 8-15 (next byte of EBX)
	mov dx, 0x1F4
	mov al, bh
	out dx, al
	; LBA 16-23: Shift EBX right 16 bits to bring the next byte into BL
	mov eax, ebx
	shr eax, 16
	mov dx, 0x1F5
	out dx, al

	; Read command
	mov al, 0x20
	mov dx, 0x1F7
	out dx, al

	call ide_busy_wait
	call ide_ready_wait

	; Read the data and store it in the address specified by ecx
	xor ebx, ebx
	mov dx, 0x1F0
ide_read_loop:
	in ax, dx
	mov [ecx + ebx], ax
	add ebx, 2
	cmp ebx, 512
	jl ide_read_loop

	popa
	sti
	ret

ide_interrupt_msg db '[IDE]: New interrupt', 10, 0
ide_not_ata_err_msg db '[IDE]: Error: The IDE drive is not an ATA drive', 10, 0
ide_lba_supported_msg db '[IDE]: LBA addressing supported', 10, 0
ide_no_drive_present db '[IDE]: Error: No drive present', 10, 0
identify_response: times 512 db 0
