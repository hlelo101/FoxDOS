TABLE_LOAD_ADDRESS equ 0x2000
; ## Options ##
; AL: App index
; ## Returns ##
; AX: App location
; BX: App size
; NOTE: App index starts at 0
get_app:
	push ecx
	push edx
	; Load the table to 0x2000 because... Why the fuck not
	mov ecx, TABLE_LOAD_ADDRESS
	mov ebx, 10 ; The table is located at sector 10
	call ide_read
	; Get the number of apps and ensure
	; the requested app exists
	mov bl, [TABLE_LOAD_ADDRESS]
	cmp al, bl
	jae get_app_app_not_found
	; Calculate the app offset
	xor ebx, ebx
	mov bl, al
	xor eax, eax
	mov ax, 4
	mul bx
	add ax, 1 ; 8 bits of the number of apps
	; Get the location/size and store it in AX/BX
	; Offset is CX
	mov ecx, TABLE_LOAD_ADDRESS
	add ecx, eax	; Previously calculated offset
	mov ax, [ecx]	; Location
	add ecx, 2
	mov bx, [ecx]	; Size

	jmp get_app_done
get_app_app_not_found:
	mov ah, 0x04
	mov ebx, app_not_found_msg
	call print_string_pm
	xor ax, ax
	xor bx, bx
get_app_done:	
	pop ecx
	pop edx
	ret

app_not_found_msg db "[APPDIR Parser]: Invalid index/Not found", 10, 0
