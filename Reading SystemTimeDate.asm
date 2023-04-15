.model small
.data 
_time DB 'The current system time is: ' , '$'
newline DB 0Ah,0Dh,'$'  
mesaj2 DB 'Character not supported, try again$'
mesaj1 DB 'Enter a character (t-time/d-date) ESC for exit: $'
_date db 0ah,0dh,'Current Date : '
day db '  ' 
separator1 db '/'
month db '  '
separator2 db '/'
year db '    $' 

.code

main proc near
    
 mov ax, @data
mov ds,ax
Start:
lea dx, newline
mov ah,09h
int 21h
xor dx, dx

lea dx, mesaj1
mov ah, 09h
int 21h

mov ah,1h
int 21h
mov dl, al

cmp dl, 1Bh
je Sfirsit
cmp dl, 't'
jne Here
call TimeDisplay
jmp Start 
Here:
cmp dl, 'd'
jne Eroare
call DateDisplay
jmp Start
Eroare:
lea dx, newline
mov ah,09h
int 21h
xor dx, dx
lea dx, mesaj2
mov ah, 09h
int 21h
jmp Start
   
main endp








TimeDisplay proc near 

xor dx,dx
lea dx, newline
mov ah,09h
int 21h
xor dx, dx
lea dx, _time
mov ah, 09h
int 21h

mov ah, 00h
int 1Ah
mov al, cl


call display 


mov dl, ':'
mov ah, 02h
int 21h
mov ah,00h
int 1Ah
mov al, dh
cmp al,0h
je next1:
shr al,2
cmp al,24
jle next1
sub al,2
next1:
call display


mov dl,':'
mov ah,02h
int 21h
mov ah,00h
int 1Ah
xor ax,ax
mov al, dl
shr al,4   


call display
jmp Start
TimeDisplay ENDP
            

DateDisplay proc near

mov ah,2ah
    int 21h    
    
    push dx
    mov ax,cx
    mov si,offset year
    call Convert
    pop dx
    
    
     
    push dx      
    mov ah,00
    mov al,dh
    mov si,offset month
    call Convert
    pop dx
    
    push dx      
    mov ah,00
    mov al,dl
    mov si,offset day
    call Convert
    pop dx
    
    
    mov ah,09h
    mov dx,offset _date
    int 21h
    


jmp Start
DateDisplay ENDP


display proc near
    aam
    add ax, 3030h
    mov bx, ax
    mov dl, ah
    mov ah, 02h
    int 21h
    mov dl, bl
    mov ah, 02h
    int 21h
    ret
    display ENDP


Convert proc near     
    mov cx,00h
    mov bx,0ah
    loop1:
      mov dx,0
      div bx
      add dl,30h
      push dx
      inc cx
      cmp ax,0ah
      jge loop1
      add al,30h
      mov [si],al
    loop2:
      pop ax
      inc si
      mov [si],al
      loop loop2
      ret
      Convert ENDP


Sfirsit:
mov ah,4ch
int 21h
end





