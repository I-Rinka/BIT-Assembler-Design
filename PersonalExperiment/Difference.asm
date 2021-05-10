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
;MessageBoxA proto stdcall:ptr dword,:ptr dword,:ptr dword,:ptr dword

printf proto C:ptr sbyte,:vararg

puts proto C:ptr sbyte

.data

szOutStr byte 'aaa %s',0

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
local buffer[100]:byte,buffer2[100]:byte	

lea eax,buffer
push 100
push eax
call GetFileName

lea eax,buffer2
push 100
push eax
call GetFileName


invoke puts,addr buffer

invoke puts,addr buffer2

ret
main endp

end main