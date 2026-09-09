PUBLIC asm_call_ptr

; First 4 integer arguments come in as: RCX, RDX, R8, R9
; calle-saved: RBX, RBP, RDI, RSI, R12-R15
; caller-saved (scratch): RAX, RCX, RDX, R8, R9, R10, R11

; asm_call_ptr movs a function pointer to RCX and
; an int to RDX

; double_it expects its argument in RCX

.code
asm_call_ptr PROC
	; stack alignment or something
	sub rsp, 40
	; mov the pointer to a scratch register so we don't overwrite it
	mov rax, rcx
	; mov the int to rcx so we can call the pointer
	mov rcx, rdx
	call rax
	add rsp, 40
	ret
asm_call_ptr ENDP

END