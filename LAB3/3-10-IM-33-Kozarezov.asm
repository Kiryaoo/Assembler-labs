.386
.model flat, stdcall
option casemap: none

include \masm32\include\dialogs.inc
include \masm32\include\masm32rt.inc

.data
    KozarezovKyrylHeaderText        db "Вхід до системи",0
    KozarezovKyrylSuccessMessage     db "ПІБ: Козарезов Кирил Олександрович",13,
                                        "Дата народження: 11.11.2005",13,
                                        "Номер залікової книжки: 5001",0
    KozarezovKyrylErrorMessage      db "Пароль неправильний",0
    KozarezovKyrylExitMessage       db "До зустрічі!",0
    KozarezovKyrylCorrectPassword   db "Bocchi",0
    KozarezovKyrylPasswordLength    dd 6

.data?
    KozarezovKyrylUserInput db 64 dup (?)  

.code

KozarezovKyrylVerifyPassword proc
    mov ecx, KozarezovKyrylPasswordLength
    lea esi, KozarezovKyrylUserInput
    lea edi, KozarezovKyrylCorrectPassword

KozarezovKyrylCompareLoop:
    mov al, [esi]  
    xor al, [edi]  
    test al, al    
    jne KozarezovKyrylIncorrectPassword
    inc esi        
    inc edi
    loop KozarezovKyrylCompareLoop 

    call KozarezovKyrylShowSuccess
    ret

KozarezovKyrylIncorrectPassword:
    call KozarezovKyrylShowError
    ret
KozarezovKyrylVerifyPassword endp

KozarezovKyrylShowSuccess proc 
    invoke MessageBox, NULL, addr KozarezovKyrylSuccessMessage, addr KozarezovKyrylHeaderText, MB_OK
    invoke ExitProcess, NULL
KozarezovKyrylShowSuccess endp

KozarezovKyrylShowError proc 
    invoke MessageBox, NULL, addr KozarezovKyrylErrorMessage, addr KozarezovKyrylHeaderText, MB_OK
    ret
KozarezovKyrylShowError endp

KozarezovKyrylExitDialog proc 
    invoke MessageBox, NULL, addr KozarezovKyrylExitMessage, addr KozarezovKyrylHeaderText, MB_OK
    invoke ExitProcess, NULL
KozarezovKyrylExitDialog endp

KozarezovKyrylDialogHandler proc KozarezovKyrylhWnd: dword, KozarezovKyrylmsg: dword, KozarezovKyrylwParam: dword, KozarezovKyryllParam: dword
    .if KozarezovKyrylmsg == WM_COMMAND
        .if KozarezovKyrylwParam == IDOK
            invoke GetDlgItemText, KozarezovKyrylhWnd, 1000, addr KozarezovKyrylUserInput, 64
            invoke lstrlen, addr KozarezovKyrylUserInput
            cmp eax, KozarezovKyrylPasswordLength
            jne KozarezovKyrylShowError ; якщо довжина ? 6 — помилка
            call KozarezovKyrylVerifyPassword
        .endif     
        .if KozarezovKyrylwParam == IDCANCEL
            call KozarezovKyrylExitDialog
        .endif
    .elseif KozarezovKyrylmsg == WM_CLOSE
        call KozarezovKyrylExitDialog
    .endif
    return 0 
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
