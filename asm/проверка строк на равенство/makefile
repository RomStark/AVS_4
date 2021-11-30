# makefile for task.asm
test-streq: test-streq.o
	gcc -g -o test-streq test-streq.o -no-pie
test-streq.o: test-streq.asm macros.mac
	nasm -f elf64 -g -F dwarf test-streq.asm -l test-streq.lst
