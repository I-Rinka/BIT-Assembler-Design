.386
.model	flat,stdcall

includelib	msvcrt.lib
printf proto C :ptr sbyte,:VARARG

.data
szFMT	sbyte '%d',0ah,0

.code
main	proc
	invoke	printf,addr szFMT,666
	ret
main endp
end main