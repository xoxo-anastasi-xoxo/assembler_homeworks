.386 ;ассемблерная директива, говорящая ассемблеру использовать набор операций для процессора 80386
.model flat, stdcall ;задаем плоскую модель памяти и модель вызова
option casemap: none ;сделать метки "чувствительными" к регистрам

;-------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------
 
include /masm32/include/windows.inc
include /masm32/include/user32.inc ;контролирует пользовательский интерфейс
include /masm32/include/kernel32.inc ;API-функции, взаимодействующие с памятью и управляющие процессами

includelib /masm32/lib/user32.lib ; все инклюды не приходят к нам в готовом виде, а подгружаются из библиотек
includelib /masm32/lib/kernel32.lib ; эти инклюды показывают, что мы должны прилинковать к нашей проге

;-------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------

.data
szTitle1 db     'After Replace',0
szTitle2 db     'Original String',0

szStr1  db      'Stacey',0
szStr2  db      'Anastasia',0
buff1   db      'Hi, I am Stacey!',13,10,'Stacey is 19 years old.',13,10,'Stacey is from Orenburg.',0

buff2   dw      1000h ; место размером в 4 байта

replace PROTO lpSrc:DWORD, ; указатель на исходную строку
              lpPattern:DWORD, ; указатель на буфер для полученной строки
              lpReplace:DWORD, ; указатель на заменяемую подстроку
              lpDst:DWORD ; lpReplace - указатель на строку для замены

;-------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------

.code

 start:

        ; показать оригинальную строку
        invoke  MessageBox,0,offset buff1,offset szTitle2,MB_OK

        ; вызвать функцию замены
        invoke replace,offset buff1, offset szStr1, offset szStr2,offset buff2
        
        ; продемострировать результат
        invoke  MessageBox,0,offset buff2,offset szTitle1,MB_OK
        
        ; передать управдение windows
        invoke  ExitProcess,0



replace PROC lpSrc:DWORD,lpPattern:DWORD,lpReplace:DWORD,lpDst:DWORD

        pusha

        ; Указатель на буфер-приемник
        mov     edx,[lpDst]

        ; Исходная строка не пустая?
        mov     ecx,[lpSrc]
        cmp     byte ptr [ecx],0
        jz      loc_ret

        ; Заменяемая строка не пустая?
        mov     eax,[lpPattern]
        cmp     byte ptr [eax],0
        jz      loc_copy_all

loc_scan:
        mov     esi,ecx
        mov     edi,[lpPattern]

        ; Исходная строка закончилась?
        cmp     byte ptr [esi],0
        je      loc_end_replace

@@:
        ; Строки совпали с шаблоном?
        cmp     byte ptr [edi],0
        je      loc_move_replace

        ; Символ совпадает с
        lodsb

        cmp     al,byte ptr [edi]
        jne     loc_move_one_char

        inc     edi
        jmp     @b

loc_move_replace:
       
        mov     ecx,esi

        ; Записать заменяющую строку
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
        ; Скопировать один символ
        mov     al,byte ptr [ecx]
        mov     byte ptr [edx],al
        inc     edx
        inc     ecx
        jmp     loc_scan

loc_end_replace:
        ; Записать финальный 0 в строку
        mov     byte ptr [edx],0

        jmp     loc_ret
        
loc_copy_all:
        ; Просто скопировать исходную строку
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
