extern strlen

extern func

extern DIRECT_ENCRYPTION
extern CYCLE_ENCRYPTION
extern NUMBER_ENCRYPTION

;----------------------------------------------
; Создание пустого объекта шифрования
; bool CreateEmptyEncryption(Encryption *block)
; {
;     block->encryption_type = 0;
;     for (int i = 0; i < 100; ++i)
;     {
;         block->text[i] = 0;
;         block->encrypted_text[i] = 0;
;     }
;     for (int i = 0; i < 2; ++i)
;     {
;         block->encryption_alphabet[i] = -1;
;         block->number_alphabet[i] = -1;
;     }
;     return true;
; }
;----------------------------------------------
global CreateEmptyEncryption
CreateEmptyEncryption:
section .text
    push    rbp
    mov     rbp, rsp
    mov     qword[rbp-24], rdi
    mov     rax, qword[rbp-24]
    mov     dword[rax], 0
    mov     dword[rbp-4], 0
    jmp     .for_cond1
.for_loop1:
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+12+rax], 0
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], 0
    add     dword[rbp-4], 1
.for_cond1:
    cmp     dword[rbp-4], 99
    jle     .for_loop1
    mov     dword[rbp-8], 0
    jmp     .for_cond2
.for_loop2:
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-8]
    cdqe
    mov     byte[rdx+8+rax], -1
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-8]
    cdqe
    mov     byte[rdx+10+rax], -1
    add     dword[rbp-8], 1
.for_cond2:
    cmp     dword[rbp-8], 1
    jle     .for_loop2
    mov     eax, 1
    pop     rbp
    ret

;----------------------------------------------
; Создание зашифрованного текста прямым(алфавитным) шифрованием
; bool DirectEncrypt(Encryption *block)
; {
;     int len = strlen(block->text);
;     for (int i = 0; i < len; ++i)
;     {
;         if (block->text[i] == block->encryption_alphabet[0])
;         {
;             block->encrypted_text[i] = block->encryption_alphabet[1];
;         }
;         else
;         {
;             block->encrypted_text[i] = block->text[i];
;         }
;     }
;     return true;
; }
;----------------------------------------------
global DirectEncrypt
DirectEncrypt:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    mov     qword[rbp-24], rdi
    mov     rax, qword[rbp-24]
    add     rax, 12
    mov     rdi, rax
    call    strlen
    mov     dword[rbp-8], eax
    mov     dword[rbp-4], 0
    jmp     .for_cond
.for_loop:
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    movzx   edx, byte[rdx+12+rax]
    mov     rax, qword[rbp-24]
    movzx   eax, byte[rax+8]
    cmp     dl, al
    jne     .else
    mov     rax, qword[rbp-24]
    movzx   ecx, byte[rax+9]
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], cl
    jmp     .loop_end
.else:
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    movzx   ecx, byte[rdx+12+rax]
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], cl
.loop_end:
    add     dword[rbp-4], 1
.for_cond:
    mov     eax, dword[rbp-4]
    cmp     eax, dword[rbp-8]
    jl      .for_loop
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Создание зашифрованного текста циклическим шифрованием
; bool CycleEncrypt(Encryption *block)
; {
;     int len = strlen(block->text);
;     int n = block->shift % len;
;     for (int i = 0; i < len; ++i)
;     {
;         block->encrypted_text[i] = block->text[(i + n) % len];
;     }
;     return true;
; }
;----------------------------------------------
global CycleEncrypt
CycleEncrypt:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    mov     qword[rbp-24], rdi
    mov     rax, qword[rbp-24]
    add     rax, 12
    mov     rdi, rax
    call    strlen
    mov     dword[rbp-8], eax
    mov     rax, qword[rbp-24]
    mov     eax, dword[rax+4]
    cdq
    idiv    dword[rbp-8]
    mov     dword[rbp-12], edx
    mov     dword[rbp-4], 0
    jmp     .for_cond
.for_loop:
    mov     edx, dword[rbp-4]
    mov     eax, dword[rbp-12]
    add     eax, edx
    cdq
    idiv    dword[rbp-8]
    mov     eax, edx
    mov     rdx, qword[rbp-24]
    cdqe
    movzx   ecx, byte[rdx+12+rax]
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], cl
    add     dword[rbp-4], 1
.for_cond:
    mov     eax, dword[rbp-4]
    cmp     eax, dword[rbp-8]
    jl      .for_loop
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Создание зашифрованного текста численным шифрованием
; bool NumberEncrypt(Encryption *block)
; {
;     int len = strlen(block->text);
;     for (int i = 0; i < len; ++i)
;     {
;         if (block->text[i] == block->number_alphabet[0])
;         {
;             block->encrypted_text[i] = block->number_alphabet[1];
;         }
;         else
;         {
;             block->encrypted_text[i] = block->text[i];
;         }
;     }
;     return true;
; }
;----------------------------------------------
global NumberEncrypt
NumberEncrypt:
section .text
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    mov     qword[rbp-24], rdi
    mov     rax, qword[rbp-24]
    add     rax, 12
    mov     rdi, rax
    call    strlen
    mov     dword[rbp-8], eax
    mov     dword[rbp-4], 0
    jmp     .for_cond
.for_loop:
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    movzx   edx, byte[rdx+12+rax]
    mov     rax, qword[rbp-24]
    movzx   eax, byte[rax+10]
    cmp     dl, al
    jne     .else
    mov     rax, qword[rbp-24]
    movzx   ecx, byte[rax+11]
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], cl
    jmp     .loop_end
.else:
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    movzx   ecx, byte[rdx+12+rax]
    mov     rdx, qword[rbp-24]
    mov     eax, dword[rbp-4]
    cdqe
    mov     byte[rdx+112+rax], cl
.loop_end:
    add     dword[rbp-4], 1
.for_cond:
    mov     eax, dword[rbp-4]
    cmp     eax, dword[rbp-8]
    jl      .for_loop
    mov     eax, 1
    leave
    ret

;----------------------------------------------
; Создание зашифрованного текста заданным методом
; bool Encrypt(Encryption *block)
; {
;     switch (block->encryption_type)
;     {
;     case 1:
;         DirectEncrypt(block);
;         break;
;     case 2:
;         CycleEncrypt(block);
;         break;
;     case 3:
;         NumberEncrypt(block);
;         break;
;     }
;     return true;
; }
;----------------------------------------------
global Encrypt
Encrypt:
section .text
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword[rbp-8], rdi
    mov rax, qword[rbp-8]
    mov eax, dword[rax]
    mov edi, dword[NUMBER_ENCRYPTION]
    cmp eax, edi
    je .switch3
    mov edi, dword[NUMBER_ENCRYPTION]
    cmp eax, edi
    jg .return
    mov edi, dword[DIRECT_ENCRYPTION]
    cmp eax, edi
    je .switch1
    mov edi, dword[CYCLE_ENCRYPTION]
    cmp eax, edi
    je .switch2
    jmp .return
.switch1:
    mov rax, qword[rbp-8]
    mov rdi, rax
    call DirectEncrypt
    jmp .return
.switch2:
    mov rax, qword[rbp-8]
    mov rdi, rax
    call CycleEncrypt
    jmp .return
.switch3:
    mov rax, qword[rbp-8]
    mov rdi, rax
    call NumberEncrypt
.return:
    mov eax, 1
    leave
    ret

;----------------------------------------------
; Сортировка контейнера с помощью сортировки Шелла
; bool SortContainer(Container *cont)
; {
;     for (int s = cont->size / 2; s > 0; s /= 2)
;     {
;         for (int i = s; i < cont->size; ++i)
;         {
;             for (int j = i - s; j >= 0 && func(cont->encryptions[j].text) > func(cont->encryptions[j + s].text); j -= s)
;             {
;                 Encryption temp = cont->encryptions[j];
;                 cont->encryptions[j] = cont->encryptions[j + s];
;                 cont->encryptions[j + s] = temp;
;             }
;         }
;     }
;     return true;
; }
;----------------------------------------------
global SortContainer
SortContainer:
section .text
    push    rbp
    mov     rbp, rsp
    push    rbx
    sub     rsp, 248
    mov     qword[rbp-248], rdi
    mov     rax, qword[rbp-248]
    mov     eax, dword[rax]
    mov     edx, eax
    shr     edx, 31
    add     eax, edx
    sar     eax, 1
    mov     dword[rbp-20], eax
    jmp     .for_cond1
.for_loop1:
    mov     eax, dword[rbp-20]
    mov     dword[rbp-24], eax
    jmp     .for_cond2
.for_loop2:
    mov     eax, dword[rbp-24]
    sub     eax, dword[rbp-20]
    mov     dword[rbp-28], eax
    jmp     .for_cond3
.for_loop3:
    mov     rdx, qword[rbp-248]
    mov     eax, dword[rbp-28]
    cdqe
    imul    rax, rax, 212
    add     rax, rdx
    mov     rcx, qword[rax+4]
    mov     rbx, qword[rax+12]
    mov     qword[rbp-240], rcx
    mov     qword[rbp-232], rbx
    mov     rcx, qword[rax+20]
    mov     rbx, qword[rax+28]
    mov     qword[rbp-224], rcx
    mov     qword[rbp-216], rbx
    mov     rcx, qword[rax+36]
    mov     rbx, qword[rax+44]
    mov     qword[rbp-208], rcx
    mov     qword[rbp-200], rbx
    mov     rcx, qword[rax+52]
    mov     rbx, qword[rax+60]
    mov     qword[rbp-192], rcx
    mov     qword[rbp-184], rbx
    mov     rcx, qword[rax+68]
    mov     rbx, qword[rax+76]
    mov     qword[rbp-176], rcx
    mov     qword[rbp-168], rbx
    mov     rcx, qword[rax+84]
    mov     rbx, qword[rax+92]
    mov     qword[rbp-160], rcx
    mov     qword[rbp-152], rbx
    mov     rcx, qword[rax+100]
    mov     rbx, qword[rax+108]
    mov     qword[rbp-144], rcx
    mov     qword[rbp-136], rbx
    mov     rcx, qword[rax+116]
    mov     rbx, qword[rax+124]
    mov     qword[rbp-128], rcx
    mov     qword[rbp-120], rbx
    mov     rcx, qword[rax+132]
    mov     rbx, qword[rax+140]
    mov     qword[rbp-112], rcx
    mov     qword[rbp-104], rbx
    mov     rcx, qword[rax+148]
    mov     rbx, qword[rax+156]
    mov     qword[rbp-96], rcx
    mov     qword[rbp-88], rbx
    mov     rcx, qword[rax+164]
    mov     rbx, qword[rax+172]
    mov     qword[rbp-80], rcx
    mov     qword[rbp-72], rbx
    mov     rcx, qword[rax+180]
    mov     rbx, qword[rax+188]
    mov     qword[rbp-64], rcx
    mov     qword[rbp-56], rbx
    mov     rcx, qword[rax+196]
    mov     rbx, qword[rax+204]
    mov     qword[rbp-48], rcx
    mov     qword[rbp-40], rbx
    mov     eax, dword[rax+212]
    mov     dword[rbp-32], eax
    mov     edx, dword[rbp-28]
    mov     eax, dword[rbp-20]
    add     edx, eax
    mov     rcx, qword[rbp-248]
    mov     eax, dword[rbp-28]
    cdqe
    imul    rax, rax, 212
    add     rax, rcx
    mov     rcx, qword[rbp-248]
    movsx   rdx, edx
    imul    rdx, rdx, 212
    add     rdx, rcx
    mov     rcx, qword[rdx+4]
    mov     rbx, qword[rdx+12]
    mov     qword[rax+4], rcx
    mov     qword[rax+12], rbx
    mov     rcx, qword[rdx+20]
    mov     rbx, qword[rdx+28]
    mov     qword[rax+20], rcx
    mov     qword[rax+28], rbx
    mov     rcx, qword[rdx+36]
    mov     rbx, qword[rdx+44]
    mov     qword[rax+36], rcx
    mov     qword[rax+44], rbx
    mov     rcx, qword[rdx+52]
    mov     rbx, qword[rdx+60]
    mov     qword[rax+52], rcx
    mov     qword[rax+60], rbx
    mov     rcx, qword[rdx+68]
    mov     rbx, qword[rdx+76]
    mov     qword[rax+68], rcx
    mov     qword[rax+76], rbx
    mov     rcx, qword[rdx+84]
    mov     rbx, qword[rdx+92]
    mov     qword[rax+84], rcx
    mov     qword[rax+92], rbx
    mov     rcx, qword[rdx+100]
    mov     rbx, qword[rdx+108]
    mov     qword[rax+100], rcx
    mov     qword[rax+108], rbx
    mov     rcx, qword[rdx+116]
    mov     rbx, qword[rdx+124]
    mov     qword[rax+116], rcx
    mov     qword[rax+124], rbx
    mov     rcx, qword[rdx+132]
    mov     rbx, qword[rdx+140]
    mov     qword[rax+132], rcx
    mov     qword[rax+140], rbx
    mov     rcx, qword[rdx+148]
    mov     rbx, qword[rdx+156]
    mov     qword[rax+148], rcx
    mov     qword[rax+156], rbx
    mov     rcx, qword[rdx+164]
    mov     rbx, qword[rdx+172]
    mov     qword[rax+164], rcx
    mov     qword[rax+172], rbx
    mov     rcx, qword[rdx+180]
    mov     rbx, qword[rdx+188]
    mov     qword[rax+180], rcx
    mov     qword[rax+188], rbx
    mov     rcx, qword[rdx+196]
    mov     rbx, qword[rdx+204]
    mov     qword[rax+196], rcx
    mov     qword[rax+204], rbx
    mov     edx, dword[rdx+212]
    mov     dword[rax+212], edx
    mov     edx, dword[rbp-28]
    mov     eax, dword[rbp-20]
    add     eax, edx
    mov     rdx, qword[rbp-248]
    cdqe
    imul    rax, rax, 212
    add     rax, rdx
    mov     rcx, qword[rbp-240]
    mov     rbx, qword[rbp-232]
    mov     qword[rax+4], rcx
    mov     qword[rax+12], rbx
    mov     rcx, qword[rbp-224]
    mov     rbx, qword[rbp-216]
    mov     qword[rax+20], rcx
    mov     qword[rax+28], rbx
    mov     rcx, qword[rbp-208]
    mov     rbx, qword[rbp-200]
    mov     qword[rax+36], rcx
    mov     qword[rax+44], rbx
    mov     rcx, qword[rbp-192]
    mov     rbx, qword[rbp-184]
    mov     qword[rax+52], rcx
    mov     qword[rax+60], rbx
    mov     rcx, qword[rbp-176]
    mov     rbx, qword[rbp-168]
    mov     qword[rax+68], rcx
    mov     qword[rax+76], rbx
    mov     rcx, qword[rbp-160]
    mov     rbx, qword[rbp-152]
    mov     qword[rax+84], rcx
    mov     qword[rax+92], rbx
    mov     rcx, qword[rbp-144]
    mov     rbx, qword[rbp-136]
    mov     qword[rax+100], rcx
    mov     qword[rax+108], rbx
    mov     rcx, qword[rbp-128]
    mov     rbx, qword[rbp-120]
    mov     qword[rax+116], rcx
    mov     qword[rax+124], rbx
    mov     rcx, qword[rbp-112]
    mov     rbx, qword[rbp-104]
    mov     qword[rax+132], rcx
    mov     qword[rax+140], rbx
    mov     rcx, qword[rbp-96]
    mov     rbx, qword[rbp-88]
    mov     qword[rax+148], rcx
    mov     qword[rax+156], rbx
    mov     rcx, qword[rbp-80]
    mov     rbx, qword[rbp-72]
    mov     qword[rax+164], rcx
    mov     qword[rax+172], rbx
    mov     rcx, qword[rbp-64]
    mov     rbx, qword[rbp-56]
    mov     qword[rax+180], rcx
    mov     qword[rax+188], rbx
    mov     rcx, qword[rbp-48]
    mov     rbx, qword[rbp-40]
    mov     qword[rax+196], rcx
    mov     qword[rax+204], rbx
    mov     edx, dword[rbp-32]
    mov     dword[rax+212], edx
    mov     eax, dword[rbp-20]
    sub     dword[rbp-28], eax
.for_cond3:
    cmp     dword[rbp-28], 0
    js      .loop_end
    mov     eax, dword[rbp-28]
    cdqe
    imul    rdx, rax, 212
    mov     rax, qword[rbp-248]
    add     rax, rdx
    add     rax, 16
    mov     rdi, rax
    call    func
    movq    rbx, xmm0
    mov     edx, dword[rbp-28]
    mov     eax, dword[rbp-20]
    add     eax, edx
    cdqe
    imul    rdx, rax, 212
    mov     rax, qword[rbp-248]
    add     rax, rdx
    add     rax, 16
    mov     rdi, rax
    call    func
    movq    xmm1, rbx
    comisd  xmm1, xmm0
    ja      .for_loop3
.loop_end:
    add     dword[rbp-24], 1
.for_cond2:
    mov     rax, qword[rbp-248]
    mov     eax, dword[rax]
    cmp     dword[rbp-24], eax
    jl      .for_loop2
    mov     eax, dword[rbp-20]
    mov     edx, eax
    shr     edx, 31
    add     eax, edx
    sar     eax, 1
    mov     dword[rbp-20], eax
.for_cond1:
    cmp     dword[rbp-20], 0
    jg      .for_loop1
    mov     eax, 1
    mov     rbx, qword[rbp-8]
    leave
    ret