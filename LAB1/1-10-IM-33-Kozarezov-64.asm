OPTION DOTNAME
	
option casemap:none
include \masm64\include\temphls.inc
include \masm64\include\win64.inc
include \masm64\include\kernel32.inc
includelib \masm64\lib\kernel32.lib
include \masm64\include\user32.inc
includelib \masm64\lib\user32.lib

OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none

.data
KyrylKozarezovMessageBoxHeader db "����������� ������ �1",0
KyrylKozarezovMessageBoxMessage db "ϲ�:��������� ����� �������������",13,
								"���� ����������: 11.11.2005",13,
								"������ ����� ������������� ������: 5001",0
.code
WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &KyrylKozarezovMessageBoxMessage, &KyrylKozarezovMessageBoxHeader, MB_OK
      invoke ExitProcess,NULL
WinMain endp
end
