.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    KyrylKozarezovMessageBoxHeader db "����������� ������ �1",0 
    KyrylKozarezovMessageBoxMessage db "ϲ�:��������� ����� �������������",13,
	                                "���� ����������: 11.11.2005",13,
								    "������ ����� ������������� ������: 5001",0
            
.code
start:
    invoke MessageBox, NULL, addr KyrylKozarezovMessageBoxMessage, addr KyrylKozarezovMessageBoxHeader, MB_OK
	invoke ExitProcess, NULL
end start
