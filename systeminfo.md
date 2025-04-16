The warning you encountered suggests you declared an uninitialized variable in the `.data` section, which is meant for initialized data. To fix this, we should declare all uninitialized variables in the `.bss` section, which is specifically designed for that purpose.

Here’s a corrected version of the code for retrieving and printing the hostname using the `uname` syscall and properly managing sections:

### Revised Assembly Code

This version correctly uses the `.bss` section for uninitialized space:

```nasm
section .data
    sysinfo_str db 'System Info:', 10, 0   ; String to print with line feed
    buf_size equ 65                          ; Size of the uname structure

section .bss
    uname_buf resb buf_size                  ; Buffer for uname structure
    hostname  resb 256                       ; Buffer for hostname

section .text
    global _start

_start:
    ; Call uname syscall
    mov eax, 122                             ; syscall number for uname (x86_64)
    lea rdi, [uname_buf]                     ; pointer to the uname structure
    syscall                                   ; call kernel (for x86_64, use syscall)

    ; Copy the hostname from uname structure (offset 16)
    lea rsi, [uname_buf + 16]                ; Address of the hostname in uname_buf
    lea rdi, [hostname]                       ; Destination for hostname
    mov rcx, 256                              ; Maximum length to copy
    call copy_string                          ; Call the function to copy the hostname

    ; Print "System Info:"
    mov rax, 1                                ; syscall: sys_write
    mov rdi, 1                                ; file descriptor: stdout
    lea rsi, [sysinfo_str]                   ; pointer to the string
    mov rdx, 14                               ; length of the string
    syscall                                   ; call kernel

    ; Print hostname
    mov rax, 1                                ; syscall: sys_write
    mov rdi, 1                                ; file descriptor: stdout
    lea rsi, [hostname]                       ; pointer to the hostname
    mov rdx, 256                              ; Length of hostname
    syscall                                   ; call kernel

    ; Exit the program
    mov rax, 60                               ; syscall: sys_exit
    xor rdi, rdi                              ; exit code 0
    syscall                                   ; call kernel

; Function: Copy string
; Arguments:
;   rsi - pointer to the source string
;   rdi - pointer to the destination buffer
;   rcx - length of the string to copy
copy_string:
    cld                                        ; Clear direction flag
    rep movsb                                  ; Copy string byte by byte
    ret
```

### Key Changes and Improvements

1. **Using the `.bss` Section**: 
   - The `uname_buf` and `hostname` are declared in the `.bss` section where uninitialized buffers are reserved.

2. **x86_64 ABI**:
   - This code is intended to be assembled for an x86_64 (64-bit) architecture. Make sure to use the correct syscall convention, which requires the first argument in `rdi`, the second in `rsi`, the third in `rdx`, and the syscall number in `rax`.

3. **Appending the Correct Sizes**: 
   - The hostname is copied from the `uname_buf` to the `hostname` buffer. We reserved 256 bytes for the hostname to be safe.

4. **Print Statements**:
   - The print commands use the `sys_write` syscall for output.

### Assembling and Running

To compile and execute this code, follow the same steps:

1. Save the code as `system_info.asm`.
2. Assemble the code:
   ```bash
   nasm -f elf64 system_info.asm -o system_info.o
   ```
3. Link the object file:
   ```bash
   ld system_info.o -o system_info
   ```
4. Run the program:
   ```bash
   ./system_info
   ```

### Expected Output

When executed, this program should print:
```
System Info:
<current_hostname>
```
# Notice 
You Need Trace uname and c libs then can find the point of uname hostname 

Make sure to run this on a Linux system, as both the `uname` syscall and the syscall interface are specific to Linux. If you encounter any issues during compilation or execution, please share the error messages for further assistance.
