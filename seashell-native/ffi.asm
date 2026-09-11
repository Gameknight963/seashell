PUBLIC asm_call 

; First 4 integer arguments come in as: RCX, RDX, R8, R9
; Fisrt 4 float arguments: XMM0, XMM1, XMM2, XMM3

; calle-saved: RBX, RBP, RDI, RSI, R12-R15
; scratch: RAX (return value), R10, R11

; RCX is the pointer
; RDX is argc
; R8 is a pointer to the first element in argv
; R9 is a pointer to the first element in an array of whether the corresponding element of argv is a float or not

; movsd - move scalar double (64bit)
; movss - move scalar single (32bit)
; movzx - move with zero extend (mov to lower bytes, clear upper ones)

.code
asm_call PROC
    push rcx ; [rsp + 24]
    push rdx ; [rsp + 16]
    push r8 ; [rsp + 8]
    push r9 ; [rsp]

    ; first item of argv
    mov r10, [rsp + 16] ; rsp + 16 is argc
    cmp r10, 1
    jl done ; jump if argc is 0

    mov r10, [rsp] ; get is_float pointer
    movzx r11, byte ptr [r10] ; read is_float[0]

    mov r10, [rsp + 8]  ; get argv pointer

    cmp r11, 0
    je int_path_0 ; jump if is_float[0] is false

    movsd xmm0, qword ptr [r10] ; load argv[0] as float
    jmp done_0

    int_path_0:
        mov rcx, [r10] ; load argv[0] as int
        jmp done_0

    done_0:

    ; second item of argv
    mov r10, [rsp + 16]
    cmp r10, 2
    jl done ; jump if argc is 1

    mov r10, [rsp] ; get is_float pointer
    movzx r11, byte ptr [r10 + 1] ; read is_float[1]

    mov r10, [rsp + 8] ; get argv pointer

    cmp r11, 0
    je int_path_1 ; jump if is_float[1] is false

    movsd xmm1, qword ptr [r10 + 8] ; load argv[1] as float
    jmp done_1

    int_path_1:
        mov rdx, [r10 + 8] ; load argv[1] as int
        jmp done_1
    
    done_1:
    
    ; third item of argv
    mov r10, [rsp + 16]
    cmp r10, 3
    jl done ; jump if argc is 2

    mov r10, [rsp] ; get is_float pointer
    movzx r11, byte ptr [r10 + 2] ; read is_float[2]

    mov r10, [rsp + 8] ; get argv pointer

    cmp r11, 0
    je int_path_2 ; jump if is_float[2] is false

    movsd xmm2, qword ptr [r10 + 16] ; load argv[2] as float
    jmp done_2

    int_path_2:
        mov r8, [r10 + 16] ; load argv[2] as int
        jmp done_2

    done_2:

    ; fourth item of argv
    mov r10, [rsp + 16]
    cmp r10, 4
    jl done ; jump if argc is 3

    mov r10, [rsp] ; get is_float pointer
    movzx r11, byte ptr [r10 + 3] ; read is_float[3]

    mov r10, [rsp + 8] ; get argv pointer
    
    cmp r11, 0
    je int_path_3 ; jump if is_float[3] is false

    movsd xmm3, qword ptr [r10 + 24] ; load argv[3] as float
    jmp done_3

    int_path_3:
        mov r9, [r10 + 24] ; load argv[3] as int
        jmp done_3
        
    done_3:

    done:

    ; we're pushing 4 values
    ; 32 (shadow space) + 32 (our locals) + 8 (return address) = 72
    ; we need one more byte to get to a 16 byte aligned number, 80
    ; so we sub 40 from rsp

    sub rsp, 40
    call qword ptr [rsp + 64] ; the function pointer was moved by the last line
    add rsp, 72 ; we need to back up 32 more bytes due to our locals

    ; pushed by caller:
    ; [rsp + 8] = is_float_return
    ; [rsp] = return address
    
    movzx r10, byte ptr [rsp + 8] ; is_float_return
    cmp r10, 0
    je return

    movq rax, xmm0
    
    return:
    ret

asm_call ENDP

END