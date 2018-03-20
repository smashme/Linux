bits 16 ;good practice to identify if it's 16 bit program

; Credit to Lucus Darnell "Create your own operating System for the Internet of Things" (C) 2016
; Credit to Stackoverflow for helping me with the comments to understand the program better.
; Credit to sharetechnote.com for helping me with the comments to understand the program better.

;main start of bootloader program
start:
   mov ax,0x07c0 ; move 07c0 into ax
   add ax,0x20  ; adds 07c0h + 0x20h
   mov ss,ax    ;puts the start of the stack segment (ss) at segment number 07C0h + 20h
   mov sp,4096  ;stack segments starts 4096 bytes after the end of the bootloader.

   mov ax,0x07c0 ; move 07c0 into ax
   mov ds,ax   ; bootloader is loaded at the start of segment number 07C0h. The size of a     
               ; bootloader is 512 bytes and each segment is 16 bytes

   mov si,msg  ; move msg of 'hello world!' into source index register
   call print  ; perform print function below
   cli  ; clear interrupt flags
   hlt ;halt the machine

data:
   msg db 'hello world!',0  ; double byte data for hello world! with eol character

print:
   mov ah,0x0e   ; Teletype output: AH=0Eh

.printchar:
   lodsb   ;lodsb instruction loads the byte pointed to by the DS and SI registers
   cmp al,0 ; compare al register to zero (does it hold any characters?)
   je .done ; if no characters jump to .done (je=jump equal to zero)
   int 0x10 ; if there are, interrupt 10 (video output)
   jmp .printchar ; jump to printchar function

.done:
   ret  ; ret=pop previous instruction from the stack
   times 510-($-$$)db 0 ; fill out '0' in all the bytes from the current position to the 510th  
                        ; bytes
   dw 0xaa55  		; 
