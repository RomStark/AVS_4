# makefile for task.asm
test-strlen: test-strlen.o
	gcc -g -o test-strlen test-strlen.o -no-pie
test-strlen.o: test-strlen.asm macros.mac
	nasm -f elf64 -g -F dwarf test-strlen.asm -l test-strlen.lst
