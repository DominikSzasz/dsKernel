bits 32
section .multiboot
	dd 0x1BADB002	; Magic number
	dd 0x0			; Flags
	dd - (0x1BADB002 + 0x0)	; Checksum

section .text

%include "src/boot/gdt.asm"

global start
global load_gdt
global load_idt
global keyboard_handler
global ioport_in
global ioport_out
global inl
global outl
global enable_interrupts

extern main			; Defined in kernel.c
extern handle_keyboard_interrupt

load_gdt:
	lgdt [gdt_descriptor] ; from gdt.asm
	ret

load_idt:
	mov edx, [esp + 4]
	lidt [edx]
	ret

enable_interrupts:
	sti
	ret

keyboard_handler:
	pushad
	cld
	call handle_keyboard_interrupt
	popad
	iretd

ioport_in:
	mov edx, [esp + 4]
	in al, dx					 
	ret

ioport_out:
	mov edx, [esp + 4]
	mov eax, [esp + 8]
	out dx, al
	ret
inl:
	mov edx, [esp + 4]
	in eax, dx
	ret

outl:
	mov edx, [esp + 4]
	mov eax, [esp + 8]
	out dx, eax
	ret

start:
	lgdt [gdt_descriptor]
	jmp CODE_SEG:.setcs      
	.setcs:
	mov ax, DATA_SEG          
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esp, stack_space        
	cli
	mov esp, stack_space
	call main
	hlt

section .bss
resb 8192
stack_space:
