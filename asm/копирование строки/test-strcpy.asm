; test-strcpy.asm - копирование строк
%include "macros.mac"

section .data
    NL          equ     10

    msg         db      "Hello World!", 10,0
    info        db      "Message: ",0
    emptyMsg    db      0
    fDecimal    db      "%d",10,0
    len         dd      0

section .bss
    strBuf      resb    256

section .text
    global main
;----------------------------------------------
main:
    push    rbp
    mov     rbp,rsp

    PrintStrBuf info, [stdout]
    PrintStrBuf msg, [stdout]

    mov     rdi, msg
    call    strlen0
    mov     [len], eax
    PrintStr    "msg length with zero symbol = ", [stdout]
    PrintInt    [len], [stdout]
    PrintStr    NL, [stdout]

    mov     rdi, info
    call    strlen0
    mov     [len], eax
    PrintStr    "msg length with zero symbol = ", [stdout]
    PrintInt    [len], [stdout]
    PrintStr    NL, [stdout]

    mov     rdi, strBuf
    mov     rsi, msg
    call    strcpy
    mov     [len], eax
    PrintStr    "strcpy: strBuf = ", [stdout]
    PrintStrBuf strBuf, [stdout]
    PrintStr    "strBuf len = ", [stdout]
    PrintInt [len], [stdout]
    PrintStr    NL, [stdout]

    mov     rdi, strBuf
    mov     rsi, info
    call    strcpy2
    mov     [len], eax
    PrintStr    "strcpy2: strBuf = ", [stdout]
    PrintStrBuf strBuf, [stdout]
    PrintStr    NL, [stdout]
    PrintStr    "strBuf len = ", [stdout]
    PrintInt [len], [stdout]
    PrintStr    NL, [stdout]

    PrintStrLn "Bye!", [stdout]
    pop     rbp
    mov     rax,60
    mov     rdi,0
syscall

; FUNCTIONS =========================================================

;--------------------------------------------------------------------
; Вычисление длины строки с учетом конечного нулевого символа
strlen0:
    ; Адрес сообщения уже загружен в rdi
    mov ecx, -1     ; ecx должен быть < 0
    xor al, al      ; конечный символ = 0
    cld             ; направление обхода от начала к концу
    repne   scasb   ; while(msg[rdi]) != al) {rdi++, rcx--}
    neg ecx
    sub ecx, 1      ; ecx = length(msg)
    mov eax, ecx
    ret

;--------------------------------------------------------------------
; Вычисление длины строки как в языке C
strlen:
    ; Адрес сообщения уже загружен в rdi
    mov ecx, -1     ; ecx должен быть < 0
    xor al, al      ; конечный символ = 0
    cld             ; направление обхода от начала к концу
    repne   scasb   ; while(msg[rdi]) != al) {rdi++, rcx--}
    neg ecx
    sub ecx, 2      ; ecx = length(msg)
    mov eax, ecx
    ret

;--------------------------------------------------------------------
; Копирование строки как в языке C
strcpy:
    ; Адрес приемника уже загружен в rdi
    ; Адрес источника уже загружен в rsi
    cld             ; направление обхода от начала к концу
    xor al, al      ; конечный симвло = 0
    xor ecx, ecx    ; счетчик символов = 0
.loopstrcpy:
    cmp al, [rsi]
    je .endloopstrcpy
    movsb           ; dst[] = src
    inc ecx         ; ecx++
    jmp .loopstrcpy
.endloopstrcpy:
    mov [edi], al
    mov eax, ecx
    inc eax
    ret

;--------------------------------------------------------------------
; Копирование строки с использованием strlen0 и rep
strcpy2:
    ; Адрес приемника уже загружен в rdi
    mov r10, rdi    ; перенос во временное хранилище
    ; Адрес источника уже загружен в rsi
    mov r11, rsi    ; перенос во временное хранилище

    mov rdi, rsi
    call strlen0    ; вычисление длины строки с нулем

    mov ecx, eax
    mov rdi, r10
    mov rsi, r11
    cld             ; направление обхода от начала к концу
    rep movsb
    ret
