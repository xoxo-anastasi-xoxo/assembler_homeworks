.386 ;������������ ���������, ��������� ���������� ������������ ����� �������� ��� ���������� 80386
.model flat, stdcall ;������ ������� ������ ������ � ������ ������
option casemap: none ;������� ����� "���������������" � ���������

;-------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------
 
include /masm32/include/windows.inc
include /masm32/include/user32.inc ;������������ ���������������� ���������
include /masm32/include/kernel32.inc ;API-�������, ����������������� � ������� � ����������� ����������

includelib /masm32/lib/user32.lib ; ��� ������� �� �������� � ��� � ������� ����, � ������������ �� ���������
includelib /masm32/lib/kernel32.lib ; ��� ������� ����������, ��� �� ������ ������������ � ����� �����

;-------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------

.data
szTitle1 db     'After Replace',0
szTitle2 db     'Original String',0

szStr1  db      'Stacey',0
szStr2  db      'Anastasia',0
buff1   db      'Hi, I am Stacey!',13,10,'Stacey is 19 years old.',13,10,'Stacey is from Orenburg.',0

buff2   dw      1000h ; ����� �������� � 4 �����

replace PROTO lpSrc:DWORD, ; ��������� �� �������� ������
              lpPattern:DWORD, ; ��������� �� ����� ��� ���������� ������
              lpReplace:DWORD, ; ��������� �� ���������� ���������
              lpDst:DWORD ; lpReplace - ��������� �� ������ ��� ������

;-------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------

.code

 start:

        ; �������� ������������ ������
        invoke  MessageBox,0,offset buff1,offset szTitle2,MB_OK

        ; ������� ������� ������
        invoke replace,offset buff1, offset szStr1, offset szStr2,offset buff2
        
        ; ����������������� ���������
        invoke  MessageBox,0,offset buff2,offset szTitle1,MB_OK
        
        ; �������� ���������� windows
        invoke  ExitProcess,0



replace PROC lpSrc:DWORD,lpPattern:DWORD,lpReplace:DWORD,lpDst:DWORD

        pusha

        ; ��������� �� �����-��������
        mov     edx,[lpDst]

        ; �������� ������ �� ������?
        mov     ecx,[lpSrc]
        cmp     byte ptr [ecx],0
        jz      loc_ret

        ; ���������� ������ �� ������?
        mov     eax,[lpPattern]
        cmp     byte ptr [eax],0
        jz      loc_copy_all

loc_scan:
        mov     esi,ecx
        mov     edi,[lpPattern]

        ; �������� ������ �����������?
        cmp     byte ptr [esi],0
        je      loc_end_replace

@@:
        ; ������ ������� � ��������?
        cmp     byte ptr [edi],0
        je      loc_move_replace

        ; ������ ��������� �
        lodsb

        cmp     al,byte ptr [edi]
        jne     loc_move_one_char

        inc     edi
        jmp     @b

loc_move_replace:
       
        mov     ecx,esi

        ; �������� ���������� ������
        mov     esi,[lpReplace]
        mov     edi,edx
@@:
        lodsb
        or      al,al
        jz      loc_scan
        stosb
        inc     edx
        jmp     @b

loc_move_one_char:
        ; ����������� ���� ������
        mov     al,byte ptr [ecx]
        mov     byte ptr [edx],al
        inc     edx
        inc     ecx
        jmp     loc_scan

loc_end_replace:
        ; �������� ��������� 0 � ������
        mov     byte ptr [edx],0

        jmp     loc_ret
        
loc_copy_all:
        ; ������ ����������� �������� ������
        mov     esi,[lpSrc]
        mov     edi,[lpDst]
@@:
        lodsb
        stosb
        or      al,al
        jnz     @b

loc_ret:
        popa
        ret

 replace ENDP
 
 end start
