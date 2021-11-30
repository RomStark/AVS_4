# makefile for task.asm
test-strcmp: test-strcmp.o
	gcc -g -o test-strcmp test-strcmp.o -no-pie
test-strcmp.o: test-strcmp.asm macros.mac
	nasm -f elf64 -g -F dwarf test-strcmp.asm -l test-strcmp.lst
