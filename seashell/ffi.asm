PUBLIC asm_add
PUBLIC asm_call_double
EXTERN double_it:PROC

; First 4 integer arguments come in as: RCX, RDX, R8, R9

.code
asm_add PROC
    add rcx, rdx
    mov rax, rcx
    ret
asm_add ENDP

asm_call_double PROC
    sub rsp, 48
    ; double_it takes 1 argument
    ; since we have the same signature
    ; we can just leave the caller's rcx
    call double_it
    ; rax alreay has the value we want, leave it
    add rsp, 48
    ret
asm_call_double ENDP

END