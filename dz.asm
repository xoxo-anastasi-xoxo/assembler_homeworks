;��������� ���162 ��������� ��������� ���������


;������: ����������� ��������� ������� �� ���������� ���� ��������
;        (�������� � �������� ���� ��� ��������� ���������� ��������
;        �������� � ���� ����� ��� �����) ������, ����� �� ��� ��������
;        ��������� ��������������� ������������.

;---------------------------------------------

format PE GUI 4.0
entry start

include 'c:\fasmw\INCLUDE\WIN32AX.INC'
include 'C:\fasmw\INCLUDE\MACRO\PROC32.INC'

;---------------------------------------------

section '.data' data readable writeable

title  db     '��� �������������� �����������?',0

; ��������� x-���������� 1,2 � 3 �������� ��������������
bx1      dd      0
bx2      dd      0
bx3      dd      0

; ��������� y-���������� 1,2 � 3 �������� ��������������
by1      dd      3
by2      dd      1
by3      dd      1

; �������� x-���������� 1,2 � 3 �������� ��������������
ex1      dd      2
ex2      dd      2
ex3      dd      2

; �������� y-���������� 1,2 � 3 �������� ��������������
ey1      dd      3
ey2      dd      1
ey3      dd      1

;---------------------------------------------

section '.code' code readable executable
 start:

; ������� ����� ������� �������
  stdcall length, [bx1], [by1], [ex1], [ey1]

; ���������� ����������� �������� � ax
 mov ax, cx

; ������� ����� ������� �������
 stdcall length, [bx2], [by2], [ex2], [ey2]


; ��������� ����� �� ����� ���� ������ ��������
 cmp  cx, ax
 jne  .fal

; ������� ����� �������� �������
 stdcall length, [bx3], [by3], [ex3], [ey3]


; ��������� ����� �� ����� ������� � ������� ��������
 cmp  cx, ax
 jne  .fal

      invoke  MessageBox,NULL,"��:)",title,MB_OK
      jmp .exit

.fal:
      invoke  MessageBox,NULL,"���:(",title,MB_OK
       jmp .exit

.exit:
      invoke  ExitProcess,0


;-----------------------------------------------------
; ��������� ���������� ������ � ���������� �����, ���������� ����� ������� ����� ������� cx
 proc length uses ax, x1:WORD, y1:WORD, x2:WORD, y2:WORD

; ������� ��� �� ������� (x2-x1)^2 + (y2-y1)^2

; (x2-x1)^2

 mov   ax,[x2]
;(x2-x1)
 sub   ax,[x1]

; �������� � �������, ��������� � ax
 imul  ax,ax

; ������������ ������ ��������� � cx
  mov   cx,ax

; (y2-y1)^2
 mov   ax,[y2]
; (y2-y1)
 sub   ax,[y1]

; �������� � �������, ��������� � ax
 imul  ax, ax

 ; ��������� ������ ��������� � ����������
 add   cx,ax

    ret
endp

;---------------------------------------------

section '.idata' import data readable writeable

  library kernel32,'kernel32.dll',\
          user32,'user32.dll'

  include 'C:\fasmw\INCLUDE\API\KERNEL32.INC'
  include 'C:\fasmw\INCLUDE\API\USER32.INC'
