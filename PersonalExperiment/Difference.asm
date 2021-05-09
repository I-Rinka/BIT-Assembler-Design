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
 
.data?
hInstance	dd	?
hMainWin	dd	?
 
.const
szMyClass	db	"MyClass",0
szCaption	db	"First Window", 0
szText		db	"Hello, world", 0
 
.code
;���ڹ��̺���
_ProcMainWin	proc	uses ebx edi esi, hWnd, uMsg, wParam, lParam
	
	LOCAL @hdc:HDC
	LOCAL @ps:PAINTSTRUCT
	LOCAL @szRect:RECT
	
	mov eax, uMsg
	
	.if eax == WM_PAINT
		invoke BeginPaint,hWnd, addr @ps
		mov @hdc, eax
		invoke GetClientRect,hWnd, addr @szRect
		invoke DrawText,@hdc, offset szText,-1,addr @szRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
		invoke EndPaint,hWnd, addr @ps
	.elseif	eax == WM_CLOSE;�����ϢΪWM_CLOSE,�����ٴ��ڣ���Post WM_QUIT ����Ϣѭ������
		invoke DestroyWindow,[hMainWin];
		invoke PostQuitMessage,NULL
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret		
	.endif
 
	xor eax,eax
	ret
 
_ProcMainWin endp
 
_MainWin	proc	
	LOCAL @wcex:WNDCLASSEX
	LOCAL @stMsg:MSG
	
	;��ȡ���ھ��
	invoke GetModuleHandle,NULL
	mov [hInstance], eax
	invoke RtlZeroMemory,addr @wcex, sizeof @wcex
	
	;��ʼ��WNDCLASSEX
	mov @wcex.cbSize, sizeof(WNDCLASSEX)
	mov @wcex.style, CS_HREDRAW or CS_VREDRAW;
	mov @wcex.lpfnWndProc, offset _ProcMainWin
	
	mov @wcex.cbClsExtra,0;
	mov @wcex.cbWndExtra,0;
	mov eax, [hInstance]
	mov @wcex.hInstance,eax;
	invoke LoadIcon,NULL, IDI_WINLOGO
	mov @wcex.hIcon,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov @wcex.hCursor,eax
	mov @wcex.hbrBackground,COLOR_WINDOW+1
	mov @wcex.lpszMenuName, 0
	mov @wcex.lpszClassName,offset szMyClass
	;ע�ᴰ����
	invoke RegisterClassEx,addr @wcex
	;��������
	invoke CreateWindowEx,WS_EX_CLIENTEDGE, offset szMyClass, offset szCaption, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,\
	0,CW_USEDEFAULT, 0, NULL, NULL, [hInstance], NULL
	
	mov [hMainWin], eax
	invoke ShowWindow,[hMainWin], SW_SHOWNORMAL
	invoke UpdateWindow,[hMainWin]
	
	;������Ϣѭ��
	.while	TRUE
		invoke GetMessage,addr @stMsg, NULL, 0, 0
		.if eax == 0		;�����ȡ����Ϣ��WM_QUIT����ôEAXλ0�����Ƴ���Ϣѭ��
			.break
		.endif
		invoke TranslateMessage,addr @stMsg
		invoke DispatchMessage,addr @stMsg
	.endw
	
	mov eax, @stMsg.wParam
	ret
 
_MainWin endp
 
start:
	call	_MainWin
	invoke	ExitProcess,NULL
	
end start
