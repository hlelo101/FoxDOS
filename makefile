AS = nasm
ASFLAGS = -f bin
TERM = alacritty
TERMFLAGS = -e
DBG = gdb
DBGFLAGS = -ex

all: assemble mkimg clean

assemble:
	$(AS) $(ASFLAGS) boot.asm -o boot.bin				# Bootloader
	$(AS) $(ASFLAGS) ilinas/ilinas.asm -o ilinas.bin	# Kernel
	$(AS) $(ASFLAGS) shell/shell.asm -o shell.bin		# Shell
	$(AS) $(ASFLAGS) apps/appdir.asm -o appdir.bin		# App directory
	$(AS) $(ASFLAGS) apps/ver/ver.asm -o ver.bin		# VER
	$(AS) $(ASFLAGS) apps/third/third.asm -o third.bin	# Third

mkimg:
	dd if=boot.bin of=disk.img bs=512 seek=0
	dd if=ilinas.bin of=disk.img bs=512 seek=1
	dd if=shell.bin of=disk.img bs=512 seek=7
	dd if=ver.bin of=disk.img bs=512 seek=8
	dd if=third.bin of=disk.img bs=512 seek=9
	dd if=appdir.bin of=disk.img bs=512 seek=10
	dd if=/dev/zero of=disk.img bs=512 seek=11 count=32768

clean:
	rm *.bin

run:
	qemu-system-i386 -drive format=raw,file=disk.img,if=ide -monitor stdio

rundbg:
	qemu-system-i386 -drive format=raw,file=disk.img,if=ide -s -S -monitor stdio

debug: opengdb rundbg

opengdb:
	$(TERM) $(TERMFLAGS) $(DBG) $(DBGFLAGS) "target remote localhost:1234" &
