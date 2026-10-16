section .data
    title db "MENU", 10
    title_len equ $ - title

    addition db "[A]dd", 10
    addition_len equ $ - addition

    subtract db "[S]ubtract", 10
    subtract_len equ $ - subtract

    multiply db "[M]ultiply", 10
    multiply_len equ $ - multiply

    divide db "[D]ivide", 10
    divide_len equ $ - divide

    choice db "Enter your choice: "
    choice_len equ $ - choice

    num1 db "Enter first number: "
    num1_len equ $ - num1

    num2 db "Enter second number: "
    num2_len equ $ - num2

    res_add db "The sum is "
    res_add_len equ $ - res_add

    res_sub db "The difference is "
    res_sub_len equ $ - res_sub

    res_div db "The quotient is "
    res_div_len equ $ - res_div

    res_prod db "The product is "
    res_prod_len equ $ - res_prod

    invalid db "INVALID CHOICE", 10
    invalid_len equ $ - invalid

    try db "Do you want to try again (Y/N): "
    try_len equ $ - try

    minus db "-"

    clear db 10, 10, 10, 10, 10
    clear_len equ $ - clear

section .bss
    c resb 10
    n1 resb 10
    n2 resb 10
    t resb 10
    r resb 12

    n1_val resd 1
    n2_val resd 1

section .text
    global _start

_start:
main:
    call printMenu
    call getChoice
    call getNumbers
    call compare
    call askAgain

    mov al, [t]
    cmp al, 'Y'
    je doClear
    cmp al, 'y'
    je doClear

    mov eax, 1
    xor ebx, ebx
    int 0x80

doClear:
    call clearScreen
    jmp main

printMenu:
    mov ecx, title
    mov edx, title_len
    call printString

    mov ecx, addition
    mov edx, addition_len
    call printString

    mov ecx, subtract
    mov edx, subtract_len
    call printString

    mov ecx, multiply
    mov edx, multiply_len
    call printString

    mov ecx, divide
    mov edx, divide_len
    call printString

    ret

compare:
    mov al, [c]

    cmp al, 'A'
    je doAdd
    cmp al, 'a'
    je doAdd
    
    cmp al, 'S'
    je doSub
    cmp al, 's'
    je doSub

    cmp al, 'M'
    je doMul
    cmp al, 'm'
    je doMul

    cmp al, 'D'
    je doDiv
    cmp al, 'd'
    je doDiv

    mov ecx, invalid
    mov edx, invalid_len
    call printString
    ret

getChoice:
    mov ecx, choice
    mov edx, choice_len
    call printString

    mov ecx, c
    mov edx, 10
    call readString

    ret

getNumbers:
    mov ecx, num1
    mov edx, num1_len
    call printString
    mov ecx, n1
    mov edx, 10
    call readString
    mov al, [n1]
    sub al, '0'
    movzx eax, al
    mov [n1_val], eax

    mov ecx, num2
    mov edx, num2_len
    call printString
    mov ecx, n2
    mov edx, 10
    call readString
    mov al, [n2]
    sub al, '0'
    movzx eax, al
    mov [n2_val], eax

    ret

getDigits:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [esi], dl
    dec esi
    cmp eax, 0
    jne getDigits
    jmp display

clearScreen:
    mov ecx, clear
    mov edx, clear_len
    call printString
    ret

doAdd:
    mov ecx, res_add
    mov edx, res_add_len
    call printString

    mov eax, [n1_val]
    mov ebx, [n2_val]
    add eax, ebx
    call printNum

    ret

doSub:
    mov ecx, res_sub
    mov edx, res_sub_len
    call printString

    mov eax, [n1_val]
    mov ebx, [n2_val]
    sub eax, ebx
    call printNum

    ret

doMul:
    mov ecx, res_prod
    mov edx, res_prod_len
    call printString

    mov eax, [n1_val]
    mov ebx, [n2_val]
    imul eax, ebx
    call printNum
    
    ret

doDiv:
    mov ecx, res_div
    mov edx, res_div_len
    call printString

    mov eax, [n1_val]
    xor edx, edx
    mov ebx, [n2_val]
    div ebx
    call printNum

    ret

askAgain:
    mov ecx, try
    mov edx, try_len
    call printString

    mov ecx, t
    mov edx, 10
    call readString

    ret

printNum:
    cmp eax, 0
    jge positive
    mov edi, eax
    mov ecx, minus
    mov edx, 1
    call printString
    mov eax, edi
    neg eax

positive:
    mov esi, r + 11
    mov byte [esi], 10
    dec esi
    
    cmp eax, 0
    jne convert
    mov byte [esi], '0'
    dec esi
    jmp display

convert:
    mov ebx, 10
    jmp getDigits

display:
    inc esi
    mov edx, r + 12
    sub edx, esi
    mov ecx, esi
    call printString
    ret

printString:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

readString:
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret