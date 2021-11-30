# makefile for task.asm
task: main.o input.o inrnd.o output.o utils.o func.o
	gcc -g -o task main.o input.o inrnd.o output.o utils.o func.o -no-pie
main.o: main.asm macros.mac
	nasm -f elf64 -g -F dwarf main.asm -l main.lst
input.o: input.asm
	nasm -f elf64 -g -F dwarf input.asm -l input.lst
inrnd.o: inrnd.asm
	nasm -f elf64 -g -F dwarf inrnd.asm -l inrnd.lst
output.o: output.asm
	nasm -f elf64 -g -F dwarf output.asm -l output.lst
func.o: func.asm
	nasm -f elf64 -g -F dwarf func.asm -l func.lst
utils.o: utils.asm
	nasm -f elf64 -g -F dwarf utils.asm -l utils.lst
