.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    KyrylKozarezovMessageBoxHeader db "Лабораторна робота №1",0 
    KyrylKozarezovMessageBoxMessage db "ПІБ:Козарезов Кирил Олександрович",13,
	                                "Дата народження: 11.11.2005",13,
								    "Останні цифри студентського квитка: 5001",0
            
.code
start:
    invoke MessageBox, NULL, addr KyrylKozarezovMessageBoxMessage, addr KyrylKozarezovMessageBoxHeader, MB_OK
	invoke ExitProcess, NULL
end start
