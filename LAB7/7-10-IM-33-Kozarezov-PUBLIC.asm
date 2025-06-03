.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

; Оголошення зовнішніх змінних і міток
EXTRN KozarezovDataA: QWORD
EXTRN KozarezovDataB: QWORD
EXTRN KozarezovTemp: QWORD
EXTRN KozarezovTanVal: QWORD

PUBLIC KozarezovDenom
PUBLIC KozarezovCalcDenom

.data?
    KozarezovDenom              dq ?

.data
    KozarezovTwo                dq 2.0

.code
KozarezovCalcDenom PROC C
    fld KozarezovDataA[esi*8]
    fdiv KozarezovTwo
    fstp KozarezovTemp

    fld KozarezovTemp
    fptan
    fstp st(0)
    fstp KozarezovTanVal

    fld KozarezovDataB[esi*8]
    fsub KozarezovTanVal
    fstp KozarezovDenom
    ret
KozarezovCalcDenom ENDP

end