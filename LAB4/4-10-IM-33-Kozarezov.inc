; ======= MACROS =======

; Macro 1: Display message
KozarezovKyryl_ShowMessage MACRO textPtr, titlePtr
    invoke MessageBox, NULL, textPtr, titlePtr, MB_OK
ENDM

; Macro 2: XOR encryption
KozarezovKyryl_EncryptString MACRO inputPtr, keyPtr, outputPtr, length
    mov esi, inputPtr    
    mov edi, outputPtr   
    mov ebx, keyPtr      
    mov cx, length       
encrypt_loop:
    test cx, cx          
    jz done_encrypt    
    mov al, [esi]      ;; Xor encryption
    xor al, [ebx]        
    mov [edi], al        
    inc esi              
    inc ebx              
    inc edi              
    dec cx               
    jmp encrypt_loop   
done_encrypt:
ENDM

; Macro 3: Buffer comparison
KozarezovKyryl_CompareEncrypted MACRO buf1, buf2, length
    LOCAL @@loop, @@match, @@mismatch  ;; Label initialization
    ; Register setup
    mov esi, buf1        
    mov edi, buf2        
    mov cx, length       
@@loop:
    test cx, cx          
    jz @@match           
    mov al, [esi]        ; Byte comparison
    cmp al, [edi]        
    jne @@mismatch       
    inc esi              
    inc edi              
    dec cx               
    jmp @@loop           
@@match:
    call KozarezovKyryl_SuccessWindow  ;; Success handler
    ret
@@mismatch:
    call KozarezovKyryl_ErrorWindow    ;; Error handler
    ret
ENDM