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

;输入一个字符串，判断串是否正确，同时将串转为整形，并返回串的长度，返回-1时说明有错误
ScanString proc	stdcall base:dword
	xor	esi,esi
	mov ebx,base
	xor eax,eax
	while_max_size_gt0: cmp	esi,200
		jge end_while_max_size_gt0

		mov al,[ebx+esi]
		cmp	al,0
		je end_while_max_size_gt0 ;检测到0时说明到达最大长度

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


;输入byte串和长度，逆序打印
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
	ret 8;ret是不是伪指令？我都stdcall了，我是不是得自己恢复堆栈
OutPutIntString endp


;输入A串的基地址和长度，输入C串的基地址，输入一个整形数，它会自动使用这个整型数与A串相乘并合并，返回本次运算的最高位的偏移量
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

		;C串此位置的值
		add esi,lpBaseC
		mov cl,[esi]

		;A串此位置的值
		mov al,[ebx]
		
		mul	dwNum;A串对应位*数字
		add cl,al;cl需要存算好的值

		;判断进位
		cmp cl,10;大于等于10时carry，小于10时不carry
		jl else_carry
		if_carry:
			mov al,cl
			mov dl,10
			div dl

			push ebx

			;esi就是C串此位置，现在要存下一位置
			mov ebx,esi
			inc ebx
			mov [ebx],al



			mul dl ;al现在存了十位部分
			sub cl,al

			mov dl,1

			pop ebx

		else_carry:

		mov [esi],cl;存到C串

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

	;维护一个指向B最末尾数字的一个指针
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
	
	invoke	OutPutIntString,offset szC,eax ;现在似乎就输出长度有问题

	ret
main endp

end main