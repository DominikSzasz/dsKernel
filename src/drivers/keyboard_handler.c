#include "../init/idt_init.h"
#include "./keyboard_handler.h"
#include "./screen_driver.h"
#include "./keyboard_map.h"
#include "../drivers/vga.h"

void handle_keyboard_interrupt() {
	// Write end of interrupt (EOI)
	ioport_out(PIC1_COMMAND_PORT, 0x20);

	unsigned char status = ioport_in(KEYBOARD_STATUS_PORT);
	// Lowest bit of status will be set if buffer not empty
	// (thanks mkeykernel)
	if (status & 0x1) {
		char keycode = ioport_in(KEYBOARD_DATA_PORT);
		if (keycode < 0 || keycode >= 128) return;
		if (keycode == 28) {
			// ENTER : Newline
			newline();
			// null terminate command buffer
			command_buffer[command_len] = '\0';
			// Handle command
			if (streq(command_buffer, "ls")) {
				println("Filesystem not yet implemented.");
			} else if (streq(command_buffer, "clear")) {
				clear_screen();
			} else if (streq(command_buffer, "vga")) {
				vga_test();
			} else if (streq(command_buffer, "breakout")) {
				breakout_game_mode();
            } else if (streq(command_buffer, "pong")) {
                pong_game_mode();
            } else if (streq(command_buffer, "help")) {
				println("ls: List files");
				println("clear: Clear screen");
				println("vga: Run VGA test");
			} else if (command_len < 1) {
				// do nothing
			} else {
				print("Command not found: ");
				println(command_buffer);
				println("Write `help` to see commands.");
			}
			command_len = 0;
			print_prompt();
		} else if (keycode == 14) {
			// BACKSPACE: Move back one unless on prompt
			backspace();
			if (command_len > 0) {
				command_len--;
			}
		// } else if (keycode == 1) {
		// 	// ESCAPE
		// 	exit_mode();
		} else {
			if (command_len >= COMMAND_BUFFER_SIZE) return;
			command_buffer[command_len++] = keyboard_map[keycode];
			printchar(keyboard_map[keycode]);
		}
	}
}