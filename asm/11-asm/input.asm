extern fscanf

extern Encrypt
extern CreateEmptyEncryption

extern DIRECT_ENCRYPTION
extern CYCLE_ENCRYPTION
extern NUMBER_ENCRYPTION

section .data
    format1 db "%1s%1s", 0
    format2 db "%100s", 0
    format3 db "%d", 0

;----------------------------------------------
; Ввод параметров прямого(алфавитного) шифрования
; Encryption *InDirectEncryption(FILE *fin, Encryption *block)
; {
;     fscanf(fin, "%1s%1s", &block->encryption_alphabet[0], &block->encryption_alphabet[1]);
;     fscanf(fin, "%100s", block->text);
;     return block;
; }
;----------------------------------------------
global InDirectEncryption
InDirectEncryption:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16
    mov     qword[rbp-8], rdi
    mov     qword[rbp-16], rsi
    mov     rax, qword[rbp-16]
    lea     rcx, [rax+9]
    mov     rax, qword[rbp-16]
    lea     rdx, [rax+8]
    mov     rax, qword[rbp-8]
    mov     rsi, format1
    mov     rdi, rax
    mov     eax, 0
    call    fscanf
    mov     rax, qword[rbp-16]
    lea     rdx, [rax+12]
    mov     rax, qword[rbp-8]
    mov     rsi, format2
    mov     rdi, rax
    mov     eax, 0
    call    fscanf
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Ввод параметров циклического шифрования
; Encryption *InCycleEncryption(FILE *fin, Encryption *block)
; {
;     fscanf(fin, "%d", &block->shift);
;     fscanf(fin, "%100s", block->text);
;     return block;
; }
;----------------------------------------------
global InCycleEncryption
InCycleEncryption:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16
    mov     qword[rbp-8], rdi
    mov     qword[rbp-16], rsi
    mov     rax, qword[rbp-16]
    lea     rdx, [rax+4]
    mov     rax, qword[rbp-8]
    mov     rsi, format3
    mov     rdi, rax
    mov     eax, 0
    call    fscanf
    mov     rax, qword[rbp-16]
    lea     rdx, [rax+12]
    mov     rax, qword[rbp-8]
    mov     rsi, format2
    mov     rdi, rax
    mov     eax, 0
    call    fscanf
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Ввод параметров численного шифрования
; Encryption *InNumberEncryption(FILE *fin, Encryption *block)
; {
;     fscanf(fin, "%1s%1s", &block->number_alphabet[0], &block->number_alphabet[1]);
;     fscanf(fin, "%100s", block->text);
;     return block;
; }
;----------------------------------------------
global InNumberEncryption
InNumberEncryption:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16
    mov     qword[rbp-8], rdi
    mov     qword[rbp-16], rsi
    mov     rax, qword[rbp-16]
    lea     rcx, [rax+11]
    mov     rax, qword[rbp-16]
    lea     rdx, [rax+10]
    mov     rax, qword[rbp-8]
    mov     rsi, format1
    mov     rdi, rax
    mov     eax, 0
    call    fscanf
    mov     rax, qword[rbp-16]
    lea     rdx, [rax+12]
    mov     rax, qword[rbp-8]
    mov     rsi, format2
    mov     rdi, rax
    mov     eax, 0
    call    fscanf
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Ввод параметров шифрования
; Encryption *InEncryption(FILE *fin, Encryption *block)
; {
;     int mode = 0;
;     fscanf(fin, "%d", &mode);
;     block->encryption_type = mode;
;     switch (mode)
;     {
;     case 1:
;         InDirectEncryption(fin, block);
;         break;
;     case 2:
;         InCycleEncryption(fin, block);
;         break;
;     case 3:
;         InNumberEncryption(fin, block);
;         break;
;     }
;     return block;
; }
;----------------------------------------------
global InEncryption
InEncryption:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov qword[rbp-24], rdi
    mov qword[rbp-32], rsi
    mov dword[rbp-4], 0
    lea rdx, [rbp-4]
    mov rax, qword[rbp-24]
    mov rsi, format3
    mov rdi, rax
    mov eax, 0
    call fscanf
    mov edx, dword[rbp-4]
    mov rax, qword[rbp-32]
    mov dword[rax], edx
    mov eax, dword[rbp-4]
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
    mov rdx, qword[rbp-32]
    mov rax, qword[rbp-24]
    mov rsi, rdx
    mov rdi, rax
    call InDirectEncryption
    jmp .return
.switch2:
    mov rdx, qword[rbp-32]
    mov rax, qword[rbp-24]
    mov rsi, rdx
    mov rdi, rax
    call InCycleEncryption
    jmp .return
.switch3:
    mov rdx, qword[rbp-32]
    mov rax, qword[rbp-24]
    mov rsi, rdx
    mov rdi, rax
    call InNumberEncryption
.return:
    mov eax, 1
    leave
    ret

;----------------------------------------------
; Ввод содержимого контейнера из файла
; Container *InContainer(FILE *fin)
; {
;     int n = 0;
;     fscanf(fin, "%d", &n);
;     x->size = n;
;     for (int i = 0; i < x->size; ++i)
;     {
;         create_empty_encryption(&x->encryptions[i]);
;         InEncryption(fin, &x->encryptions[i]);
;         Encrypt(&x->encryptions[i]);
;     }
;     return x;
; }
;----------------------------------------------
global InContainer
InContainer:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov qword[rbp-24], rdi
    mov qword[rbp-32], rsi
    mov dword[rbp-8], 0
    lea rdx, [rbp-8]
    mov rax, qword[rbp-24]
    mov rsi, format3
    mov rdi, rax
    mov eax, 0
    call fscanf
    mov edx, dword[rbp-8]
    mov rax, qword[rbp-32]
    mov dword[rax], edx
    mov dword[rbp-4], 0
    jmp .for_cond
.for_loop:
    mov eax, dword[rbp-4]
    cdqe
    imul rdx, rax, 212
    mov rax, qword[rbp-32]
    add rax, rdx
    add rax, 4
    mov rdi, rax
    call CreateEmptyEncryption
    mov eax, dword[rbp-4]
    cdqe
    imul rdx, rax, 212
    mov rax, qword[rbp-32]
    add rax, rdx
    lea rdx, [rax+4]
    mov rax, qword[rbp-24]
    mov rsi, rdx
    mov rdi, rax
    call InEncryption
    mov eax, dword[rbp-4]
    cdqe
    imul rdx, rax, 212
    mov rax, qword[rbp-32]
    add rax, rdx
    add rax, 4
    mov rdi, rax
    call Encrypt
    add dword[rbp-4], 1
.for_cond:
    mov rax, qword[rbp-32]
    mov eax, dword[rax]
    cmp dword[rbp-4], eax
    jl .for_loop
    mov eax, 1
    leave
    ret