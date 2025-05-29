.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\dialogs.inc 
include \masm32\include\masm32rt.inc 

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
    mov al, [esi]  ;; Xor encryption
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

.data
    KozarezovKyryl_MessageBoxHeader       db "Вхід до системи",0
    KozarezovKyryl_PIB_Message            db "ПІБ: Козарезов Кирил Олександрович",0
    KozarezovKyryl_BirthDate_Message      db "Дата народження: 11.11.2005",0
    KozarezovKyryl_BookNumber_Message     db "Номер залікової книжки: 5001",0
    KozarezovKyryl_MessageBoxGreetingMessage db "Вітаю! Для відображення інформації про студента введіть пароль:",0
    KozarezovKyryl_MessageBoxErrorMessage  db "Пароль неправильний",0
    KozarezovKyryl_MessageBoxExitMessage   db "До зустрічі!",0
    KozarezovKyryl_Password                db "c/B#IH",0          
    KozarezovKyryl_Key                     db "!@!@!!",0      
    KozarezovKyryl_PasswordLength          dw 6

.data?
    KozarezovKyryl_PasswordInputField db 64 dup (?)         
    KozarezovKyryl_EncryptedInput     db 64 dup (?)              

.code

KozarezovKyryl_SuccessWindow proc
    KozarezovKyryl_ShowMessage offset KozarezovKyryl_PIB_Message, offset KozarezovKyryl_MessageBoxHeader
    KozarezovKyryl_ShowMessage offset KozarezovKyryl_BirthDate_Message, offset KozarezovKyryl_MessageBoxHeader
    KozarezovKyryl_ShowMessage offset KozarezovKyryl_BookNumber_Message, offset KozarezovKyryl_MessageBoxHeader
    invoke ExitProcess, NULL
KozarezovKyryl_SuccessWindow endp

KozarezovKyryl_ErrorWindow proc
    KozarezovKyryl_ShowMessage offset KozarezovKyryl_MessageBoxErrorMessage, offset KozarezovKyryl_MessageBoxHeader
    invoke ExitProcess, NULL
KozarezovKyryl_ErrorWindow endp

KozarezovKyryl_ExitWindow proc
    KozarezovKyryl_ShowMessage offset KozarezovKyryl_MessageBoxExitMessage, offset KozarezovKyryl_MessageBoxHeader
    invoke ExitProcess, NULL
KozarezovKyryl_ExitWindow endp

KozarezovKyryl_CheckPassword proc
    KozarezovKyryl_EncryptString offset KozarezovKyryl_PasswordInputField, offset KozarezovKyryl_Key, offset KozarezovKyryl_EncryptedInput, KozarezovKyryl_PasswordLength
    KozarezovKyryl_CompareEncrypted offset KozarezovKyryl_EncryptedInput, offset KozarezovKyryl_Password, KozarezovKyryl_PasswordLength
    ret
KozarezovKyryl_CheckPassword endp

KozarezovKyrylDialogHandler proc hWindow: dword, message: dword, wParam: dword, lParam: dword
    .if message == WM_CLOSE
        call KozarezovKyryl_ExitWindow
    .endif
	
    .if message == WM_COMMAND
        .if wParam == IDCANCEL
            call KozarezovKyryl_ExitWindow
        .endif

        .if wParam == IDOK
            invoke GetDlgItemText, hWindow, 1000, addr KozarezovKyryl_PasswordInputField, 64
            invoke lstrlen, addr KozarezovKyryl_PasswordInputField
            movzx ecx, KozarezovKyryl_PasswordLength
            cmp eax, ecx
            jne KozarezovKyryl_ErrorWindow
            call KozarezovKyryl_CheckPassword 
        .endif
    .endif
	
    mov eax, FALSE 
    ret
KozarezovKyrylDialogHandler endp

start:
    Dialog "Вхід до системи", "Times New Roman", 14,\
    WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, 4, 7, 7, 250, 200, 1024
        DlgStatic "Введіть пароль:", SS_CENTER, 75, 30, 150, 10, 100
        DlgEdit WS_BORDER, 80, 50, 125, 30, 1000
        DlgButton "Підтвердити", WS_TABSTOP, 60, 120, 50, 30, IDOK
        DlgButton "Відміна", WS_TABSTOP, 160, 120, 90, 30, IDCANCEL
	CallModalDialog 0, 0, KozarezovKyrylDialogHandler, NULL
end start