section .data
    message db 'Enjoy this repo!', 0xA  ; The message with a newline character
    message_length equ $ - message         ; Calculate the length of the message

section .text
    global _start

_start:
    ; Write the message to stdout
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, message    ; pointer to message
    mov rdx, message_length ; message length
    syscall             ; invoke operating system to do the write

    ; Exit the program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code: 0
    syscall             ; invoke operating system to exit
