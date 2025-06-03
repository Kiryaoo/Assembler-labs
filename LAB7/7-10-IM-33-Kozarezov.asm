.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

; Оголошення зовнішньої змінної та процедури
EXTRN KozarezovDenom: QWORD
EXTRN KozarezovCalcDenom: PROC

; Оголошення змінних і міток як PUBLIC
PUBLIC KozarezovDataA
PUBLIC KozarezovDataB
PUBLIC KozarezovTemp
PUBLIC KozarezovTanVal
PUBLIC KozarezovTanError

.data?
    KozarezovOutBuf             db 1024 dup(?)
    KozarezovTempBuf            db 256 dup(?)
    KozarezovStrA               db 32 dup(?)
    KozarezovStrB               db 32 dup(?)
    KozarezovStrC               db 32 dup(?)
    KozarezovStrD               db 32 dup(?)
    KozarezovStrRes             db 32 dup(?)
    KozarezovStrTanVal          db 32 dup(?)
    KozarezovTemp               dq ?
    KozarezovNumer              dq ?
    KozarezovTanVal             dq ?

.data
    KozarezovTitle              db "Лабораторна робота №7", 0
    KozarezovHeader             db "Обчислення спеціальної формули", 13, 10
                                db "-----------------------------", 13, 10, 0
    KozarezovFormula            db "(4*C + D - 1) / (B - tg(A/2))", 13, 10, 0
    KozarezovInputFmt           db "Вхідні параметри:", 13, 10
                                db "A = %s", 13, 10
                                db "B = %s", 13, 10
                                db "C = %s", 13, 10
                                db "D = %s", 13, 10, 13, 10, 0
    KozarezovCalcFmt            db "Обчислюємо:", 13, 10
                                db "(4*%s + %s - 1)/(%s - tg(%s/2))", 13, 10, 0
    KozarezovTanValFmt          db "Значення tg(A/2) = %s", 13, 10, 13, 10, 0
    KozarezovResultFmt          db ">>> Результат: %s", 13, 10, 0
    KozarezovErrorDivZero       db ">>> Помилка: Ділення на нуль!", 13, 10, 0
    KozarezovErrorTanDomain     db ">>> Помилка: Невизначений тангенс!", 13, 10, 0

    KozarezovDataA              dq -5.5, -2.7, -1.047, -2.8, 3.1415926
    KozarezovDataB              dq  4.8, 5.6, -1.5, 1.5, -0.5236
    KozarezovDataC              dq  2.7, -1.2, -0.25, -1.5, 1.5
    KozarezovDataD              dq -1.8, 2.9, 0.5, 0.5, 3.1

    KozarezovFour               dq 4.0
    KozarezovOne                dq 1.0
    KozarezovTwo                dq 2.0
    KozarezovPi                 dq 3.141592
    KozarezovPiDiv2             dq 1.570796
    KozarezovEpsilon            dq 0.000001

.code
; Процедура для обчислення 4*C через регістри
KozarezovCalcFirst PROC
    fld KozarezovDataC[esi*8]  ; Завантажити C
    fmul KozarezovFour         ; 4*C
    ret
KozarezovCalcFirst ENDP

; Процедура для обчислення D - 1 через стек
KozarezovCalcSecond PROC
    push ebp
    mov ebp, esp
    fld qword ptr [ebp+8]      ; Завантажити D зі стека
    fsub KozarezovOne          ; D - 1
    mov esp, ebp
    pop ebp
    ret 8
KozarezovCalcSecond ENDP

KozarezovDivZero:
    invoke wsprintf, addr KozarezovOutBuf, addr KozarezovHeader
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovFormula
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovInputFmt,
                     addr KozarezovStrA, addr KozarezovStrB,
                     addr KozarezovStrC, addr KozarezovStrD
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovCalcFmt,
                     addr KozarezovStrC, addr KozarezovStrD,
                     addr KozarezovStrB, addr KozarezovStrA
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke FloatToStr, KozarezovTanVal, addr KozarezovStrTanVal
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovTanValFmt, addr KozarezovStrTanVal
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovErrorDivZero
    jmp KozarezovShowResult

KozarezovTanError:
    invoke wsprintf, addr KozarezovOutBuf, addr KozarezovHeader
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovFormula
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovInputFmt,
                     addr KozarezovStrA, addr KozarezovStrB,
                     addr KozarezovStrC, addr KozarezovStrD
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovCalcFmt,
                     addr KozarezovStrC, addr KozarezovStrD,
                     addr KozarezovStrB, addr KozarezovStrA
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovErrorTanDomain
    jmp KozarezovShowResult

KozarezovBuildOutput:
    invoke wsprintf, addr KozarezovOutBuf, addr KozarezovHeader
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovFormula
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovInputFmt,
                     addr KozarezovStrA, addr KozarezovStrB,
                     addr KozarezovStrC, addr KozarezovStrD
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovCalcFmt,
                     addr KozarezovStrC, addr KozarezovStrD,
                     addr KozarezovStrB, addr KozarezovStrA
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke FloatToStr, KozarezovTanVal, addr KozarezovStrTanVal
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovTanValFmt, addr KozarezovStrTanVal
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf
    invoke wsprintf, addr KozarezovTempBuf, addr KozarezovResultFmt, addr KozarezovStrRes
    invoke szCatStr, addr KozarezovOutBuf, addr KozarezovTempBuf

KozarezovShowResult:
    invoke MessageBox, 0, addr KozarezovOutBuf, addr KozarezovTitle, MB_OK
    inc esi
    cmp esi, 5
    jl KozarezovLoop
    invoke ExitProcess, 0

KozarezovMain:
    xor esi, esi

KozarezovLoop:
    invoke RtlZeroMemory, addr KozarezovOutBuf, sizeof KozarezovOutBuf
    invoke RtlZeroMemory, addr KozarezovTempBuf, sizeof KozarezovTempBuf
    invoke RtlZeroMemory, addr KozarezovStrRes, sizeof KozarezovStrRes
    invoke RtlZeroMemory, addr KozarezovStrTanVal, sizeof KozarezovStrTanVal

    finit

    invoke FloatToStr, KozarezovDataA[esi*8], addr KozarezovStrA
    invoke FloatToStr, KozarezovDataB[esi*8], addr KozarezovStrB
    invoke FloatToStr, KozarezovDataC[esi*8], addr KozarezovStrC
    invoke FloatToStr, KozarezovDataD[esi*8], addr KozarezovStrD

    ; Обчислення чисельника
    call KozarezovCalcFirst      ; Обчислення 4*C
    fstp KozarezovTemp           ; Зберегти перший доданок

    push dword ptr KozarezovDataD[esi*8+4] ; Параметр D у стек
    push dword ptr KozarezovDataD[esi*8]
    call KozarezovCalcSecond     ; Обчислення D - 1
    fadd KozarezovTemp           ; Додати до першого доданка
    fstp KozarezovNumer          ; Зберегти чисельник

    ; Перевірка області визначення тангенса
    fld KozarezovDataA[esi*8]
    fdiv KozarezovTwo
    fstp KozarezovTemp

    fld KozarezovTemp
    fsub KozarezovPiDiv2
    fld KozarezovPi
    fxch st(1)
    fprem
    fstp st(1)
    fabs
    fld KozarezovEpsilon
    fxch st(1)
    fcomp st(1)
    fstsw ax
    sahf
    fstp st(0)
    jbe KozarezovTanError

    ; Обчислення знаменника
    call KozarezovCalcDenom      ; Виклик процедури для знаменника

    ; Перевірка ділення на нуль
    fld KozarezovDenom
    ftst
    fstsw ax
    sahf
    jz KozarezovDivZero
    fstp st(0)

    ; Обчислення результату
    fld KozarezovNumer
    fdiv KozarezovDenom
    fstp KozarezovTemp

    invoke FloatToStr, KozarezovTemp, addr KozarezovStrRes
    jmp KozarezovBuildOutput

end KozarezovMain