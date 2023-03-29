org 0x7C00   ; Set origin to 0x7C00 for boot sector

bits 16       ; Set code to 16-bit mode

section .text
    global _start

section .text
_start:
    ; set up stack pointer
    mov esp, stack_top

    ; print prompt
    mov eax, prompt
    call print_string

    ; read in any key
    call read_any_key

    ; infinite loop
    jmp $

print_string:
    ; prints a null-terminated string pointed to by eax
    pusha
    mov edx, eax
    mov ecx, 0
    while_loop:
        cmp byte [edx+ecx], 0
        je end_while
        mov al, [edx+ecx]
        call print_char
        inc ecx
        jmp while_loop
    end_while:
        popa
        ret

print_number:
    ; prints the 32-bit integer value in eax
    pusha
    cmp eax, 0
    jge positive
    neg eax
    mov al, '-'
    call print_char
    positive:
        mov ebx, 10
        xor ecx, ecx
        mov edx, 0
    digit_loop:
        div ebx
        push edx
        inc ecx
        cmp eax, 0
        jne digit_loop
    print_loop:
        pop edx
        add edx, '0'
        call print_char
        loop print_loop
    end_print_number:
        popa
        ret

print_char:
    ; prints the character in al
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    ret

read_char:
    ; reads in a character from the keyboard and returns it in al
    mov ah, 0x00
    int 0x16
    ret

read_any_key:
    ; reads in any key from the keyboard and prints it
    pusha
    read_loop:
        call read_char
        call print_char
        cmp al, 0x0d ; check for Enter key
        jne read_loop ; if not Enter, continue reading
    popa
    ret


section .data
    prompt db 'Enter a number: ', 0
    number dd 0

section .bss
    stack resb 1024
    stack_top:
