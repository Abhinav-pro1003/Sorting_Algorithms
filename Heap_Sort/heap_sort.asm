section .data
    buffer db 20 dup(0)
    newline db 10     ; '\n'
    buff_len equ $ - buffer

section .text
    global input
    global heapify
    global swap
    global deleteMax
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

swap:
    push rbp
    push rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov rax, rdi
    mov rbx, rsi
    mov rcx, rdx

    imul rbx, 8
    imul rcx, 8
    add rbx, rax
    add rcx, rax
    mov r12, [rbx]
    mov r13, [rcx]
    mov [rbx], r13
    mov [rcx], r12

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rsp
    pop rbp

    ret

heapify:
    push rbp
    push rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov rax, rdi
    mov r15, rsi
    mov rbx, rdx
    mov rcx, rbx

    imul rcx, 8
    add rcx, rax
    mov r12, [rcx]

    mov rcx, rbx
    imul rcx, 2
    add rcx, 1
    cmp rcx, r15
    jge .no_left

    imul rcx, 8
    add rcx, rax
    mov r13, [rcx]
    mov rcx, rbx
    imul rcx, 2
    add rcx, 2
    cmp rcx, r15
    jge .swap_left

    imul rcx, 8
    add rcx, rax
    mov r14, [rcx]

    cmp r12, r14
    jge .swap_left

    cmp r12, r13
    jge .swap_right

    cmp r13, r14
    jge .swap_left

.swap_right:
    push rax 
    push rbx 
    push rcx
    push rdx 

    mov rcx, rbx
    imul rcx, 2
    add rcx, 2
    mov rdi, rax
    mov rsi, rbx
    mov rdx, rcx
    call swap

    pop rdx 
    pop rcx 
    pop rbx
    pop rax  

    push rax 
    push rbx 
    push rcx
    push rdx 

    mov rdi, rax
    mov rsi, r15
    mov rcx, rbx
    imul rcx, 2
    add rcx, 2
    mov rdx, rcx
    call heapify

    pop rdx 
    pop rcx 
    pop rbx
    pop rax 

    jmp .no_left

.swap_left:
    cmp r12, r13
    jge .no_left

    push rax 
    push rbx 
    push rcx
    push rdx 

    mov rcx, rbx
    imul rcx, 2
    add rcx, 1
    mov rdi, rax
    mov rsi, rbx
    mov rdx, rcx
    call swap

    pop rdx 
    pop rcx 
    pop rbx
    pop rax 

    push rax 
    push rbx 
    push rcx
    push rdx 

    mov rdi, rax
    mov rsi, r15
    mov rcx, rbx
    imul rcx, 2
    add rcx, 1
    mov rdx, rcx
    call heapify

    pop rdx 
    pop rcx 
    pop rbx
    pop rax 

.no_left:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rsp
    pop rbp

    ret

deleteMax:
    push rbp
    push rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov rax, rdi
    mov rbx, 0
    mov rcx, rsi
    sub rcx, 1
    cmp rbx, rcx
    je .equal

    push rbx
    push rcx
    push rax
    push rdx
    mov rdi, rax
    mov rsi, rbx
    mov rdx, rcx
    call swap
    pop rdx
    pop rax
    pop rcx
    pop rbx

    push rbx
    push rcx
    push rax
    push rdx
    mov rdi, rax
    mov rsi, rcx
    mov rbx, 0
    mov rdx, rbx
    call heapify
    pop rdx
    pop rax
    pop rcx
    pop rbx

.equal:
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
    ; mov rcx, 0
    ; mov [rsp+8], rcx
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

    mov rax, [rsp]
    sub rax, 1
    sub rsp, 8
    mov [rsp], rax

    .for4Begin:
        mov rax, [rsp]
        mov rbx, 0
        cmp rax, rbx
        jl .for4End

        ; call input
        ; mov rbx, [rsp]
        ; mov rcx, [rsp+16]
        ; imul rbx, 8
        ; add rcx, rbx
        ; mov [rcx], rax
        mov rdi, [rsp+16]
        mov rsi, [rsp+8]
        mov rdx, [rsp]
        call heapify

        mov rax, [rsp]
        sub rax, 1
        mov [rsp], rax
        jmp .for4Begin
    
    .for4End:
        add rsp, 8

    mov rdi, [rsp]
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

    sub rsp, 8
    mov [rsp], rbx
    
    sub rsp, 8
    mov rax, 0
    mov [rsp], rax

    .for2Begin:
        mov rax, [rsp]
        mov rbx, [rsp+16]
        cmp rax, rbx
        jge .for2End

        mov rdi, [rsp+24]
        mov rax, [rsp]
        mov rbx, [rsp+16]
        sub rbx, rax
        mov rsi, rbx
        mov rbx, 0
        mov rcx, [rsp+8]
        imul rbx, 8
        mov rax, [rsp+24]
        add rax, rbx
        mov rbx, [rsp]
        imul rbx, 8
        add rcx, rbx
        mov rbx, [rax]
        mov [rcx], rbx
        call deleteMax

        ; mov rbx, [rsp]
        ; imul rbx, 8
        ; mov rax, rbx
        ; add rbx, [rsp+8]
        ; add rax, [rsp+24]
        ; mov rcx, [rax]
        ; mov [rbx], rcx


        mov rax, [rsp]
        add rax, 1
        mov [rsp], rax
        jmp .for2Begin
    
    .for2End:
        add rsp, 8
        sub rsp, 8
        mov rax, 0
        mov [rsp], rax


.for3Begin:
; Write code to jump to for3End if i >= n

; rax = array[i]
; That is, rax = *(*(rsp + 16) + i*8)
    mov rax, [rsp]
    mov rbx, [rsp+16]
    cmp rax, rbx
    jge .for3End

    mov rcx, [rsp+8]
    mov rbx, [rsp]
    imul rbx, 8
    add rcx, rbx
    mov rax, [rcx] 
    mov rdi, buffer + 20  ; Point to end of buffer
    mov rbx, 10           ; Base 10 for division
    mov rcx, 0            ; Digit counter
    mov byte [rdi], ' '
    dec rdi
    inc rcx

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

    mov rax, [rsp]
    add rax, 1
    mov [rsp], rax
    jmp .for3Begin

.for3End:
    mov rax, 1        ; sys_write
    mov rdi, 1        ; stdout
    mov rsi, newline  ; address of newline
    mov rdx, 1        ; length = 1 byte
    syscall

    inc rdi               ; Move to start of the string
    mov rax, 1            ; Syscall number for write
    mov rsi, rdi          ; Pointer to string
    mov rdi, 1            ; File descriptor 1 (stdout)
    mov rdx, rcx          ; Length of string
    syscall

    mov rax, 12
    mov rdi, [rsp+8]
    syscall
    mov rax, 12
    mov rdi, [rsp+32]
    syscall
    add rsp, 40
    mov rax, 60
    xor rdi, rdi
    syscall
    