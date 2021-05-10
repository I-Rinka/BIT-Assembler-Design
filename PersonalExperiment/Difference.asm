.386
.model	flat, stdcall
option casemap:none;这个在窗体编程中是必加的！


includelib msvcrt.lib
 
include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
include	gdi32.inc
includelib gdi32.lib

GetOpenFileNameA proto stdcall:ptr dword
MessageBoxA proto stdcall:dword,:dword,:dword,:dword
fopen proto c:dword,:dword
fgets proto c:dword,:dword,:dword
fclose proto c:dword
strcmp proto c:dword,:dword
sprintf proto c:dword,:dword,:dword
exit proto c:dword


printf proto C:ptr sbyte,:vararg

puts proto C:ptr sbyte

.data

_szOutStr byte 'aaa %s',0
_szMsgBoxTitle byte 'Difference!',0
_szContentIsDifferent byte 'Content is different at line %d',0
_szNoDifferent byte 'No different!',0

_buffer byte 1000 DUP(0)
_buffer1 byte 1000 DUP(0)
_buffer2 byte 1000 DUP(0)
_bufferSize dword 1000

_szRead byte 'r',0

OPENFILENAMEA struct
	lStructSize	dword	0
	hwndOwner	dword	0
	hInstance	dword	0
	lpstrFilter	dword	0
	lpstrCustomFilter	dword	0
	nMaxCustFilter	dword	0
	nFilterIndex	dword	0
	lpstrFile	dword	0
	nMaxFile	dword	0
	lpstrFileTitle	dword	0
	nMaxFileTitle	dword	0
	lpstrInitialDir	dword	0
	lpstrTitle	dword	0
	Flags	dword	0
	nFileOffset	word	0
	nFileExtension	word	0
	lpstrDefExt	dword	0
	lCustData	dword	0
	lpfnHook	dword	0
	lpTemplateName	dword	0
	;pvReserved	dword	0
	;dwReserved	dword	0
	;FlagsEx	dword	0

OPENFILENAMEA ends


.code 
OPENFILENAMEA_SIZE	equ	 04ch

GetFileName proc stdcall lpBuffer:dword,dwBufferSize:dword
local	ofn:OPENFILENAMEA
	mov ofn.lStructSize,OPENFILENAMEA_SIZE
	mov ebx,lpBuffer
	mov ofn.lpstrFile,ebx
	xor al,al
	mov [ebx],al

	mov eax,dwBufferSize
	mov ofn.nMaxFile,eax

	lea eax,ofn

	push eax
	call GetOpenFileNameA
	sub esp,4
	;invoke GetOpenFileNameA,eax

	;leave相当于还原esp,还原ebp；将本函数的临时变量全部无视
	ret 2*4
GetFileName endp

main proc
local @file1:dword,@file2:dword,@line:dword,@judge:dword


	;获取两个文件的文件名
	lea eax,_buffer1
	push 100
	push eax
	call GetFileName

	lea eax,_buffer2
	push 100
	push eax
	call GetFileName

	;打开两个文件
	invoke fopen,addr _buffer1,addr _szRead
	cmp eax,0
	je en

	mov @file1,eax

	invoke fopen,addr _buffer2,addr _szRead
	cmp eax,0
	je en

	mov @file2,eax

	mov @line,0
	mov @judge,0

	while_fgets_file1_ne_0:
		invoke	fgets,addr _buffer1,_bufferSize,@file1
	cmp eax,0
	je end_while_fgets_file1_ne_0
		inc @line
		
		if_fgets_file2_ne_0:
		invoke	fgets,addr _buffer2,_bufferSize,@file2
		cmp eax,0
		je else_fgets_file2_ne_0;提前结束
			;内层判断

			invoke strcmp,addr _buffer1,addr _buffer2
			cmp eax,0
			je buffer_equals

				mov @judge,1
				jmp end_while_fgets_file1_ne_0;break
				
			buffer_equals:
				jmp while_fgets_file1_ne_0

		else_fgets_file2_ne_0:
			mov @judge,1
			jmp end_while_fgets_file1_ne_0;break


	end_while_fgets_file1_ne_0:

	if_fgets_buffer2_ne_0:
	invoke	fgets,addr _buffer2,_bufferSize,@file2
	cmp eax,0
	je end__fgets_buffer2_ne_0
		mov @judge,1
	end__fgets_buffer2_ne_0:

	if_judge:
	cmp @judge,1
	jne else_if_judge
	
		invoke sprintf,addr _buffer,addr _szContentIsDifferent,@line
		invoke	MessageBoxA,0,offset _buffer,offset _szMsgBoxTitle,0

	jmp end_if_judge

	else_if_judge:

		invoke	MessageBoxA,0,offset _szNoDifferent,offset _szMsgBoxTitle,0

	end_if_judge:
	invoke fclose,@file2
	invoke fclose,@file1
en:
invoke exit,0
ret
main endp

end main