section .data
    buffer db 20 dup(0)
    buff_len equ $ - buffer

section .text
    global input
    global binary_search
    global _start

input:
    push rbp
    push rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov rax,0
    mov rdi,0
    mov rsi,buffer
    mov rdx,buff_len
    syscall

    mov rsi, buffer
    xor rax, rax

    .convert1:
    movzx rcx, byte [rsi]
    cmp rcx, 10
    je .done1
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .convert1

    .done1:

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rsp
    pop rbp

    ret


_start:
    call input

    mov rdi, rax
    mov rax, rdi
    mov rcx, rax
    push rbx
    push rcx
    mov rax, 12
    mov rdi, 0
    syscall
    pop rcx
    pop rbx

    mov rdi, rax
    mov rbx, rcx
    imul rbx, 8
    add rdi, rbx
    mov rbx, rax
    push rbx
    push rcx
    mov rax, 12
    syscall
    pop rcx
    pop rbx

    sub rsp, 16
    mov [rsp], rcx
    mov [rsp+8], rbx

    sub rsp, 8
    mov rax, 0
    mov [rsp], rax

    .for1Begin:
        mov rax, [rsp]
        mov rbx, [rsp+8]
        cmp rax, rbx
        jge .for1End

        call input
        mov rbx, [rsp]
        mov rcx, [rsp+16]
        imul rbx, 8
        add rcx, rbx
        mov [rcx], rax

        mov rax, [rsp]
        add rax, 1
        mov [rsp], rax
        jmp .for1Begin
    
    .for1End:
        add rsp, 8

    call input

    sub rsp, 16
    mov rbx, 0
    mov [rsp], rax
    mov [rsp+8], rbx
    mov rbx, [rsp+16]
    sub rbx, 1
    mov [rsp+16], rbx 

    .while:
        mov r13, [rsp]
        mov rcx, [rsp+8]
        mov rbx, [rsp+16]

        cmp rcx, rbx
        jg .while_end

        mov rax, rbx
        sub rax, [rsp+8]
        xor rdx, rdx
        mov rcx, 2
        div rcx
        add rax, [rsp+8]

        mov r15, [rsp+24]
        mov r14, rax
        imul r14, 8
        add r15, r14
        mov r14, [r15]

        cmp r14, [rsp]
        je .while_end

        cmp r14, r13
        jl .while_less

    .while_greater:
        sub rax, 1
        mov [rsp+16], rax
        mov rax, -1
        jmp .while
    
    .while_less:
        add rax, 1
        mov [rsp+8], rax
        mov rax, -1
        jmp .while

    
    .while_end:

    mov rdi, buffer + 20  ; Point to end of buffer
    mov rbx, 10           ; Base 10 for division
    mov rcx, 0            ; Digit counter

    ; Check if the number is negative
    cmp rax, 0         ; Test if rax is negative
    jge .not_negative     ; If not negative, skip to conversion
    neg rax               ; Negate to get absolute value
    .convert_loop:
        xor rdx, rdx          ; Clear rdx for division
        div rbx               ; Divide rax by 10, quotient in rax, remainder in rdx
        add rdx, '0'          ; Convert remainder to ASCII
        mov [rdi], dl         ; Store ASCII digit in buffer
        dec rdi               ; Move buffer pointer left
        inc rcx               ; Increment digit counter
        test rax, rax         ; Check if quotient is zero
        jnz .convert_loop     ; If not zero, continue loop
    mov byte [rdi], '-'  ; Store '-' at the beginning
    dec rdi               ; Move buffer pointer to store digits
    inc rcx 
    jmp .print

.not_negative:
    xor rdx, rdx          ; Clear rdx for division
    div rbx               ; Divide rax by 10, quotient in rax, remainder in rdx
    add rdx, '0'          ; Convert remainder to ASCII
    mov [rdi], dl         ; Store ASCII digit in buffer
    dec rdi               ; Move buffer pointer left
    inc rcx               ; Increment digit counter
    test rax, rax         ; Check if quotient is zero
    jnz .not_negative    ; If not zero, continue loop

.print:
    ; Prepare for syscall to print
    inc rdi               ; Move to start of the string
    mov rax, 1            ; Syscall number for write
    mov rsi, rdi          ; Pointer to string
    mov rdi, 1            ; File descriptor 1 (stdout)
    mov rdx, rcx          ; Length of string
    syscall

    add rsp, 16
    add rsp, 8
    mov rax, 12
    mov rdi, [rsp+8]
    syscall
    add rsp, 16
    mov rax, 60
    xor rdi, rdi
    syscall
    