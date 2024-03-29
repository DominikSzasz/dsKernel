#ifndef _SCREEN_DRIVER_H
#define _SCREEN_DRIVER_H
#include "../init/idt_init.h"
extern int cursor_row;
extern int cursor_col;
extern char command_buffer[COMMAND_BUFFER_SIZE];
extern int command_len;

#define ROWS 25
#define COLS 80
#define VIDMEM 0xb8000
#define PROMPT "dsKernel->"
#define PROMPT_LENGTH 10

void println(char* string);
void print(char* string);
void safe_println(char* string, int len);
void safe_print(char* string, int len);
void printchar(char c);
void printchar_at(char c, int row, int col);
extern void print_char_with_asm(char c, int row, int col);
void clear_screen();
void print_prompt();
void print_message();
void newline();
void backspace();

#endif
