
int main() {
	clear_screen();

	disable_cursor();
	init_idt();
	kb_init();
	enable_interrupts();
	print_message();
	print_prompt();
	// test('test', 2, 3);
	// print_char_with_asm('test', 5,2);
	while(1);
}
