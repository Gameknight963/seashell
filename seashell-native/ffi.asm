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
    mov [rsp + 32], rcx ; fn_ptr
    mov [rsp + 24], rdx ; argc
    mov [rsp + 16], r8 ; argv ptr
    mov [rsp + 8], r9 ; is_float ptr

    ; push rcx ; [rsp + 24]
    ; push rdx ; [rsp + 16]
    ; push r8 ; [rsp + 8]
    ; push r9 ; [rsp]

    ; first item of argv
    mov r10, [rsp + 24] ; argc
    cmp r10, 1
    jl done ; jump if argc is 0

    mov r10, [rsp + 8] ; get is_float pointer
    movzx r11, byte ptr [r10] ; read is_float[0]

    mov r10, [rsp + 16]  ; get argv pointer

    cmp r11, 0
    je int_path_0 ; jump if is_float[0] is false

    movsd xmm0, qword ptr [r10] ; load argv[0] as float
    jmp done_0

    int_path_0:
        mov rcx, [r10] ; load argv[0] as int
        jmp done_0

    done_0:

    ; second item of argv
    mov r10, [rsp + 24]
    cmp r10, 2
    jl done ; jump if argc is 1

    mov r10, [rsp + 8] ; get is_float pointer
    movzx r11, byte ptr [r10 + 1] ; read is_float[1]

    mov r10, [rsp + 16] ; get argv pointer

    cmp r11, 0
    je int_path_1 ; jump if is_float[1] is false

    movsd xmm1, qword ptr [r10 + 8] ; load argv[1] as float
    jmp done_1

    int_path_1:
        mov rdx, [r10 + 8] ; load argv[1] as int
        jmp done_1
    
    done_1:
    
    ; third item of argv
    mov r10, [rsp + 24]
    cmp r10, 3
    jl done ; jump if argc is 2

    mov r10, [rsp + 8] ; get is_float pointer
    movzx r11, byte ptr [r10 + 2] ; read is_float[2]

    mov r10, [rsp + 16] ; get argv pointer

    cmp r11, 0
    je int_path_2 ; jump if is_float[2] is false

    movsd xmm2, qword ptr [r10 + 16] ; load argv[2] as float
    jmp done_2

    int_path_2:
        mov r8, [r10 + 16] ; load argv[2] as int
        jmp done_2

    done_2:

    ; fourth item of argv
    mov r10, [rsp + 24]
    cmp r10, 4
    jl done ; jump if argc is 3

    mov r10, [rsp + 8] ; get is_float pointer
    movzx r11, byte ptr [r10 + 3] ; read is_float[3]

    mov r10, [rsp + 16] ; get argv pointer
    
    cmp r11, 0
    je int_path_3 ; jump if is_float[3] is false

    movsd xmm3, qword ptr [r10 + 24] ; load argv[3] as float
    jmp done_3

    int_path_3:
        mov r9, [r10 + 24] ; load argv[3] as int
        jmp done_3
        
    done_3:

    done:

    ; we have no locals
    ; ABI guarantees rsp is 16n+8 on function entry
    ; subtracting 40 from that gives 16n-32 which is aligned

    sub rsp, 40
    call qword ptr [rsp + 72]
    add rsp, 40

    ; pushed by caller:
    ; [rsp + 40] = is_float_return
    
    movzx r10, byte ptr [rsp + 40] ; is_float_return
    cmp r10, 0
    je return

    movq rax, xmm0
    
    return:
    ret

asm_call ENDP

END