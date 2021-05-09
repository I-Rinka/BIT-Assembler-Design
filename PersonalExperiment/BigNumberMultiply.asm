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
	xor	esi,esi
	mov ebx,base
	xor eax,eax
	while_max_size_gt0: cmp	esi,200
		jge end_while_max_size_gt0

		mov al,[ebx+esi]
		cmp	al,0
		je end_while_max_size_gt0 ;��⵽0ʱ˵��������󳤶�

		cmp al,'0'
		jl  error_input

		sub al,'0'
		mov [ebx+esi],al

		inc esi

	jmp while_max_size_gt0
	end_while_max_size_gt0:
	mov eax,esi

	ret 4

	error_input:
	mov eax,-1
	ret 4
ScanString endp


;����byte���ͳ��ȣ������ӡ
OutPutIntString proc stdcall base:dword,len:dword
	mov esi,len
	dec	esi
	mov ebx,base
	xor	eax,eax
	while_esi_gt0: cmp esi,0
	jl end_while_esi_gt0
		mov al,[ebx+esi]
		pusha
		
		invoke	printf,offset szSingleInt,eax

		popa
		dec esi
	jmp while_esi_gt0
	end_while_esi_gt0:
	mov eax,0
	ret 8;ret�ǲ���αָ��Ҷ�stdcall�ˣ����ǲ��ǵ��Լ��ָ���ջ
OutPutIntString endp


;����A���Ļ���ַ�ͳ��ȣ�����C���Ļ���ַ������һ���������������Զ�ʹ�������������A����˲��ϲ������ر�����������λ��ƫ����
ComputeIntString proc	stdcall lpBaseC:DWORD,lpBaseA:DWORD,dwLenA:DWORD,dwNum:DWORD
	local len:dword
	mov esi,dwLenA
	mov len,esi
	mov ebx,lpBaseA
	add ebx,dwLenA
	dec ebx

	xor eax,eax

	while_LenA_gt0:cmp ebx,lpBaseA
	jl end_while_LenA_gt0
		xor dl,dl

		mov esi,lpBaseA
		add esi,dwLenA
		sub esi,ebx
		dec esi

		;C����λ�õ�ֵ
		add esi,lpBaseC
		mov cl,[esi]

		;A����λ�õ�ֵ
		mov al,[ebx]
		
		mul	dwNum;A����Ӧλ*����
		add cl,al;cl��Ҫ����õ�ֵ

		;�жϽ�λ
		cmp cl,10;���ڵ���10ʱcarry��С��10ʱ��carry
		jl else_carry
		if_carry:
			mov al,cl
			mov dl,10
			div dl

			push ebx

			;esi����C����λ�ã�����Ҫ����һλ��
			mov ebx,esi
			inc ebx
			mov [ebx],al



			mul dl ;al���ڴ���ʮλ����
			sub cl,al

			mov dl,1

			pop ebx

		else_carry:

		mov [esi],cl;�浽C��

		dec ebx
	jmp while_LenA_gt0
	end_while_LenA_gt0:

	xor eax,eax
	mov al,dl
	add eax,dwLenA
	add eax,lpBaseC
	ret 4*4
ComputeIntString endp

main	proc
	local lenA:DWORD,lenB:DWORD
	invoke scanf,addr szString,addr szA
	;invoke printf,addr szString,addr szA'
	invoke scanf,addr szString,addr szB

	invoke ScanString,offset szA
	mov lenA,eax
	
	invoke	ScanString,offset szB
	mov lenB,eax

	;ά��һ��ָ��B��ĩβ���ֵ�һ��ָ��
	mov ebx,offset szB
	add ebx,lenB
	dec ebx

	lea esi,szC
	while_ebx_ge_szB:cmp ebx,offset szB
	jl end_while_ebx_ge_szB
		push esi
		push ebx

		invoke ComputeIntString,esi,offset szA,lenA,[ebx]

		pop ebx
		pop esi

		inc esi
		dec ebx
	jmp while_ebx_ge_szB
	end_while_ebx_ge_szB:


	sub eax,offset szC
	
	invoke	OutPutIntString,offset szC,eax ;�����ƺ����������������

	ret
main endp

end main