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
    push rbp
    mov rbp, rsp

    mov [rsp + 40], rcx ; fn_ptr
    mov [rsp + 32], rdx ; argc
    mov [rsp + 24], r8 ; argv ptr
    mov [rsp + 16], r9 ; is_float ptr

    ; argv[0]
    mov r10, [rbp + 32] ; argc
    cmp r10, 1
    jl done ; jump if argc is 0

    mov r10, [rbp + 16] ; get is_float pointer
    movzx r11, byte ptr [r10] ; read is_float[0]

    mov r10, [rbp + 24]  ; get argv pointer

    cmp r11, 0
    je int_path_0 ; jump if is_float[0] is false

    movsd xmm0, qword ptr [r10] ; load argv[0] as float
    jmp done_0

    int_path_0:
        mov rcx, [r10] ; load argv[0] as int
        jmp done_0

    done_0:

    ; argv[1]
    mov r10, [rbp + 32]
    cmp r10, 2
    jl load_stackparams ; jump if argc is 1

    mov r10, [rbp + 16] ; get is_float pointer
    movzx r11, byte ptr [r10 + 1] ; read is_float[1]

    mov r10, [rbp + 24] ; get argv pointer

    cmp r11, 0
    je int_path_1 ; jump if is_float[1] is false

    movsd xmm1, qword ptr [r10 + 8] ; load argv[1] as float
    jmp done_1

    int_path_1:
        mov rdx, [r10 + 8] ; load argv[1] as int
        jmp done_1
    
    done_1:
    
    ; argv[2]
    mov r10, [rbp + 32]
    cmp r10, 3
    jl load_stackparams ; jump if argc is 2

    mov r10, [rbp + 16] ; get is_float pointer
    movzx r11, byte ptr [r10 + 2] ; read is_float[2]

    mov r10, [rbp + 24] ; get argv pointer

    cmp r11, 0
    je int_path_2 ; jump if is_float[2] is false

    movsd xmm2, qword ptr [r10 + 16] ; load argv[2] as float
    jmp done_2

    int_path_2:
        mov r8, [r10 + 16] ; load argv[2] as int
        jmp done_2

    done_2:

    ; argv[3]
    mov r10, [rbp + 32]
    cmp r10, 4
    jl load_stackparams ; jump if argc is 3

    mov r10, [rbp + 16] ; get is_float pointer
    movzx r11, byte ptr [r10 + 3] ; read is_float[3]

    mov r10, [rbp + 24] ; get argv pointer
    
    cmp r11, 0
    je int_path_3 ; jump if is_float[3] is false

    movsd xmm3, qword ptr [r10 + 24] ; load argv[3] as float
    jmp done_3

    int_path_3:
        mov r9, [r10 + 24] ; load argv[3] as int
        jmp done_3
        
    done_3:

    load_stackparams:
     ; todo: load stack params

    done:

    ; ABI guarantees rsp is 16n+8 on function entry
    ; subtracting 40 from that gives 16n-32 which is aligned

    sub rsp, 40
    call qword ptr [rbp + 40]
    add rsp, 40
    
    movzx r10, byte ptr [rbp + 48] ; is_float_return
    cmp r10, 0
    je return

    ; we use movq here to reinterpret cast
    movq rax, xmm0
    
    return:
    mov rsp, rbp
    pop rbp
    ret

asm_call ENDP

END