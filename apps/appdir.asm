; ### Application directory ###
; This file lets FoxDOS see every applications.
; It's made of entries. Each entries has an application's
; location (in sectors) and the number of sectors it 
; takes. One entry is a 32-bit value made out of 2 16-bit
; values: The first one is the application's location, the
; second one its size.
; The only exception is the first entry: It's a 8-bit 
; value describing the number of entries.
;
; The application directory must always be stored in
; the 10th sector (10*512 bytes).

db 6 ; 6 entries
; Entry 0, the shell
dw 11 ; 8th sector
dw 2  ; Takes 2 sectors
; Entry 1, ver
dw 13
dw 1
; Entry 2, the 3rd app
dw 9
dw 1
; Entry 3, error test app
dw 14
dw 1
; Entry 4, memEdit
dw 15
dw 3
; Entry 5, int
dw 19
dw 1
