; test-strlen.asm - вычисление длины строки
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

    mov     rdi, msg
    call    strlen
    mov     [len], eax
    PrintStr    "msg length as C-strlen = ", [stdout]
    PrintInt    [len], [stdout]
    PrintStr    NL, [stdout]

    PrintStrBuf info, [stdout]
    PrintStrBuf emptyMsg, [stdout]
    PrintStr    NL, [stdout]

    mov     rdi, emptyMsg
    call    strlen0
    mov     [len], eax
    PrintStr    "emptyMsg length with zero symbol = ", [stdout]
    PrintInt    [len], [stdout]
    PrintStr    NL, [stdout]

    mov     rdi, emptyMsg
    call    strlen
    mov     [len], eax
    PrintStr    "emptyMsg length as C-strlen = ", [stdout]
    PrintInt    [len], [stdout]
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
    xor al, al      ; конечный симврл = 0
    cld             ; направление обхода от начала к концу
    repne   scasb   ; while(msg[rdi]) != al) {rdi++, rcx--}
    neg ecx
    sub ecx, 2      ; ecx = length(msg)
    mov eax, ecx
    ret
