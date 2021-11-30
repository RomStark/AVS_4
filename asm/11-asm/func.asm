;------------------------------------------------------------------------------
; func.asm - единица компиляции, вбирающая функцию для численного сравнения строк
;------------------------------------------------------------------------------

;-------------------------------
; Функция для численного сравнения строк
; double func(char *text)
; {
;     double sum = 0;
;     int i = 0;
;     while (text[i])
;     {
;         sum += text[i];
;         i++;
;     }
;     return sum / (i + 1);
; }
;-------------------------------
global func
func:
    push rbp
    mov rbp, rsp
    mov qword[rbp - 24], rdi
    pxor xmm0, xmm0
    movsd qword[rbp - 8], xmm0
    mov dword[rbp - 12], 0
    jmp .L8
.L9:
    mov eax, dword[rbp - 12]
    movsx rdx, eax
    mov rax, qword[rbp - 24]
    add rax, rdx
    movzx eax, byte[rax]
    movsx eax, al
    pxor xmm0, xmm0
    cvtsi2sd xmm0, eax
    movsd xmm1, qword[rbp - 8]
    addsd xmm0, xmm1
    movsd qword[rbp - 8], xmm0
    add dword[rbp - 12], 1
.L8:
    mov eax, dword[rbp - 12]
    movsx rdx, eax
    mov rax, qword[rbp - 24]
    add rax, rdx
    movzx eax, byte[rax]
    test al, al
    jne .L9
    mov eax, dword[rbp - 12]
    add eax, 1
    pxor xmm1, xmm1
    cvtsi2sd xmm1, eax
    movsd xmm0, qword[rbp - 8]
    divsd xmm0, xmm1
    movq rax, xmm0
    movq xmm0, rax
    pop rbp
    ret