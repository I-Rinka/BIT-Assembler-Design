.386
.model	flat, stdcall

includelib	msvcrt.lib
printf proto C : ptr sbyte, : VARARG
scanf proto C: ptr sbyte,: VARARG

.data
szSingleInt	BYTE '%d',0
szString BYTE '%s',0

szA BYTE 200 DUP(0)
szB BYTE 200 DUP(0)
szC BYTE 400 DUP(0)

.code

;����һ���ַ������жϴ��Ƿ���ȷ��ͬʱ����תΪ���Σ������ش��ĳ��ȣ�����-1ʱ˵���д���
ScanString proc	stdcall base:dword
	local	tmp:dword
	;mov max_size,200
	xor	esi,esi
	mov ebx,base
	while_max_size_gt0: cmp	esi,200
	jge end_while_max_size_gt0

	mov al,[ebx+esi]
	cmp	al,0
	je end_while_max_size_gt0 ;��⵽0ʱ˵��������󳤶�

	inc esi

	jmp while_max_size_gt0
	end_while_max_size_gt0:
	mov eax,esi

	ret
ScanString endp




main	proc
	invoke scanf,addr szString,addr szA
	;invoke printf,addr szString,addr szA'

	invoke ScanString,offset szA

	invoke	printf,offset szSingleInt,eax

	push offset szA
	push offset szString
	call printf
	add esp,8

	ret
main endp

end main