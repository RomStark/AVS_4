# makefile for task.asm
test-strcpy: test-strcpy.o
	gcc -g -o test-strcpy test-strcpy.o -no-pie
test-strcpy.o: test-strcpy.asm macros.mac
	nasm -f elf64 -g -F dwarf test-strcpy.asm -l test-strcpy.lst
