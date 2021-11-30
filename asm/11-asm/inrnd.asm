;--------------------------------------------------------------------------------------------
; inrnd.asm - единица компиляции, вбирающая функции для генерации случайных входных данных
;--------------------------------------------------------------------------------------------

extern rand
extern Encrypt

;----------------------------------------------
; Заполняет шифрование случайными данными (в том числе случайный тип шифрования)
; bool RandomEncryption(Encryption *block)
; {
;     block->encryption_type = 1 + rand() % 3;
    ; block->shift = rand() % 101;
    ; block->encryption_alphabet[0] = 'a' + rand() % 26;
    ; block->encryption_alphabet[1] = 'a' + rand() % 26;
    ; block->number_alphabet[0] = 'a' + rand() % 26;
    ; block->number_alphabet[1] = 48 + rand() % 10;
    ; int len = 1 + rand() % 31;
    ; for (int i = 0; i < len; ++i)
    ; {
    ;     block->text[i] = 'a' + rand() % 26;
    ;     block->encrypted_text[i] = 0;
    ; }
;     return true;
; }
;----------------------------------------------
global RandomEncryption
RandomEncryption:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    mov     qword[rbp-24], rdi
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, 1431655766
    shr     rdx, 32
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    mov     ecx, edx
    add     ecx, ecx
    add     ecx, edx
    sub     eax, ecx
    mov     edx, eax
    add     edx, 1
    mov     rax, qword[rbp-24]
    mov     dword[rax], edx
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, 680390859
    shr     rdx, 32
    sar     edx, 4
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    imul    ecx, edx, 101
    sub     eax, ecx
    mov     edx, eax
    mov     rax, qword[rbp-24]
    mov     dword[rax+4], edx
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, 1321528399
    shr     rdx, 32
    sar     edx, 3
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    imul    ecx, edx, 26
    sub     eax, ecx
    mov     edx, eax
    mov     eax, edx
    add     eax, 97
    mov     edx, eax
    mov     rax, qword[rbp-24]
    mov     byte[rax+8], dl
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, 1321528399
    shr     rdx, 32
    sar     edx, 3
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    imul    ecx, edx, 26
    sub     eax, ecx
    mov     edx, eax
    mov     eax, edx
    add     eax, 97
    mov     edx, eax
    mov     rax, qword[rbp-24]
    mov     byte[rax+9], dl
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, 1321528399
    shr     rdx, 32
    sar     edx, 3
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    imul    ecx, edx, 26
    sub     eax, ecx
    mov     edx, eax
    mov     eax, edx
    add     eax, 97
    mov     edx, eax
    mov     rax, qword[rbp-24]
    mov     byte[rax+10], dl
    call    rand
    mov     edx, eax
    movsx   rax, edx
    imul    rax, rax, 1717986919
    shr     rax, 32
    sar     eax, 2
    mov     esi, edx
    sar     esi, 31
    sub     eax, esi
    mov     ecx, eax
    mov     eax, ecx
    sal     eax, 2
    add     eax, ecx
    add     eax, eax
    mov     ecx, edx
    sub     ecx, eax
    mov     eax, ecx
    add     eax, 48
    mov     edx, eax
    mov     rax, qword[rbp-24]
    mov     byte[rax+11], dl
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, -2004318071
    shr     rdx, 32
    add     edx, eax
    sar     edx, 3
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    mov     ecx, edx
    sal     ecx, 4
    sub     ecx, edx
    sub     eax, ecx
    mov     edx, eax
    lea     eax, [rdx+1]
    mov     dword[rbp-8], eax
    mov     dword[rbp-4], 0
    jmp     .for_cond
.for_loop:
    call    rand
    movsx   rdx, eax
    imul    rdx, rdx, 1321528399
    shr     rdx, 32
    sar     edx, 3
    mov     ecx, eax
    sar     ecx, 31
    sub     edx, ecx
    imul    ecx, edx, 26
    sub     eax, ecx
    mov     edx, eax
    mov     eax, edx
    add     eax, 97
    mov     ecx, eax
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+12+rax], cl
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], 0
    add     dword[rbp-4], 1
.for_cond:
    mov     eax, dword[rbp-4]
    cmp     eax, dword[rbp-8]
    jl      .for_loop
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Заполняет контейнер случайными шифрованиями
; bool InRndContainer(Container *cont)
; {
;     cont->size = rand() % 10001;
;     for (int i = 0; i < cont->size; ++i) {
;         RandomEncryption(&cont->encryptions[i]);
;     }
; }
;----------------------------------------------
global InRndContainer
InRndContainer:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    mov     qword[rbp-24], rdi
    mov     dword[rbp-28], esi
    mov     rax, qword[rbp-24]
    mov     edx, dword[rbp-28]
    mov     dword[rax], edx
    mov     dword[rbp-4], 0
    jmp     .for_cond
.for_loop:
    mov     eax, dword[rbp-4]
    cdqe
    imul    rdx, rax, 212
    mov     rax, qword[rbp-24]
    add     rax, rdx
    add     rax, 4
    mov     rdi, rax
    call    RandomEncryption
    mov     eax, dword[rbp-4]
    cdqe
    imul    rdx, rax, 212
    mov     rax, qword[rbp-24]
    add     rax, rdx
    add     rax, 4
    mov     rdi, rax
    call    Encrypt
    add     dword[rbp-4], 1
.for_cond:
    mov     eax, dword[rbp-4]
    cmp     eax, dword[rbp-28]
    jl      .for_loop
    mov     eax, 1
    leave
    ret