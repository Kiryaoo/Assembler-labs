.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32rt.inc

.data?
	KozarezovResult dd ?
	KozarezovNumerator dd ?
	KozarezovDenominator dd ?
	KozarezovMsgBuffer db 512 dup(?)
	KozarezovTmp dd ?

.data

	KozarezovMsgCaption db "Лабораторна №5 — Козарезов",0
	KozarezovMsgSuccess db "Обчислення завершено успішно!",13,
		"Формула для варіанту 10: (b/c - 24 + a)/(2*a*c - 12)",13,
		"a = %i, b = %i, c = %i",13,
		"Результат = (%i / %i - 24 + %i)/(2 * %i * %i - 12) = %i",13,
		"Після модифікації: %i",0

	KozarezovMsgFail db "ПОМИЛКА: Ділення на 0",13,
		"Формула: (b/c - 24 + a)/(2*a*c - 12)",13,
		"a = %i, b = %i, c = %i",0

	KozarezovArrayA dd 6, 5, 4,2, 2
	KozarezovArrayB dd 60, 6, 40, -36, 9
	KozarezovArrayC dd 2, 2, 1, 2, 3

.code
start:
	mov esi, 0
KozarezovCalcLoop:
	cmp esi, 5
	jge KozarezovExit

	mov eax, KozarezovArrayA[esi*4]
	mov ebx, KozarezovArrayB[esi*4]
	mov ecx, KozarezovArrayC[esi*4]
	mov edx, ecx

	cmp ecx, 0
	je KozarezovDivZero

	; b / c
	mov eax, ebx
	cdq
	idiv ecx
	mov ebx, eax ; b/c

	mov eax, KozarezovArrayA[esi*4]
	sub ebx, 24
	add ebx, eax ; numerator = b/c - 24 + a
	mov KozarezovNumerator, ebx

	; denominator = 2 * a * c - 12
	mov eax, KozarezovArrayA[esi*4]
	imul eax, 2
	imul eax, KozarezovArrayC[esi*4]
	sub eax, 12
	cmp eax, 0
	je KozarezovDivZero

	mov KozarezovDenominator, eax
	mov eax, KozarezovNumerator
	mov ebx, KozarezovDenominator
	cdq
	idiv ebx
	mov KozarezovResult, eax

	; модифікація результату
	test eax, 1
	jnz KozarezovOdd
		mov eax, KozarezovResult
		cdq
		mov ebx, 2
		idiv ebx
		jmp KozarezovShowResult
KozarezovOdd:
	mov eax, KozarezovResult
	imul eax, 5

KozarezovShowResult:
	invoke wsprintf, addr KozarezovMsgBuffer, addr KozarezovMsgSuccess,
		KozarezovArrayA[esi*4], KozarezovArrayB[esi*4], KozarezovArrayC[esi*4],
		KozarezovArrayB[esi*4], KozarezovArrayC[esi*4], KozarezovArrayA[esi*4],
		KozarezovArrayA[esi*4], KozarezovArrayC[esi*4], KozarezovResult, eax
	invoke MessageBox, NULL, addr KozarezovMsgBuffer, addr KozarezovMsgCaption, MB_OK
	inc esi
	jmp KozarezovCalcLoop

KozarezovDivZero:
	invoke wsprintf, addr KozarezovMsgBuffer, addr KozarezovMsgFail,
		KozarezovArrayA[esi*4], KozarezovArrayB[esi*4], KozarezovArrayC[esi*4]
	invoke MessageBox, NULL, addr KozarezovMsgBuffer, addr KozarezovMsgCaption, MB_ICONERROR
	inc esi
	jmp KozarezovCalcLoop

KozarezovExit:
	invoke ExitProcess, 0
end start
