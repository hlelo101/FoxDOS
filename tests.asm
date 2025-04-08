; This code has been used to test some functions of FoxDOS

; Test sleep
mov ah, DEFAULT_COLOR_ATTRIBUTE
mov ebx, sleep_test1
call print_string_pm
mov eax, 1000000
call sleep
mov ah, DEFAULT_COLOR_ATTRIBUTE
mov ebx, sleep_test2
call print_string_pm
