; GDT - Global Descriptor Table
gdt_start:
gdt_null:	; Entry 1: Null entry must be included first (error check)
	dd 0x0	; double word = 4 bytes = 32 bits
	dd 0x0
gdt_code:	; Entry 2: Code segment descriptor
	dw 0xffff	; Limit bits 0-15
	dw 0x0000	; Base bits 0-15
	db 0x00		; Base bits 16-23
	db 10011010b	; Flag set 1 and 2
	db 11001111b	; Flag set 3 and limit bits 16-19
	db 0x00		; Base bits 24-31
gdt_data:
	; Same except for code flag:
		; Code: 0b0
	dw 0xfffff	; Limit bits 0-15
	dw 0x0000	; Base bits 0-15
	db 0x00		; Base bits 16-23
	db 10010010b	; Flag set 1 and 2
	db 11001111b	; 2nd flags and limit bits 16-19
	db 0x00		; Base bits 24-31

gdt_end:		; Needed to calculate GDT size for inclusion in GDT descriptor

; GDT Descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1	; Size of GDT, always less one
	dd gdt_start

; Define constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

