	.386
	.model	flat,stdcall
	option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;include 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include windows.inc
 
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
 
include	gdi32.inc
includelib gdi32.lib
 

.const
szMyClass	db	"MyClass",0
szCaption	db	"First Window", 0
szText		db	"Hello, world", 0
 
.code
 
main	proc	
ret
main endp
 
;start:
	;call	_MainWin
	;invoke	ExitProcess,NULL
	
end main

