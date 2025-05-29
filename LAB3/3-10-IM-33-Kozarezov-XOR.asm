.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\dialogs.inc 
include \masm32\include\masm32rt.inc 

.data
    KozarezovKyryl_MessageBoxHeader       db "Вхід до системи",0
    KozarezovKyryl_MessageBoxSuccessMessage db "ПІБ: Козарезов Кирил Олександрович",13,
                                           "Дата народження: 11.11.2005",13,
                                           "Номер залікової книжки: 5001",0
    KozarezovKyryl_MessageBoxGreetingMessage db "Вітаю! Для відображення інформації про студента введіть пароль:",0
    KozarezovKyryl_MessageBoxErrorMessage  db "Пароль неправильний",0
    KozarezovKyryl_MessageBoxExitMessage   db "До зустрічі!",0
    KozarezovKyryl_Password                db "c/B#IH",0  
    KozarezovKyryl_Key                     db "!@!@!!",0 
    KozarezovKyryl_PasswordLength          dw 6          
   
    debugLenMsgFmt   db "Length returned: %d", 0
    debugLenBuffer   db 16 dup (?)
    debugCharMsgFmt  db "Loop: In '%c' ^ Key '%c' = '%c'. Compared to = '%c'", 0 
    debugCharBuffer  db 128 dup (?)

.data?
    KozarezovKyryl_PasswordInputField db 64 dup (?) 

.code

KozarezovKyryl_ShowMessage proc uses esi edi, messageText: DWORD, messageTitle: DWORD
    invoke MessageBox, NULL, messageText, messageTitle, MB_OK
    ret
KozarezovKyryl_ShowMessage endp

KozarezovKyryl_ExitWindow proc
    invoke KozarezovKyryl_ShowMessage, offset KozarezovKyryl_MessageBoxExitMessage, offset KozarezovKyryl_MessageBoxHeader
    invoke ExitProcess, NULL
KozarezovKyryl_ExitWindow endp

KozarezovKyryl_ErrorWindow proc
    invoke KozarezovKyryl_ShowMessage, offset KozarezovKyryl_MessageBoxErrorMessage, offset KozarezovKyryl_MessageBoxHeader
    invoke ExitProcess, NULL 
KozarezovKyryl_ErrorWindow endp

KozarezovKyryl_SuccessWindow proc
    invoke KozarezovKyryl_ShowMessage, offset KozarezovKyryl_MessageBoxSuccessMessage, offset KozarezovKyryl_MessageBoxHeader
    invoke ExitProcess, NULL
KozarezovKyryl_SuccessWindow endp

KozarezovKyryl_CheckPassword proc
    mov esi, offset KozarezovKyryl_PasswordInputField 
    mov edi, offset KozarezovKyryl_Password          
    mov ebx, offset KozarezovKyryl_Key                
    mov cx, KozarezovKyryl_PasswordLength         

KozarezovKyryl_CompareChars:
    
    test cx, cx
    jz KozarezovKyryl_PasswordMatch 
    mov al, [esi]   
    test al, al
    jz KozarezovKyryl_PasswordMismatch 
    xor al, [ebx]   
    cmp al, [edi]   
    jne KozarezovKyryl_PasswordMismatch 
    inc esi         
    inc edi         
    inc ebx        
    dec cx          
    jmp KozarezovKyryl_CompareChars

KozarezovKyryl_PasswordMatch:

    call KozarezovKyryl_SuccessWindow
    ret

KozarezovKyryl_PasswordMismatch:
    call KozarezovKyryl_ErrorWindow
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
