#Tools/Boilerplates
CC = i386-elf-gcc
CFLAGS = -ffreestanding -c
CCSCRIPT = $(CC) $(CFLAGS)

LINKER = i386-elf-ld 
LFLAGS = -T ${LINKERFILE} -o 
LINKERSCRIPT = $(LINKER) $(LFLAGS)

ASSEMBLER = nasm
ASMFLAGS = -f elf32
ASSEMBLERSCRIPT = $(ASSEMBLER) $(ASMFLAGS)
EMULATOR = qemu-system-i386 -kernel

# Directories
SRC=src
BUILDDIR=$(SRC)/build
BOOTDIR=$(SRC)/boot
KERNELDIR=$(SRC)/kernel
DRIVERSDIR=$(SRC)/drivers
LIBDIR=$(SRC)/lib
INITDIR=$(SRC)/init

# Files
BOOTLOADER=$(BOOTDIR)/boot.asm
LINKERFILE=$(BOOTDIR)/linker.ld
KERNEL=$(KERNELDIR)/kernel.c
BINFILE=$(BUILDDIR)/dsKernel.bin

default:
#	Directories
	mkdir -p $(BUILDDIR) 

#	Assembly Files
	$(ASSEMBLERSCRIPT) $(BOOTLOADER) -o $(BUILDDIR)/boot.o 
	$(ASSEMBLERSCRIPT) $(DRIVERSDIR)/screen.asm -o $(BUILDDIR)/screen.o 
	$(ASSEMBLERSCRIPT) $(LIBDIR)/memory.asm -o $(BUILDDIR)/memory.o

#	C Files
	$(CCSCRIPT) $(KERNEL) -o $(BUILDDIR)/kernel.o
	$(CCSCRIPT) $(LIBDIR)/stdlib.c -o $(BUILDDIR)/stdlib.o
	$(CCSCRIPT) $(INITDIR)/idt_init.c -o $(BUILDDIR)/idt_init.o
	$(CCSCRIPT) $(DRIVERSDIR)/screen_driver.c -o $(BUILDDIR)/screen_driver.o
	$(CCSCRIPT) $(DRIVERSDIR)/keyboard_handler.c -o $(BUILDDIR)/keyboard_handler.o
	$(CCSCRIPT) $(DRIVERSDIR)/vga.c -o $(BUILDDIR)/vga.o
	$(CCSCRIPT) $(LIBDIR)/mem.c -o $(BUILDDIR)/mem.o

#	Linking
	$(LINKERSCRIPT) $(BINFILE) $(BUILDDIR)/boot.o $(BUILDDIR)/idt_init.o $(BUILDDIR)/kernel.o $(BUILDDIR)/screen.o $(BUILDDIR)/stdlib.o $(BUILDDIR)/screen_driver.o $(BUILDDIR)/keyboard_handler.o $(BUILDDIR)/vga.o $(BUILDDIR)/mem.o $(BUILDDIR)/memory.o

#	Emulating
	$(EMULATOR) $(BINFILE)

#	Only Emulate
run:
	$(EMULATOR) $(BINFILE)

#	Clear Build Directory
clean:
	rm -r $(BUILDDIR) 