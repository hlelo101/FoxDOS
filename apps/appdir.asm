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

db 4 ; 4 entries
; 1st entry, the shell
dw 8 ; 8th sector
dw 1 ; Takes 1 sector
; 2nd entry, ver
dw 9
dw 3
; 3rd entry, the 3rd app
dw 11
dw 1
; 4th entry, error test app
dw 12
dw 1
