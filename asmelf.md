Gathering all the ELF (Executable and Linkable Format) information using assembly language can be a complex task, as ELF files have a specific structure and the parsing requires understanding of this format. To get you started, I can provide a basic outline of an assembly program that reads an ELF file and extracts some basic information, such as the ELF header.

The ELF header contains important metadata about the file, including its type, architecture, entry point, and section headers. Below is an example in NASM (Netwide Assembler) syntax that reads an ELF file and prints the ELF header.

This example assumes your environment has utilities to read files and print to standard output. You will need to adapt the paths and error handling as necessary for your operating system.

### Example NASM code to Read an ELF Header

```nasm
section .data
    elf_magic db 0x7F, 'E', 'L', 'F'    ; ELF Magic Number
    filename db "yourfile.elf", 0
    elf_format db "ELF Header:\n"
    elf_type_format db "Type: %u\n"
    entry_point_format db "Entry point: 0x%08x\n"
    elf_class db 0x00
    elf_data db 0x00
    elf_type db 0x00
    elf_entry dw 0x00

section .bss
    buffer resb 64                      ; Allocate buffer for reading

section .text
    extern printf
    extern fopen
    extern fread
    extern fclose
    global _start

_start:
    ; Open the ELF file
    push filename
    call fopen
    add esp, 4
    
    ; Check if the file opened successfully
    test eax, eax
    jz .error
    
    ; Read the ELF header
    push 64                               ; Read 64 bytes (entire ELF Header)
    push eax                              ; FILE pointer
    push buffer                           ; Pointer to buffer
    call fread
    add esp, 12

    ; Check for errors
    cmp eax, 64                           ; Ensure we read 64 bytes
    jne .error

    ; Verify ELF Magic Number
    cmp byte [buffer], 0x7F
    jne .error
    cmp dword [buffer + 1], 0x464c457f  ; Check for 'ELF'

    ; Read ELF header info
    mov eax, [buffer + 16]                ; e_type
    mov [elf_type], eax
    mov eax, [buffer + 24]                ; e_entry
    mov [elf_entry], eax

    ; Print ELF Header
    push [elf_type]
    push elf_type_format
    call printf
    add esp, 8

    push [elf_entry]
    push entry_point_format
    call printf
    add esp, 8

    ; Close file
    push eax                              ; FILE pointer
    call fclose
    add esp, 4

    ; Exit Program
    mov eax, 1                            ; syscall: exit
    xor ebx, ebx                          ; exit code 0
    int 0x80

.error:
    ; Handle error case (file not found, not a valid ELF, etc.)
    ; For now, simply exit with code 1
    mov eax, 1                            ; syscall: exit
    mov ebx, 1                            ; exit code 1
    int 0x80
```

### Important Notes

1. **Assembly Language Specifics**: The example above uses the Intel format for NASM. Familiarize yourself with the syntax and conventions for the assembly language you are using.

2. **Syscall vs. libc calls**: The example shows mixed usage with `stdio` functions (`fopen`, `fread`, `fclose`) and a Linux syscall for exit. This may require linking with the appropriate C library.

3. **Error Handling**: Proper error handling is crucial; the above code is simplified for clarity. Ensure to handle errors in reading files properly.

4. **ELF Format Understanding**: Understanding the ELF file format is necessary to read different sections and headers accurately. Refer to the official ELF specification for more details.

5. **Testing**: Replace `"yourfile.elf"` with a valid ELF file path for testing. 

The provided code is a fundamental starting point; you will likely want to expand it significantly to extract more information from the ELF file, like the program header table, section headers, and so on.
