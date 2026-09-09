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
    ; we're pushing 4 values
    ; 32 (shadow space) + 32 (our sub) + 8 (return address) = 72
    ; we need one more byte to get to a 16 byte aligned number, 80
    ; so we sub 40 from rsp

    sub rsp, 40
    push rcx
    push rdx
    push r8
    push r9

    ; jump to done if arg count is less than 1
    cmp rdx, 1
    jl done

asm_call ENDP

    done:
        call ; fill in later, cant use rcx
        add rsp, 40
        ret

END