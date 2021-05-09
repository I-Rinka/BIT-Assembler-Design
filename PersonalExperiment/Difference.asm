.386
.model	flat, stdcall
option casemap:none;这个在窗体编程中是必加的！

include windows.inc
 
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
 
include	gdi32.inc
includelib gdi32.lib

.data

.code 
main proc

ret
main endp

end main