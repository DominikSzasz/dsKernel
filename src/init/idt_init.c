#include "idt_init.h"
// #include "../drivers/keyboard_map.h"
struct IDT_entry IDT[IDT_SIZE]; 
void disable_cursor() {
	ioport_out(0x3D4, 0x0A);
	ioport_out(0x3D5, 0x20);
}
void init_idt() {
	unsigned int kb_handler_offset = (unsigned int)keyboard_handler;

	IDT[0x21].offset_lowerbits = kb_handler_offset & 0x0000FFFF; // lower 16 bits
	IDT[0x21].selector = KERNEL_CODE_SEGMENT_OFFSET;
	IDT[0x21].zero = 0;
	IDT[0x21].type_attr = IDT_INTERRUPT_GATE_32BIT;
	IDT[0x21].offset_upperbits = (kb_handler_offset & 0xFFFF0000) >> 16;
	ioport_out(PIC1_COMMAND_PORT, 0x11);
	ioport_out(PIC2_COMMAND_PORT, 0x11);
	ioport_out(PIC1_DATA_PORT, 0x20);
	ioport_out(PIC2_DATA_PORT, 0x28);
	ioport_out(PIC1_DATA_PORT, 0x0);
	ioport_out(PIC2_DATA_PORT, 0x0);
	ioport_out(PIC1_DATA_PORT, 0x1);
	ioport_out(PIC2_DATA_PORT, 0x1);
	ioport_out(PIC1_DATA_PORT, 0xff);
	ioport_out(PIC2_DATA_PORT, 0xff);
	struct IDT_pointer idt_ptr;
	idt_ptr.limit = (sizeof(struct IDT_entry) * IDT_SIZE) - 1;
	idt_ptr.base = (unsigned int) &IDT;
	load_idt(&idt_ptr);
}

void kb_init() {
	ioport_out(PIC1_DATA_PORT, 0xFD);
}


	