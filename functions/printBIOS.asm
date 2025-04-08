; Print a string using the BIOS interrupt 10h
print_string:
    mov ah, 0x0E
print_loop:
    lodsb
    or al, al
    jz done
    int 0x10
    jmp print_loop
done:
    ret
