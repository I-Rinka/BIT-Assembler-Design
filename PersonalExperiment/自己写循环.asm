.386
.model	flat,stdcall

includelib	msvcrt.lib
printf proto C :ptr sbyte,:VARARG

.data
szFMT	sbyte '%d',0ah,0

.code
main	proc
	xor eax,eax
	xor ecx,ecx
	
	start_loop:
	cmp ecx,10
	jge end_loop
		add eax,ecx
		xor ebx,ebx

		start_loop2:
			cmp ebx,15
			jge end_loop2
				
				sub eax,ebx
				start_loop3:
					mov edx,ebx
					shl edx,2

					cmp eax,edx
					jge end_loop3
						
						start_loop4:
						mov edx,ecx
						shl edx,10
						cmp eax,edx
						jge end_loop4

							shl eax,20

						jmp start_loop4
						end_loop4:


					add eax,ebx
				jmp start_loop3
				end_loop3:

				
				inc ebx
			jmp start_loop2
			end_loop2:
		inc ecx
	jmp start_loop
	end_loop:


	invoke	printf,addr szFMT,eax
	ret
main endp
end main