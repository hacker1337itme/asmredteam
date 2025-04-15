To check if a file exists in Linux using assembly language, you can use the `open` system call to attempt to open the file. If the file exists, `open` will return a file descriptor (a non-negative integer). If it doesn't exist, it will return `-1`. 

Below is a simple assembly program that loops and checks if a specified file exists. This example uses NASM syntax (Netwide Assembler):

```asm
section .data
    filename db 'testfile.txt', 0  ; File name to check
    msg_exists db 'File exists', 10 ; Message for file exists
    msg_not_exists db 'File does not exist', 10 ; Message for file does not exist

section .bss
    fd resb 1                       ; File Descriptor storage

section .text
global _start

_start:
    ; Attempt to open the file
    mov rax, 2             ; syscall: sys_open
    mov rdi, filename      ; pointer to the file name
    mov rsi, 0             ; flags: O_RDONLY
    syscall

    ; Check if the file descriptor is -1 (error)
    cmp rax, -1
    je file_not_exists      ; If it is -1, file does not exist

file_exists:
    ; Print "File exists"
    ; Write the message to stdout
    mov rax, 1             ; syscall: sys_write
    mov rdi, 1             ; file descriptor: stdout
    mov rsi, msg_exists    ; pointer to the message
    mov rdx, 14            ; message length
    syscall
    jmp exit               ; Exit

file_not_exists:
    ; Print "File does not exist"
    mov rax, 1             ; syscall: sys_write
    mov rdi, 1             ; file descriptor: stdout
    mov rsi, msg_not_exists; pointer to the message
    mov rdx, 24            ; message length
    syscall

exit:
    ; Exit the program
    mov rax, 60            ; syscall: sys_exit
    xor rdi, rdi           ; exit code 0
    syscall
```

### How to Assemble and Run

1. **Assemble** the code using NASM:
   ```sh
   nasm -f elf64 -o check_file.o check_file.asm
   ```

2. **Link** the object file:
   ```sh
   ld -o check_file check_file.o
   ```

3. **Run** the executable:
   ```sh
   ./check_file
   ```

### Notes:
- In the code above, we attempt to open the file named `testfile.txt`. You can modify the `filename` variable to check for a different file.
- The output will indicate whether the file exists or not.
- This example uses Linux 64-bit system calls, so ensure you're on a compatible system and use the correct assembler and linker.
