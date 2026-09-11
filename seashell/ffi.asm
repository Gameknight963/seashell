PUBLIC asm_call 

; First 4 integer arguments come in as: RCX, RDX, R8, R9
; Fisrt 4 float arguments: XMM0, XMM1, XMM2, XMM3

; calle-saved: RBX, RBP, RDI, RSI, R12-R15
; scratch: RAX (return value), R10, R11

; RCX is the pointer
; RDX is argc
; R8 is a pointer to the first element in argv
; R9 is a pointer to the first element in an array of whether the corresponding element of argv is a float or not


.code
asm_call PROC
    push rcx ; [rsp + 24]
    push rdx ; [rsp + 16]
    push r8 ; [rsp + 8]
    push r9 ; [rsp]

    ; jump to done if arg count is less than 1

    ; first item of argv
    mov r10, [rsp + 16] ; rsp + 16 is argc
    cmp r10, 1
    jl done ; jump if argc is 0
    mov r10, [rsp + 8]  ; get argv pointer
    mov rcx, [r10]      ; read argv[0]

    ; second item of argv
    mov r10, [rsp + 16]
    cmp r10, 2
    jl done ; jump if argc is 1
    mov r10, [rsp + 8] ; rsp + 8 is argv pointer
    mov rdx, [r10 + 8] ; argv item size is 64 bit
    
    ; third item of argv
    mov r10, [rsp + 16]
    cmp r10, 3
    jl done ; jump if argc is 2
    mov r10, [rsp + 8]
    mov r8, [r10 + 16]

    ; fourth item of argv
    mov r10, [rsp + 16]
    cmp r10, 4
    jl done ; jump if argc is 3
    mov r10, [rsp + 8]
    mov r9, [r10 + 24]

    done:
        ; we're pushing 4 values
        ; 32 (shadow space) + 32 (our locals) + 8 (return address) = 72
        ; we need one more byte to get to a 16 byte aligned number, 80
        ; so we sub 40 from rsp

        sub rsp, 40
        call qword ptr [rsp + 64] ; the function pointer was moved by the last line
        add rsp, 72 ; we need to back up 32 bytes for our locals
        ret

asm_call ENDP

END