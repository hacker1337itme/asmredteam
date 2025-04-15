To create an assembly program that checks for a file, executes a specific action if the file exists (for example, removing it), we typically need to work with operating system APIs. Below, I'll provide an example using x86 Assembly language that runs on a Windows system. This example will check for a file and then attempt to delete it if it exists.

### Example

The following code will use Windows API calls to check for the existence of a file and delete it if it exists. This should be assembled with an assembler like NASM and linked with a suitable linker that can work with Windows API calls.

```assembly
section .data
    filename db "C:\path\to\your\filelog.txt", 0 ; Change the file path accordingly
    deleteFileResult db 0

section .text
    global _start

_start:
    ; Check if the file exists
    invoke FindFirstFileA, filename, FileData
    ; If the file is found (success)
    cmp eax, INVALID_HANDLE_VALUE ; Check if it failed
    je .file_not_found

    ; File exists, now delete it
    invoke DeleteFileA, filename
    mov deleteFileResult, eax ; Store the result
    invoke FindClose, eax ; Close the find handle
    jmp .done

.file_not_found:
    ; Handle the case where the file was not found
    ; You may want to set a return code or log this event

.done:
    invoke ExitProcess, 0 ; Exit the program

section .data
FileData FILE_DATA_INFO
```

### Important Notes
1. **File Path**: Modify the `filename` variable to point to the correct file you wish to check and delete.

2. **Linking with Windows APIs**: You will require the Windows libraries when linking, so ensure you link against `Kernel32.lib` which provides access to the API functions used.

3. **Error Handling**: The example code does not have comprehensive error handling for simplicity. In a real-world application, you should check the results of each API call and handle errors appropriately.

4. **Assembly and Linking**: You may need to install an assembler like NASM and a linker (like GoLink or the MSVC linker) to assemble and link your code. 

5. **Permissions**: Make sure you run the executable with sufficient permissions to access and delete the specified file.

### Assembling and Running the Code
To assemble and link the code with NASM and a linker:
```bash
nasm -f win32 yourfile.asm -o yourfile.obj
GoLink yourfile.obj kernel32.dll
```

Adjust the command for your environment as necessary. 

Please test this code in a safe environment, as file deletion is irreversible.
