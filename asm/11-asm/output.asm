extern printf
extern fprintf
extern fwrite

extern func

extern DIRECT_ENCRYPTION
extern CYCLE_ENCRYPTION
extern NUMBER_ENCRYPTION

section .data
    format1 db "character encryption: text = %s | encrypted text = %s | symbols = ['%c' -> '%c'] | func result = %lf", 10, 0
    format2 db "cycle encryption: text = %s | encrypted text = %s | n = %d | func result = %lf", 10, 0
    format3 db "number encryption: text = %s | encrypted text = %s | symbols = ['%c' -> '%c'] | func result = %lf", 10, 0


;----------------------------------------------
; Вывод прямого(алфавитного) шифрования в файл
; Encryption *OutDirectEncryption(FILE *fout, Encryption *block)
; {
;     fprintf(fout, "character encryption: text = %s | encrypted text = %s | symbols = [\'%c\' -> \'%c\'] | func result = %lf\n",
;             block->text, block->encrypted_text, block->encryption_alphabet[0], block->encryption_alphabet[1], func(block->text));
;     return block;
; }
;----------------------------------------------
global OutDirectEncryption
OutDirectEncryption:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword[rbp-8], rdi
    mov qword[rbp-16], rsi
    mov rax, qword[rbp-16]
    add rax, 12
    mov rdi, rax
    call func
    movq rax, xmm0
    mov rdx, qword[rbp-16]
    movzx edx, byte[rdx+9]
    movsx r8d, dl
    mov rdx, qword[rbp-16]
    movzx edx, byte[rdx+8]
    movsx esi, dl
    mov rdx, qword[rbp-16]
    lea rcx, [rdx+112]
    mov rdx, qword[rbp-16]
    add rdx, 12
    mov rdi, qword[rbp-8]
    movq xmm0, rax
    mov r9d, r8d
    mov r8d, esi
    mov rsi, format1
    mov eax, 1
    call fprintf
    mov eax, 1
    leave
    ret

;----------------------------------------------
; Вывод циклического шифрования в файл
; Encryption *OutCycleEncryption(FILE *fout, Encryption *block)
; {
;     fprintf(fout, "cycle encryption: text = %s | encrypted text = %s | n = %d | func result = %lf\n",
;             block->text, block->encrypted_text, block->shift, func(block->text));
;     return block;
; }
;----------------------------------------------
global OutCycleEncryption
OutCycleEncryption:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword[rbp-8], rdi
    mov qword[rbp-16], rsi
    mov rax, qword[rbp-16]
    add rax, 12
    mov rdi, rax
    call func
    movq rax, xmm0
    mov rdx, qword[rbp-16]
    mov esi, dword[rdx+4]
    mov rdx, qword[rbp-16]
    lea rcx, [rdx+112]
    mov rdx, qword[rbp-16]
    add rdx, 12
    mov rdi, qword[rbp-8]
    movq xmm0, rax
    mov r8d, esi
    mov rsi, format2
    mov eax, 1
    call fprintf
    mov eax, 1
    leave
    ret

;----------------------------------------------
; Вывод численного шифрования в файл
; Encryption *OutNumberEncryption(FILE *fout, Encryption *block)
; {
;     fprintf(fout, "number encryption: text = %s | encrypted text = %s | symbols = [\'%c\' -> \'%c\'] | func result = %lf\n",
;             block->text, block->encrypted_text, block->number_alphabet[0], block->number_alphabet[1], func(block->text));
;     return block;
; }
;----------------------------------------------
global OutNumberEncryption
OutNumberEncryption:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword[rbp-8], rdi
    mov qword[rbp-16], rsi
    mov rax, qword[rbp-16]
    add rax, 12
    mov rdi, rax
    call func
    movq rax, xmm0
    mov rdx, qword[rbp-16]
    movzx edx, byte[rdx+11]
    movsx r8d, dl
    mov rdx, qword[rbp-16]
    movzx edx, byte[rdx+10]
    movsx esi, dl
    mov rdx, qword[rbp-16]
    lea rcx, [rdx+112]
    mov rdx, qword[rbp-16]
    add rdx, 12
    mov rdi, qword[rbp-8]
    movq xmm0, rax
    mov r9d, r8d
    mov r8d, esi
    mov rsi, format3
    mov eax, 1
    call fprintf
    mov eax, 1
    leave
    ret

;----------------------------------------------
; // Вывод шифрования в файл
; Encryption *OutEncryption(FILE *fout, Encryption *block)
; {
;     switch (block->encryption_type)
;     {
;     case 1:
;         OutDirectEncryption(fout, block);
;         break;
;     case 2:
;         OutCycleEncryption(fout, block);
;         break;
;     case 3:
;         OutNumberEncryption(fout, block);
;         break;
;     }
;     return block;
; }
;----------------------------------------------
global OutEncryption
OutEncryption:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword[rbp-8], rdi
    mov qword[rbp-16], rsi
    mov rax, qword[rbp-16]
    mov eax, dword[rax]
    mov edx, dword[NUMBER_ENCRYPTION]
    cmp eax, edx
    je .switch3
    mov edx, dword[NUMBER_ENCRYPTION]
    cmp eax, edx
    jg .return
    mov edx, dword[DIRECT_ENCRYPTION]
    cmp eax, edx
    je .switch1
    mov edx, dword[CYCLE_ENCRYPTION]
    cmp eax, edx
    je .switch2
    jmp .return
.switch1:
    mov rdx, qword[rbp-16]
    mov rax, qword[rbp-8]
    mov rsi, rdx
    mov rdi, rax
    call OutDirectEncryption
    jmp .return
.switch2:
    mov rdx, qword[rbp-16]
    mov rax, qword[rbp-8]
    mov rsi, rdx
    mov rdi, rax
    call OutCycleEncryption
    jmp .return
.switch3:
    mov rdx, qword[rbp-16]
    mov rax, qword[rbp-8]
    mov rsi, rdx
    mov rdi, rax
    call OutNumberEncryption
.return:
    mov eax, 1
    leave
    ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл
; Container *OutContainer(FILE *fout, Container *cont)
; {
;     fprintf(fout, "Container:\n");
;     for (int i = 0; i < cont->size; ++i)
;     {
;         OutEncryption(fout, &cont->encryptions[i]);
;     }
;     return cont;
; }
global OutContainer
OutContainer:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov qword[rbp-24], rdi
    mov qword[rbp-32], rsi
    mov dword[rbp-4], 0
    jmp .for_cond
.for_loop:
    mov eax, dword[rbp-4]
    cdqe
    imul rdx, rax, 212
    mov rax, qword[rbp-32]
    add rax, rdx
    lea rdx, [rax+4]
    mov rax, qword[rbp-24]
    mov rsi, rdx
    mov rdi, rax
    call OutEncryption
    add dword[rbp-4], 1
.for_cond:
    mov rax, qword[rbp-32]
    mov eax, dword[rax]
    cmp dword[rbp-4], eax
    jl .for_loop
    mov eax, 1
    leave
    ret