.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32rt.inc

; --- ДАНІ ---
.data
    KozarezovTitle db "Лабораторна робота 2", 0 
    KozarezovInfo  db "Дата народження: 11.11.2005", 13,
                      "Останні цифри студентського: 5001", 13,
                      "Результати:", 13,
                      "A = %d;   -A = %d", 13,
                      "B = %d;   -B = %d", 13,
                      "C = %d;   -C = %d", 13,
                      "D = %s;   -D = %s", 13,
                      "E = %s;   -E = %s", 13,
                      "F = %s;   -F = %s", 0

    KozarezovValuesDD dd 11, -11, 1111, -1111, 11112005, -11112005,  0.0021, -0.0021
    KozarezovValuesDB db 11, -11
    KozarezovValuesDW dw 11, -11, 1111, -1111
    KozarezovValuesDQ dq 11, -11, 1111, -1111, 11112005, -11112005, 0.0021, -0.0021, 0.222, -0.222, 2221.956, -2221.9566
    KozarezovValuesDT dt 2221.956, -2221.9566

    KozarezovFloatValues dq 0.0021, -0.0021, 0.222, -0.222, 2221.956, -2221.9566

    KozarezovDOB db "11112005", 0


.data?
    KozarezovMsgBuffer db 256 dup(?)
    KozarezovFloatStrBuffers db 6 * 128 dup(?) 


.code

convert_floats:
    push ebx
    mov ebx, offset KozarezovFloatValues
    
    invoke FloatToStr2, [ebx], addr KozarezovFloatStrBuffers
    invoke FloatToStr2, [ebx+8], addr KozarezovFloatStrBuffers+128
    invoke FloatToStr2, [ebx+16], addr KozarezovFloatStrBuffers+256
    invoke FloatToStr2, [ebx+24], addr KozarezovFloatStrBuffers+384
    invoke FloatToStr2, [ebx+32], addr KozarezovFloatStrBuffers+512
    invoke FloatToStr2, [ebx+40], addr KozarezovFloatStrBuffers+640
    
    pop ebx
    ret

start:
    call convert_floats

    invoke wsprintf, addr KozarezovMsgBuffer, addr KozarezovInfo,
        KozarezovValuesDD, KozarezovValuesDD+4,
        KozarezovValuesDD+8, KozarezovValuesDD+12,
        KozarezovValuesDD+16, KozarezovValuesDD+20,
        offset KozarezovFloatStrBuffers, offset KozarezovFloatStrBuffers+128,
        offset KozarezovFloatStrBuffers+256, offset KozarezovFloatStrBuffers+384,
        offset KozarezovFloatStrBuffers+512, offset KozarezovFloatStrBuffers+640

    invoke MessageBox, NULL, addr KozarezovMsgBuffer, addr KozarezovTitle, MB_OK
    invoke ExitProcess, NULL

end start