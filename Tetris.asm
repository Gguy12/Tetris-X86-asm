IDEAL
MODEL small
STACK 100h

FILE_NAME_IN0  equ 'pac0.bmp'
MACRO PushAll
push ax
push bx
push cx
push dx
push si
ENDM
MACRO PopAll
pop si
pop dx
pop cx
pop bx
pop ax
ENDM

BMP_WIDTH = 10
BMP_HEIGHT = 10

DATASEG
; --------------------------
; Your variables here
; --------------------------
level db 0
Randomnes dw 100
piece db 'z'
flips db 0
ct db 0 ; do not touch
COP db 5
scorec dw 0
AFullLine db 0 ;0 = false 1 = true
holded db 'z'
index db 0
ScrLine 	db 320 dup (0)  ; One picture line read buffer

	;BMP File data
	FullPieceT  db 'T.bmp',0
	FullPieceI  db 'I.bmp',0
	FullPieceJ  db 'J.bmp',0
	FullPieceL  db 'L.bmp',0
	FullPieceZ  db 'Z.bmp',0
	FullPieceS  db 'S.bmp',0
	FullPieceO  db 'O.bmp',0
	SquareE		db 'PE.bmp',0
	SquareB   	db 'PB.bmp',0
	SquareG   	db 'PG.bmp',0
	SquareO   	db 'PO.bmp',0
	SquareP   	db 'PP.bmp',0
	SquareR   	db 'PR.bmp',0
	SquareT   	db 'PT.bmp',0
	SquareY   	db 'PY.bmp',0
	Next    	db 'NXT.bmp',0
	Logo    	db 'LOGO.bmp',0
	Score   	db 'SCORE.bmp',0
	PieceI   	db 'I.bmp',0
	PieceL   	db 'L.bmp',0
	PieceJ   	db 'J.bmp',0
	PieceT   	db 'T.bmp',0
	PieceZ   	db 'Z.bmp',0
	PieceO   	db 'O.bmp',0
	PieceS   	db 'S.bmp',0
	allpics 	db 'Tetpics.bmp',0
	Gamepic		db 'GAME.bmp',0
	
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	
	

	ErrorFile           db 0
			  
	
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?
	

				
			   
	; parameter
	matrix dw ?

RndCurrentPos dw ,0
backb db ? ;used as a register changed by xyNum
backb2 db ? ;used as a register changed by xyNum
Backx db ? ;used by CheckHighestYs
Backy db ? ;used by CheckHighestYs
HighestY db ? ;used by CheckHighestYs
backw dw ? ;used as a register
time dw 10 ;touch to change sleep time
px db ? ; PrintXY X
py db ? ;Printxy Y
looper db 200 
countx db 0
county db 0
seconds dw 0
color db 'O'
CanHold db 1 ; 0 = false, 1 = true 
frames db 0
Time2mv db 80
MvIf0 db 10
BoolPlace db 0 ;0 = false 1 = true
combo db 0
PosPiece db 'i','o','s','z','l','j','t'

RandomPieces db ?,?,?,?,?,?,?
rnd1 db ?
rnd2 db ?

;				 0  1  2  3  4  5  6  7  8  9
LineHighestY db 20,20,20,20,20,20,20,20,20,20 ;10,10,10,10,10,10,10,10,10,10
LineIsFull db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;0 = false 1 = true
;            0   1   2   3   4   5   6   7   8   9	
Board db 	'd','d','d','d','d','d','d','d','d','d' ; 0  x 110-210 y 0-200
	  db    'd','d','d','d','d','d','d','d','d','d' ; 1 ;color: o,g,b,t,y,p,r,b
	  db    'd','d','d','d','d','d','d','d','d','d' ; 2
	  db    'd','d','d','d','d','d','d','d','d','d' ; 3
	  db    'd','d','d','d','d','d','d','d','d','d' ; 4
	  db    'd','d','d','d','d','d','d','d','d','d' ; 5
	  db    'd','d','d','d','d','d','d','d','d','d' ; 6
	  db    'd','d','d','d','d','d','d','d','d','d' ; 7
	  db    'd','d','d','d','d','d','d','d','d','d' ; 8
	  db    'd','d','d','d','d','d','d','d','d','d' ; 9
	  db    'd','d','d','d','d','d','d','d','d','d' ; 10
	  db    'd','d','d','d','d','d','d','d','d','d' ; 11
	  db    'd','d','d','d','d','d','d','d','d','d' ; 12
	  db    'd','d','d','d','d','d','d','d','d','d' ; 13
	  db    'd','d','d','d','d','d','d','d','d','d' ; 14
	  db    'd','d','d','d','d','d','d','d','d','d' ; 15
	  db    'd','d','d','d','d','d','d','d','d','d' ; 16
	  db    'd','d','d','d','d','d','d','d','d','d' ; 17
	  db    'd','d','d','d','d','d','d','d','d','d' ; 18
	  db    'd','d','d','d','d','d','d','d','d','d' ; 19

holder dw 100 dup(?)


CODESEG
start:
	mov ax, @data
	mov ds, ax
	
; --------------------------
; Your code here
; --------------------------


;main
 mov ax,13h
int 10h

jmp cod
cod:
	;call UpdateHighestYs
	;call ShowYAndHighestY
	call RanArray
	call RandomPiece
	mov al,[piece]
	mov [holded],al
	call RandomPiece
	mov dx,offset Gamepic
	mov ax,0
	mov [BmpLeft],ax
	mov ax,0
	mov [BmpTop],ax
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	call OpenShowBmp
	mov al,200
	mov ah,5
	mov bl,'t'
	; call DrawFPiece
	; call stop
	call DrawBoard
	mov cx,200
	mov si,cx
	
loopa:
		dec si
		mov [board + si],'e'
		loop loopa
 call RandomPiece
 ; mov [piece],'l'
 ;mov [holded],'z'
 call AllDraw
 call DrawHold
Gameloop:
	; mov [piece],'i'
	call DrawScore
	Call Try2End
	dec [MvIf0] 
	jnz cont1
	mov al,[Time2mv]
	mov [MvIf0],al
	call UpdateHighestYs
	call Allmove
	call ALlIsPlace
	call UpdateIsFull
	call TryGoDown
	; call ShowAxDecimal
	cont1:
	call DrawBoard
	call sleep
	mov ah,1 ;getting input from keyboard
	int 16h
	jz Gameloop
	jnz Detected	
Detected:
	mov ah,0
	int 16h
	cmp ah,1
	je mid2
	cmp ah,48h
	je up
	cmp ah,4Bh
	je left
	cmp ah,4Dh
	je right
	cmp ah,50h
	je down
	cmp ah,39h
	je space
	cmp ah,2Eh
	je Hold
	cmp ah,1fH
	je Pauses
mid1:
; call CleanKeys
jmp Gameloop
space:
push cx
mov cx,20
smallloop:
call AllMove
loop Smallloop
pop cx
mov [ct],0
call AllIsPlace
call Sleep
jmp mid1
mid2:
jmp GameOver
up:
; call IsThereFullLine
; cmp [AFullLine],1
; je mid1
call AllUndraw
call IncFlips
call ResFlipCheck
call ALlDraw
jmp mid1
left:
; call IsThereFullLine
; cmp [AFullLine],1
; je mid1
call AllUnDraw
Call AllMoveLeft
jmp mid1
right:
; call IsThereFullLine
; cmp [AFullLine],1
; je mid1
Call AllUnDraw
Call AllMoveRight
jmp Gameloop
down:
call Allmove
jmp mid1
hold:
call HoldP
jmp mid1
pauses:
call Pausy
jmp mid1

GameOver:

exit:
	mov ax,2
	int 10h
	mov ax, 4c00h
	int 21h
;---------------------------
; Your Functions here
;---------------------------



proc LevelUp
	PushAll
	mov ax,[scorec]
	mov bl,50       
	div bl
	mov ah,50
	sub ah,al
	cmp ah,4
	ja @@leave
	mov [Time2mv],ah
@@leave:
	PopAll
	ret
endp LevelUp

proc IncFlips
	cmp [piece],'j' 
	je @@single
	cmp [piece],'l'
	je @@single
	cmp [piece],'t'
	je @@single
	add [flips],2
	jmp @@leave
@@single:
	inc [flips]
@@leave:
	ret
endp IncFlips

proc RanArray
	PushAll
	mov bx,7 ;copying PosPiece to RandomPieces
@@loop:
	dec bx
	mov dl,[PosPiece + bx]
	mov [RandomPieces + bx],dl
	cmp bx,0
	ja @@loop
	
	mov cx,[Randomnes] ;changes how random the arr is base on size
@@rndloop:
	mov bl,0
	mov bh,6
	call RandomByCs
	mov [rnd1],al
	mov bl,0
	mov bh,6
	call RandomByCs
	mov [rnd2],al
	mov bx,0
	mov bl,[rnd1]
	mov si,bx
	mov bx,0
	mov bl,[rnd2]
	mov dl,[RandomPieces + si]
	mov dh,[RandomPieces + bx]
	mov [RandomPieces + si],dh
	mov [RandomPieces + bx],dl
	loop @@rndloop
@@leave:
	PopAll
	ret
endp RanArray

proc DrawHold
	PushAll
	cmp [holded],'i'
	je @@ay
	cmp [holded],'j'
	je @@jy
	cmp [holded],'l'
	je @@el
	cmp [holded],'s'
	je @@es
	cmp [holded],'z'
	je @@zi
	cmp [holded],'o'
	je @@ho
	cmp [holded],'t'
	je @@tea
@@tea:
	mov dx,offset FullPieceT
	je @@cont
@@ay:
	mov dx,offset FullPieceI
	je @@cont
@@jy:
	mov dx,offset FullPieceJ
	je @@cont
@@el:
	mov dx,offset FullPieceL
	je @@cont
@@es:
	mov dx,offset FullPieceS
	je @@cont
@@zi:
	mov dx,offset FullPieceZ
	je @@cont
@@ho:
	mov dx,offset FullPieceO
	je @@cont
	
@@cont:
	mov ax,0
	mov [BmpLeft],ax
	mov ax,0
	mov [BmpTop],ax
	mov [BmpColSize],30
	mov [BmpRowSize],30
	call OpenShowBmp
	PopAll
	ret
endp DrawHold

proc DrawScore
	PushAll
	mov dh,19
	mov dl,8
	mov ah,2
	mov bh,0
	int 10h
	mov ax,[scorec]
	call ShowAxDecimal
	PopAll
	ret
endp DrawScore


proc CleanKeys
	push ax
@@loop:
	mov ah,1 ;getting input from keyboard
	int 16h
	jnz @@loop
	pop ax
	ret
endp CleanKeys

proc Pausy
	PushAll
@@loop:
	mov ah,1 ;getting input from keyboard
	int 16h
	jz @@loop
	jnz @@Detected	
@@Detected:
	mov ah,0
	int 16h
	cmp ah,1fH
	jne @@loop
@@leave:
	PopAll
	ret
endp Pausy

Proc Try2End
	PushAll
	mov bx,0
	jmp @@cod
@@stop:
	mov ax,2
	int 10h
	call stop
@@cod:
		cmp [board + bx],'x'
		je @@Stop
		inc bx
		cmp bx,10
		jb @@cod
	
	PopAll
	ret
endp Try2End

proc HoldP
	push ax
	cmp [CanHold],0
	je @@leave
	call AllUnDraw
	mov al,[piece]
	mov ah,[holded]
	mov [holded],al
	mov [piece],ah
	mov [cop],5
	call AllDraw
	call DrawHold
	mov [CanHold],0
@@leave:
	pop ax
	ret
endp HoldP

; Proc RandomPiece ;changes [piece] to random
	; PushAll
	; mov bl,0
	; mov bh,4
	; call RandomByCs
	; cmp al,1
	; jb @@oh
	; je @@ay
	; cmp al,3
	; jb @@ess
	; je @@zee
	; cmp al,5
	; jb @@el
	; jmp @@leave
; @@el:
	; mov [piece],'l'
	; jmp @@leave
; @@oh:
	; mov [piece],'o'
	; jmp @@leave
; @@ay:
	; mov [piece],'i'
	; jmp @@leave
; @@zee:
	; mov [piece],'z'
	; jmp @@leave
; @@ess:
	; mov [piece],'s'
	; jmp @@leave

; @@leave:
	; mov [CanHold],1
	; PopAll
	; ret
; endp RandomPiece

proc RandomPiece
	PushAll
	mov bx,0
	mov bl,[index]
	mov dl,[RandomPieces + bx]
	mov [piece],dl
	call Incdex
	mov [CanHold],1
@@leave:
	PopAll
	ret
endp RandomPiece

proc Incdex
	inc [index]
	cmp [index],7
	jae @@zero
	jmp @@leave
@@zero:
	call RanArray
	mov [index],0
@@leave:
	ret
endp Incdex

proc TryGoDown ;checks if theres a possible line that needs to go down
	PushAll
	call AllUnDraw
	call GetHighestFullLine
	mov ax,bx
	mov bl,10
	div bl
	xor bx,bx
	mov bl,al
	inc bl
	jmp @@loop
@@fully:
	call GetHighestFullLine
	call AllUnDraw
	call GoDown
	call AllDraw
	; call IsThereFullLine
	; cmp [AFullLine],0
	; je @@rleave
	add [combo],10 ;from here
	mov bl,10
	mov al,[combo]
	mul bl
	add [scorec],ax
	call LevelUp ;to here not the bug
	jmp @@leave
@@loop: ;not the bug
		dec bx
		cmp [LineIsFull + bx],1
		je @@fully
		cmp bx,0
		jne @@leave
@@rleave:
	; mov dx,0
	; call SetCurserPosition
	mov [combo],0
@@leave:
	call AllDraw
	PopAll
	ret
endp TryGoDown

proc DrawX ;draws all current pieces on board
	PushAll
	mov [px],al
	mov [py],bl
	jmp @@cod
	@@tchelet: ;tchelet
	mov dx,offset SquareT
	jmp @@cont
	@@cod:
	mov [backb2],al
	mov ah,bl
	call xyNum
	cmp [Board + si],'x'
	je @@tchelet
	jmp @@ExitProc
	@@cont:
	call PrintXY ;printable x = px printable y = py
	mov al,1
	mul [px] ;converting px to a word stored in ax
	mov [BmpLeft],ax
	mov al,1
	mul [py] ;converting py to a word stored in ax
	mov [BmpTop],ax
	mov [BmpColSize], 10
	mov [BmpRowSize],10
	call OpenShowBmp
	@@ExitProc:
	popall
	ret
endp DrawX

proc DrawAllx
	jmp @@cod
	@@equa:
	mov [countx],0
	inc [county]
	jmp @@contloop
	@@cod:
		mov [looper],200
		mov [countx],0
		mov [county],0 
		mov cx,200
		mov [backb2],200
	@@checkScreen:
			dec [looper]
			mov al,[countx]
			mov bl,[county]
			call DrawX
			inc [countx]
			cmp [countx],10
			je @@equa
	@@contloop:
			loop @@checkScreen
	ret
endp DrawAllx

proc EE2Dee ;changes empty space to spaces that needs to be deleted
	PushAll
	mov bx,200
@@loop:
	cmp [Board + bx],'e'
	jne @@contL
	mov [board + bx],'d'
@@contL:
	dec bx
	jnz @@loop
	PopAll
	ret
endp EE2Dee

proc IsThereFullLine ;AFullLine = 0, false =1, true
	PushAll
	call UpdateIsFull
	mov si,0
	jmp @@loop
@@false:
	mov [AFullLine],0 
	jmp @@leave
@@true:
	mov [AFullLine],1 
	jmp @@leave
@@loop:
	cmp [LineIsFull + si],1
	je @@true
	inc si
	cmp si,20
	jb @@loop
	jmp @@false
@@leave:
	PopAll
	ret
endp IsThereFullLine

proc GoDown
	PushAll
	call GetHighestFullLine
	mov si,-1
@@loop:
		inc si
		call LineDown
	cmp si,9
	jb @@loop
	mov si,190
	call EE2Dee
	Call DrawBoard
	call DrawAllx
	call UpdateIsFull
	
@@leave:
	PopAll
	ret
Endp GoDown

proc GetHighestFullLine ;ret bx = Lowest Y of fullLine
	Push ax
	mov bx,20
	call UpdateIsFull
	jmp @@loop
@@loop:
		dec bx
		cmp [LineIsFull + bx],1
		je @@leave
		cmp bx,0
		jne @@loop
mov bx,200
@@leave:
	mov al,10
	mul bl
	mov bx,ax
@@rlyleave:
	pop ax
	ret
Endp GetHighestFullLine

proc LineDown ;si = linenum bx = Highest FullLineNum
	PushAll
	mov [Board + si],'e'
@@loop:
		sub bx,10
		mov al,[board + si + bx]
		mov [board + si + bx + 10],al
		cmp bx,0
		jne @@loop
	PopAll
	ret
endp LineDown

proc DeleteLine ;si = Linenum * 10
	PushAll
	mov bx,10
@@loop:
	dec bx
	mov [board + si + bx],'d'
	cmp bx,0
	jne @@loop
	call DrawBoard
	PopAll
	ret
endp DeleteLine

proc UpdateIsFull
	PushAll
	mov si,200
@@loop:
	sub si,10
	call IsLineFull
	cmp si,0
	jne @@loop
	PopAll
	ret
Endp UpdateIsFull

proc IsLineFull ;si = Linenum * 10
	PushAll
	mov bx,0
	mov [backw],si
	jmp @@loop
@@false:
	mov ax,[backw]
	mov bl,10
	div bl
	mov ah,0
	mov bx,ax
	mov [LineIsFull + bx],0
	jmp @@exit
@@loop:
	cmp [Board + si + bx],'x'
	jne @@false
	inc bx
	cmp bx,9
	jbe @@loop
@@true:
	mov ax,[backw]
	mov bl,10
	div bl
	mov ah,0
	mov bx,ax
	mov [LineIsFull + bx],1
@@exit:
	PopAll
	ret
Endp IsLineFull


proc stop
	 mov ax, 4c00h ;tests end here
	 int 21h
	ret
endp stop

proc TestLine5Ys ;debug function that shows the highest y on line number 5
	push si
	push ax
	push bx
	push dx
	mov ah,2
	mov bh,0
	mov dh,7
	mov dl,16
	int 10h
	mov si,5
	call GetLineHighestY
	mov ax,0
	mov al,[backb]
	call ShowAxDecimal
	pop dx
	pop bx
	pop ax
	pop si
	ret
endp TestLine5Ys
proc UpdateHighestYs ;changes backb
	push si
	mov si,-1
	@@loop:
	inc si
	call GetLineHighestY
	push ax
	mov al,[backb]
	mov [LineHighestY + si],al
	pop ax
	cmp si,9
	jne @@loop
	pop si
	ret
endp UpdateHighestYs

proc GetLineHighestY ;si = linenum backb = highest y 
	push si
	push cx
	push ax
	jmp @@cod
	@@detected:
	mov [backb],cl
	jmp @@cont
	@@cod:
	mov [backb],19
	mov cx,20
	sub si,10
	@@loop:
	add si,10
	cmp [board + si],'x'
	je @@detected
	loop @@loop
	jmp @@exitproc
	@@cont:
	mov ax,si
	mov cl,10
	div cl
	mov [backb],al
	dec [backb]
	;mov cx,50
	; @@loopb:
	; call sleep
	; loop @@loopb
	@@exitproc:
	pop ax
	pop cx
	pop si
	; push ax
	; mov ah,0
	; mov al,[backb]
	; call ShowAxDecimal
	; call sleep
	; pop ax
	ret
endp GetLineHighestY

proc ResFlipCheck ;resets [flips] if they are higher then 3
	jmp @@cod
	@@zero:
	mov [flips],0
	jmp @@endproc
	@@cod:
	cmp [Flips],4
	jae @@zero
	@@endproc:
	ret
endp ResFlipCheck

proc GetXY ;ax = location
	mov [backb],10
	div [backb]
	mov [backb],al
	mov al,ah
	mov ah,[backb]
	ret 
endp GetXY ;al = x ah = y 

proc Undraws 
	jmp @@cod
	@@empty:
	mov dx,offset SquareE
	jmp @@cont
	@@cod:
	cmp [Board + bx],'d'
	je @@empty
	jmp @@ExitProc
	@@cont:
	mov ax,bx
	call GetXY
	mov [px],al
	mov [py],ah
	call PrintXY ;printable x = px printable y = py
	mov al,1
	mul [px] ;converting px to a word stored in ax
	mov [BmpLeft],ax
	mov al,1
	mul [py] ;converting py to a word stored in ax
	mov [BmpTop],ax
	mov [BmpColSize], 10
	mov [BmpRowSize],10
	call OpenShowBmp
	@@ExitProc:
	ret
endp Undraws

proc Sleep ;sleeps [time] miliseconds and count seconds with var [seconds]

		jmp @@str
	@@seci:
		mov [ct],0
		inc [seconds]
		jmp @@stop
	@@str:
		push cx
		mov cx,[time]
	@@Self1:
		push cx
		mov cx,3000
	@@Self2:
		loop @@Self2
		pop cx
		loop @@Self1
		pop cx
	inc [ct]
	cmp [ct],254
	jae @@seci
	@@stop:	
	ret
Endp Sleep

proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LOFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   ;mov dl, ','
       ;mov ah, 2h
	   ;int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal


; Description  : get RND between any bl and bh includs (max 0 -255)
; Onput        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Onfo:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs
; Description  : get RND between any bl and bh includs (max 0 - 65535)
; Onput        : 1. BX = min (from 0) , DX, Max (till 64k -1)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        AX - rnd num from bx to dx  (example 50 - 1550)
; More Onfo:
; 	BX  must be less than DX 
; 	in order to get good random value again and again the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCsWord
    push es
	push si
	push di
 
	
	mov ax, 40h
	mov	es, ax
	
	sub dx,bx  ; we will make rnd number between 0 to the delta between bx and dx
			   ; Now dx holds only the delta
	cmp dx,0
	jz @@ExitP
	
	push bx
	
	mov di, [word RndCurrentPos]
	call MakeMaskWord ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
@@RandLoop: ;  generate random number 
	mov bx, [es:06ch] ; read timer counter
	
	mov ax, [word cs:di] ; read one word from memory (from semi random bytes at cs)
	xor ax, bx ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	inc di
	cmp di,(EndOfCsLbl - start - 2)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	
	cmp ax,dx    ;do again if  above the delta
	ja @@RandLoop
	pop bx
	add ax,bx  ; add the lower limit to the rnd num
		 
@@ExitP:
	
	pop di
	pop si
	pop es
	ret
endp RandomByCsWord
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask


Proc MakeMaskWord    
    push dx
	
	mov si,1
    
@@again:
	shr dx,1
	cmp dx,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop dx
	ret
endp  MakeMaskWord

proc OpenShowBmp near
	
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	 
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

; input [FileHandle]
proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile


; Read and skip first 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader

; Read BMP file color palette, 256 colors * 4 bytes (400h)
; 4 bytes for each color BGR (3 bytes) + null(transparency byte not supported)	
proc ReadBmpPalette near 		
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the pallete colors
; video ports are 3C8h for number of first color (usually Black, default)
; and 3C9h for all rest colors of the Pallete, one after the other
; in the bmp file pallete - each color is defined by BGR = Blue, Green and Red
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.(4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette

 
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	
	pop dx
	pop cx
	 
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP 

; in dx how many cols 
; in cx how many rows
; in matrix - the bytes
; in di start byte in screen (0 64000 -1)

proc putMatrixOnScreen
	push es
	push ax
	push si
	
	mov ax, 0A000h
	mov es, ax
	cld ; for movsb direction si --> di
	
	
	mov si,[matrix]
	
NextRow:	
	push cx
	
	mov cx, dx
	rep movsb ; Copy whole line to the screen, si and di advances in movsb
	sub di,dx ; returns back to the begining of the line 
	add di, 320 ; go down one line by adding 320
	
	
	pop cx
	loop NextRow
	
		
	pop si
	pop ax
	pop es
    ret
endp putMatrixOnScreen


; delay of 100 mSec
proc DoDelay
	push cx
	mov cx, 100
	Delay1:
		push cx
		mov cx, 6000
		Delay2:
			loop Delay2
		pop cx
	loop Delay1
	pop cx
	ret
endp 

proc xyNum ;al = x (0,9) ah = y (0,19) si,al = location ;ax backb and backb2 are changed
	mov [backb],al ;backb 
	mov al,ah ;backb = x al = y 
	mov [backb2],10
	mul [backb2] ;ax = 10*y 
	add al,[backb]
	mov si,ax
	ret
Endp xyNum ;returns the number in the array to use (si = location)

proc PrintXY ;takes PX and PY from x,y that fit in the array and changes them to printable cords(x*10 + 110,y*10) changes ax
	mov al,10
	mul [px]
	add al,110
	mov [px],al
	mov al,10
	mul [py]
	mov [py],al
	ret
endp PrintXY

proc DrawBoard
	jmp @@cod
	@@equa:
	mov [countx],0
	inc [county]
	jmp @@contloop
	@@cod:
		mov [looper],200
		mov [countx],0
		mov [county],0 
		mov cx,200
		mov [backb2],200
	@@checkScreen:
			dec [looper]
			mov al,[countx]
			mov bl,[county]
			call DrawPiece
			inc [countx]
			cmp [countx],10
			je @@equa
	@@contloop:
			loop @@checkScreen
	ret
endp DrawBoard

proc DrawPiece ;the function draws the piece on Board[al,bl] acording to its color 
	push ax
	push bx
	push si
	push dx
	mov [px],al
	mov [py],bl
	jmp @@cod
	@@empty:
	mov dx,offset SquareE
	mov [Board + si],'e'
	jmp @@cont
	@@orange: ;orange
	mov dx,offset SquareO
	jmp @@cont
	@@blue: ;blue
	mov dx,offset SquareB
	jmp @@cont
	@@green: ;green
	mov dx,offset SquareG
	jmp @@cont
	@@purple: ;purple
	mov dx,offset SquareP
	jmp @@cont
	@@red: ;red
	mov dx,offset SquareR
	jmp @@cont
	@@tchelet: ;tchelet
	mov dx,offset SquareT
	jmp @@cont
	@@yellow: ;yellow 
	mov dx,offset SquareY
	jmp @@cont
	@@cod:
	mov [backb2],al
	mov ah,bl
	call xyNum
	cmp [Board + si],'d'
	je @@empty
	cmp [Board + si],'b'
	je @@blue
	cmp [Board + si],'g'
	je @@green
	cmp [Board + si],'o'
	je @@orange
	cmp [Board + si],'p'
	je @@purple
	cmp [Board + si],'r'
	je @@red
	cmp [Board + si],'t'
	je @@tchelet
	cmp [Board + si],'y'
	je @@yellow
	jmp @@ExitProc
	@@cont:
	call PrintXY ;printable x = px printable y = py
	mov al,1
	mul [px] ;converting px to a word stored in ax
	mov [BmpLeft],ax
	mov al,1
	mul [py] ;converting py to a word stored in ax
	mov [BmpTop],ax
	mov [BmpColSize], 10
	mov [BmpRowSize],10
	call OpenShowBmp
	@@ExitProc:
	pop dx
	pop si
	pop bx
	pop ax
	ret
endp DrawPiece

proc SetCurserPosition ;dl = x dh = y 
	push ax
	push bx
	mov bl,dh
	mov dh,dl
	mov dl,dl
	mov ah,2
	mov bh,0
	int 10h
	pop bx
	pop ax
	ret
endp SetCurserPosition

proc ShowYAndHighestY ;debug function
	PushAll
	mov dx,0
	call SetCurserPosition
	mov ax,0
	mov si,190
	call IsLineFull
	mov al,[LineHighestY + 19]
	call ShowAxDecimal
	PopAll
	ret
endp ShowYAndHighestY


;--------------------------
; All Pieces Functions here:
;--------------------------
;Gathering functions that calls the right function based on [piece]

;body of an All Function
	; cmp [piece],'o'
	; je @@ooo
	; cmp [piece],'t'
	; je @@ttt
	; cmp [piece],'j'
	; je @@jjj
	; cmp [piece],'l'
	; je @@lll
	; cmp [piece],'s'
	; je @@sss
	; cmp [piece],'z'
	; je @@zzz
	; cmp [piece],'i'
	; je @@iii
	; jmp @@leave
; @@ooo:

; jmp @@leave
; @@ttt:
; call T

; jmp @@leave
; @@jjj:

; jmp @@leave
; @@lll:

; jmp @@leave
; @@sss:

; jmp @@leave
; @@zzz:

; jmp @@leave
; @@iii:

; jmp @@leave
; @@leave:
	; ret
proc AllDraw
	cmp [piece],'o'
	je @@ooo
	cmp [piece],'t'
	je @@ttt
	cmp [piece],'j'
	je @@jjj
	cmp [piece],'l'
	je @@lll
	cmp [piece],'s'
	je @@sss
	cmp [piece],'z'
	je @@zzz
	cmp [piece],'i'
	je @@iii
	jmp @@leave
@@ooo:
call ODraw
jmp @@leave
@@ttt:
call TDraw
jmp @@leave
@@jjj:
call JDraw
jmp @@leave
@@lll:
call LDraw
jmp @@leave
@@sss:
call SDraw
jmp @@leave
@@zzz:
call ZDraw
jmp @@leave
@@iii:
Call IDraw
jmp @@leave
@@leave:
	ret
endp AllDraw

proc AllUnDraw
	cmp [piece],'o'
	je @@ooo
	cmp [piece],'t'
	je @@ttt
	cmp [piece],'j'
	je @@jjj
	cmp [piece],'l'
	je @@lll
	cmp [piece],'s'
	je @@sss
	cmp [piece],'z'
	je @@zzz
	cmp [piece],'i'
	je @@iii
	jmp @@leave
@@ooo:
call OUnDraw
jmp @@leave
@@ttt:
call TUnDraw
jmp @@leave
@@jjj:
call JUnDraw
jmp @@leave
@@lll:
call LUnDraw
jmp @@leave
@@sss:
call SUnDraw
jmp @@leave
@@zzz:
call ZUnDraw
jmp @@leave
@@iii:
call IUnDraw
jmp @@leave
@@leave:
	ret
endp AllUnDraw

proc AllMove
	cmp [piece],'o'
	je @@ooo
	cmp [piece],'t'
	je @@ttt
	cmp [piece],'j'
	je @@jjj
	cmp [piece],'l'
	je @@lll
	cmp [piece],'s'
	je @@sss
	cmp [piece],'z'
	je @@zzz
	cmp [piece],'i'
	je @@iii
	jmp @@leave
@@ooo:
call Omove
jmp @@leave
@@ttt:
call TMove
jmp @@leave
@@jjj:
call JMove
jmp @@leave
@@lll:
call LMove
jmp @@leave
@@sss:
call SMove
jmp @@leave
@@zzz:
call ZMove
jmp @@leave
@@iii:
call IMove
jmp @@leave
@@leave:
	ret
endp AllMove

proc AllIsPlace
	cmp [piece],'o'
	je @@ooo
	cmp [piece],'t'
	je @@ttt
	cmp [piece],'j'
	je @@jjj
	cmp [piece],'l'
	je @@lll
	cmp [piece],'s'
	je @@sss
	cmp [piece],'z'
	je @@zzz
	cmp [piece],'i'
	je @@iii
	jmp @@leave
@@ooo:
call OIsPlace
jmp @@leave
@@ttt:
call TIsPlace
jmp @@leave
@@jjj:
call JIsPlace
jmp @@leave
@@lll:
call LIsPlace
jmp @@leave
@@sss:
call SIsPlace
jmp @@leave
@@zzz:
call ZIsPlace
jmp @@leave
@@iii:
call IIsPlace
jmp @@leave
@@leave:
	ret
endp AllIsPlace

Proc AllMoveRight
	cmp [piece],'o'
	je @@ooo
	cmp [piece],'t'
	je @@ttt
	cmp [piece],'j'
	je @@jjj
	cmp [piece],'l'
	je @@lll
	cmp [piece],'s'
	je @@sss
	cmp [piece],'z'
	je @@zzz
	cmp [piece],'i'
	je @@iii
	jmp @@leave
@@ooo:
call OMoveRight
jmp @@leave
@@ttt:
call TMoveRight
jmp @@leave
@@jjj:
call JMoveRight
jmp @@leave
@@lll:
call LMoveRight
jmp @@leave
@@sss:
call SMoveRight
jmp @@leave
@@zzz:
call ZMoveRight
jmp @@leave
@@iii:
call IMoveRight
jmp @@leave
@@leave:
	ret
endp AllMoveRight

proc AllMoveLeft
	cmp [piece],'o'
	je @@ooo
	cmp [piece],'t'
	je @@ttt
	cmp [piece],'j'
	je @@jjj
	cmp [piece],'l'
	je @@lll
	cmp [piece],'s'
	je @@sss
	cmp [piece],'z'
	je @@zzz
	cmp [piece],'i'
	je @@iii
	jmp @@leave
@@ooo:
call OMoveLeft
jmp @@leave
@@ttt:
call TMoveLeft
jmp @@leave
@@jjj:
call JMoveLeft
jmp @@leave
@@lll:
call LMoveLeft
jmp @@leave
@@sss:
call SMoveLeft
jmp @@leave
@@zzz:
call ZMoveLeft
jmp @@leave
@@iii:
call IMoveLeft
jmp @@leave
@@leave:
	ret
endp AllMoveLeft


;------------------------
; T Piece Functions here:
;------------------------

proc TDraw
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call T0Draw
jmp @@leave
@@one:
call T1Draw
jmp @@leave
@@two:
call T2Draw
jmp @@leave
@@three:
call T3Draw
jmp @@leave
@@leave:
	ret
endp TDraw

proc TUnDraw
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call T0UnDraw
jmp @@leave
@@one:
call T1UnDraw
jmp @@leave
@@two:
call T2UnDraw
jmp @@leave
@@three:
call T3UnDraw
jmp @@leave
@@leave:
	ret
endp TUnDraw


proc TMove
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call T0Move
jmp @@leave
@@one:
call T1Move
jmp @@leave
@@two:
call T2Move
jmp @@leave
@@three:
call T3Move
jmp @@leave
@@leave:
	ret
endp TMove

proc TIsPlace
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call T0IsPlace
jmp @@leave
@@one:
call T1IsPlace
jmp @@leave
@@two:
call T2IsPlace
jmp @@leave
@@three:
call T3IsPlace
jmp @@leave
@@leave:
	ret
endp TIsPlace

proc TMoveRight
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call T0MoveRight
jmp @@leave
@@one:
call T1MoveRight
jmp @@leave
@@two:
call T2MoveRight
jmp @@leave
@@three:
call T3MoveRight
jmp @@leave
@@leave:
	ret
endp TMoveRight

proc TMoveLeft
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call T0MoveLeft
jmp @@leave
@@one:
call T1MoveLeft
jmp @@leave
@@two:
call T2MoveLeft
jmp @@leave
@@three:
call T3MoveLeft
jmp @@leave
@@leave:
	ret
endp TMoveleft

proc T0Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'p'
	add bx,1
	mov [board + bx],'p'
	add bx,10
	mov [board + bx],'p'
	sub bx,9
	mov [board + bx],'p'
	PopAll
	ret
endp T0Draw

proc T1Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'p'
	sub bx,10
	mov [board + bx],'p'
	dec bx
	mov [board + bx],'p'
	sub bx,9
	mov [board + bx],'p'
	PopAll
	ret
endp T1Draw

proc T2Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'p'
	add bx,1
	mov [board + bx],'p'
	sub bx,10
	mov [board + bx],'p'
	add bx,11
	mov [board + bx],'p'
	PopAll
	ret
endp T2Draw

proc T3Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'p'
	sub bx,10
	mov [board + bx],'p'
	add bx,1
	mov [board + bx],'p'
	sub bx,11
	mov [board + bx],'p'
	PopAll
	ret
endp T3Draw

proc T0UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	add bx,10
	mov [board + bx],'d'
	sub bx,9
	mov [board + bx],'d'
	PopAll
	ret
endp T0UnDraw

proc T1UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	dec bx
	mov [board + bx],'d'
	sub bx,9
	mov [board + bx],'d'
	PopAll
	ret
endp T1UnDraw

proc T2UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	add bx,11
	mov [board + bx],'d'
	PopAll
	ret
endp T2UnDraw

proc T3UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	sub bx,11
	mov [board + bx],'d'
	PopAll
	ret
endp T3UnDraw

proc T0Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	add al,11
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call T0Undraw ;moving the piece
	add [cop],10
	call T0Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp T0Move

proc T1Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	sub al,11
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call T1Undraw ;moving the piece
	add [cop],10
	call T1Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp T1Move

proc T2Move
	push ax
	push bx
	push dx
	;mov ax,0
	;mov al,[LineHighestY + 5]
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	add al,1
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	add al,2
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call T2Undraw ;moving the piece
	add [cop],10
	call T2Draw
	jmp @@exitproc
@@exitproc:
	mov [backb],dh
	pop dx
	pop bx
	pop ax
	ret
endp T2Move

proc T3Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call T3Undraw ;moving the piece
	add [cop],10
	call T3Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp T3Move

proc T0IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	sub bx,9
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	add al,11
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	sub bx,9
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	add al,2
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	sub bx,9
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp T0IsPlace

proc T1IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	sub bx,9
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,11
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	sub bx,9
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp T1IsPlace

proc T2IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,11
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	add al,1
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,11
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	add al,2
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,11
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp T2IsPlace

proc T3IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,11
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,11
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@leave:
	call DrawAllx
	PopAll
	ret
endp T3IsPlace

proc T0MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	inc bx
	inc bx
	cmp [board + bx],'x'
	je @@leave
	add bx,9
	cmp [board + bx],'x'
	je @@leave
	sub bx,11
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,8
	je @@leave
	call T0UnDraw
	inc [cop]
	Call T0Draw
@@leave:
	PopAll
	ret
endp T0MoveRight

proc T1MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	add bl,1
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call T1UnDraw
	inc [cop]
	Call T1Draw
@@leave:
	PopAll
	ret
endp T1MoveRight

proc T2MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call T2UnDraw
	inc [cop]
	Call T2Draw
@@leave:
	PopAll
	ret
endp T2MoveRight

proc T2MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call T2UnDraw
	dec [cop]
	Call T2Draw
@@leave:
	PopAll
	ret
endp T2MoveLeft

proc T3MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	add bx,1
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	sub bx,11
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,7
	je @@leave
	call T3UnDraw
	inc [cop]
	Call T3Draw
@@leave:
	PopAll
	ret
endp T3MoveRight

proc T3MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call T3UnDraw
	dec [cop]
	Call T3Draw
@@leave:
	PopAll
	ret
endp T3MoveLeft


proc T1MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,11
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,1
	je @@leave
	call T1UnDraw
	dec [cop]
	Call T1Draw
@@leave:
	PopAll
	ret
endp T1MoveLeft

proc T0MoveLeft 
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	add bx,11
	cmp [board + bx],'x'
	je @@leave
	sub bx,19
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call T0UnDraw
	dec [cop]
	Call T0Draw
@@leave:
	PopAll
	ret
endp T0MoveLeft
;Try2place X
;Draw Works
;Undraw Works
;Move Works
;GetLowY Works
;------------------------
; O Piece Functions here:
;------------------------

;OTry2place
proc ODraw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'y'
	inc bx
	mov [board + bx],'y'
	sub bx,10
	mov [board + bx],'y'
	dec bx
	mov [board + bx],'y'
	ret
endp ODraw

proc OUnDraw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	dec bx
	mov [board + bx],'d'
	ret
endp OUnDraw

proc Omove
	push ax
	push bx
	push dx
	;mov ax,0
	;mov al,[LineHighestY + 5]


	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call OUndraw ;moving the piece
	add [cop],10
	call ODraw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	pop dx
	pop bx
	pop ax
	ret
endp Omove

proc OIsPlace
	PushAll
	jmp @@cod
@@leave2:
	call Stop
@@cod:
	cmp [ct],60
	jae @@toleave
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
@@true:
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	jmp @@cont
@@toleave:
	jmp @@exitproc
	; call stop
	@@cont:
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	inc bx
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@exitproc
	call ODraw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	;call ShowYAndHighestY
	@@exitproc:
	Call DrawAllx
	PopAll
	ret
endp OIsPlace
proc OMoveRight
	PushAll
	call OUnDraw
	mov bx,0
	mov bl,[cop]
	add bl,2
	cmp [board + bx],'x'
	je @@ExitProc
	mov bx,0
	mov bl,[cop]
	sub bl,8
	cmp [board + bx],'x'
	je @@ExitProc
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,8
	je @@exitproc
	inc [cop]
@@exitproc:
	call ODraw
	PopAll
	ret
Endp OMoveRight

proc OMoveLeft
	PushAll
	call OUnDraw
	mov bx,0
	mov bl,[cop]
	sub bl,1
	cmp [board + bx],'x'
	je @@ExitProc
	mov bx,0
	mov bl,[cop]
	sub bl,11
	cmp [board + bx],'x'
	je @@ExitProc
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@exitproc
	dec [cop]
@@exitproc:
	call ODraw
	PopAll
	ret
Endp OMoveLeft
;------------------------
; Z Piece Functions here:
;------------------------
proc Z0Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'r'
	sub bx,1
	mov [board + bx],'r'
	sub bx,10
	mov [board + bx],'r'
	sub bx,1
	mov [board + bx],'r'
	PopAll
	ret
endp Z0Draw

proc Z1Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'r'
	sub bx,10
	mov [board + bx],'r'
	inc bx
	mov [board + bx],'r'
	sub bx,10
	mov [board + bx],'r'
	PopAll
	ret
endp Z1Draw

proc ZDraw
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call Z0Draw
	jmp @@leave
@@Horizontal:
	call Z1Draw
@@leave:
	PopAll
	ret
endp ZDraw

proc Z0UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,1
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	sub bx,1
	mov [board + bx],'d'
	PopAll
	ret
endp Z0UnDraw

proc Z1UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
		PopAll
	ret
endp Z1UnDraw

proc ZUnDraw
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call Z0UnDraw
	jmp @@leave
@@Horizontal:
	call Z1UnDraw
@@leave:
	PopAll
	ret
endp ZUnDraw

proc Z0Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	dec al
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	sub al,12
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	call Z0UnDraw
	add [cop],10
	call Z0Draw
@@leave:
	PopAll
	ret
endp Z0Move

proc Z1Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	call Z1UnDraw
	add [cop],10
	call Z1Draw
@@leave:
	PopAll
	ret
endp Z1Move


proc ZMove
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call Z0Move
	jmp @@leave
@@Horizontal:
	call Z1Move
@@leave:
	PopAll
	ret
Endp ZMove

proc Z0IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	dec al
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,12
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp Z0IsPlace

proc Z1IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@leave:
	call DrawAllx
	PopAll
	ret
endp Z1IsPlace

proc ZIsPlace
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call Z0IsPlace
	jmp @@leave
@@Horizontal:
	call Z1IsPlace
@@leave:
	PopAll
	ret
endp ZIsPlace

proc Z0MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,14
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call Z0UnDraw
	inc [cop]
	Call Z0Draw
@@leave:
	PopAll
	ret
endp Z0MoveRight

proc Z1MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,8
	je @@leave
	call Z1UnDraw
	inc [cop]
	Call Z1Draw
@@leave:
	PopAll
	ret
endp Z1MoveRight

proc Z0MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,6
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,2
	je @@leave
	call Z0UnDraw
	dec [cop]
	Call Z0Draw
@@leave:
	PopAll
	ret
endp Z0MoveLeft

proc Z1MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call Z1UnDraw
	dec [cop]
	Call Z1Draw
@@leave:
	PopAll
	ret
endp Z1MoveLeft

proc ZMoveRight
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call Z0MoveRight
	jmp @@leave
@@Horizontal:
	Call Z1MoveRight
@@leave:
	PopAll
	ret
endp ZMoveRight

proc ZMoveLeft
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call Z0MoveLeft
	jmp @@leave
@@Horizontal:
	call Z1MoveLeft
@@leave:
	PopAll
	ret
endp ZMoveLeft
;Try2place
;Draw
;Undraw
;Move
;OsPlace
;------------------------
; S Piece Functions here:
;------------------------
proc S0Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'g'
	add bx,1
	mov [board + bx],'g'
	sub bx,10
	mov [board + bx],'g'
	add bx,1
	mov [board + bx],'g'
	PopAll
	ret
endp S0Draw

proc S1Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'g'
	sub bx,10
	mov [board + bx],'g'
	dec bx
	mov [board + bx],'g'
	sub bx,10
	mov [board + bx],'g'
	PopAll
	ret
endp S1Draw

proc SDraw
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call S0Draw
	jmp @@leave
@@Horizontal:
	call S1Draw
@@leave:
	PopAll
	ret
endp SDraw

proc S0UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	PopAll
	ret
endp S0UnDraw

proc S1UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	dec bx
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp S1UnDraw

proc SUnDraw
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call S0UnDraw
	jmp @@leave
@@Horizontal:
	call S1UnDraw
@@leave:
	PopAll
	ret
endp SUnDraw

proc S0Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	sub al,8
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	call S0UnDraw
	add [cop],10
	call S0Draw
@@leave:
	PopAll
	ret
endp S0Move

proc S1Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	sub al,11
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	call S1UnDraw
	add [cop],10
	call S1Draw
@@leave:
	PopAll
	ret
endp S1Move


proc SMove
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call S0Move
	jmp @@leave
@@Horizontal:
	call S1Move
@@leave:
	PopAll
	ret
Endp SMove

proc S0IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,8
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp S0IsPlace

proc S1IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,11
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@leave:
	call DrawAllx
	PopAll
	ret
endp S1IsPlace

proc SIsPlace
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call S0IsPlace
	jmp @@leave
@@Horizontal:
	call S1IsPlace
@@leave:
	PopAll
	ret
endp SIsPlace

proc S0MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,7
	je @@leave
	call S0UnDraw
	inc [cop]
	Call S0Draw
@@leave:
	PopAll
	ret
endp S0MoveRight

proc S1MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,11
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call S1UnDraw
	inc [cop]
	Call S1Draw
@@leave:
	PopAll
	ret
endp S1MoveRight

proc S0MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call S0UnDraw
	dec [cop]
	Call S0Draw
@@leave:
	PopAll
	ret
endp S0MoveLeft

proc S1MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,11
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,1
	je @@leave
	call S1UnDraw
	dec [cop]
	Call S1Draw
@@leave:
	PopAll
	ret
endp S1MoveLeft

proc SMoveRight
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call S0MoveRight
	jmp @@leave
@@Horizontal:
	Call S1MoveRight
@@leave:
	PopAll
	ret
endp SMoveRight

proc SMoveLeft
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call S0MoveLeft
	jmp @@leave
@@Horizontal:
	call S1MoveLeft
@@leave:
	PopAll
	ret
endp SMoveLeft
;Try2place
;Draw
;Undraw
;Move
;Move Sides
;------------------------
; L Piece Functions here:
;------------------------
proc LDraw
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call L0Draw
jmp @@leave
@@one:
call L1Draw
jmp @@leave
@@two:
call L2Draw
jmp @@leave
@@three:
call L3Draw
jmp @@leave
@@leave:
	ret
endp LDraw

proc LUnDraw
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call L0UnDraw
jmp @@leave
@@one:
call L1UnDraw
jmp @@leave
@@two:
call L2UnDraw
jmp @@leave
@@three:
call L3UnDraw
jmp @@leave
@@leave:
	ret
endp LUnDraw


proc LMove
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call L0Move
jmp @@leave
@@one:
call L1Move
jmp @@leave
@@two:
call L2Move
jmp @@leave
@@three:
call L3Move
jmp @@leave
@@leave:
	ret
endp LMove

proc LIsPlace
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call L0IsPlace
jmp @@leave
@@one:
call L1IsPlace
jmp @@leave
@@two:
call L2IsPlace
jmp @@leave
@@three:
call L3IsPlace
jmp @@leave
@@leave:
	ret
endp LIsPlace

proc LMoveRight
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call L0MoveRight
jmp @@leave
@@one:
call L1MoveRight
jmp @@leave
@@two:
call L2MoveRight
jmp @@leave
@@three:
call L3MoveRight
jmp @@leave
@@leave:
	ret
endp LMoveRight

proc LMoveLeft
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call L0MoveLeft
jmp @@leave
@@one:
call L1MoveLeft
jmp @@leave
@@two:
call L2MoveLeft
jmp @@leave
@@three:
call L3MoveLeft
jmp @@leave
@@leave:
	ret
endp LMoveleft

proc L0Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'o'
	add bx,1
	mov [board + bx],'o'
	sub bx,11
	mov [board + bx],'o'
	sub bx,10
	mov [board + bx],'o'
	PopAll
	ret
endp L0Draw

proc L1Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'o'
	sub bx,10
	mov [board + bx],'o'
	inc bx
	mov [board + bx],'o'
	inc bx
	mov [board + bx],'o'
	PopAll
	ret
endp L1Draw

proc L2Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'o'
	sub bx,10
	mov [board + bx],'o'
	sub bx,10
	mov [board + bx],'o'
	dec bx
	mov [board + bx],'o'
	PopAll
	ret
endp L2Draw

proc L3Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'o'
	inc bx
	mov [board + bx],'o'
	add bx,1
	mov [board + bx],'o'
	sub bx,10
	mov [board + bx],'o'
	PopAll
	ret
endp L3Draw

proc L0UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	sub bx,11
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp L0UnDraw

proc L1UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	PopAll
	ret
endp L1UnDraw

proc L2UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	dec bx
	mov [board + bx],'d'
	PopAll
	ret
endp L2UnDraw

proc L3UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp L3UnDraw

proc L0Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call L0Undraw ;moving the piece
	add [cop],10
	call L0Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp L0Move

proc L1Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	sub al,8
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call L1Undraw ;moving the piece
	add [cop],10
	call L1Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp L1Move

proc L2Move
	push ax
	push bx
	push dx
	;mov ax,0
	;mov al,[LineHighestY + 5]
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	sub al,21
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call L2Undraw ;moving the piece
	add [cop],10
	call L2Draw
	jmp @@exitproc
@@exitproc:
	mov [backb],dh
	pop dx
	pop bx
	pop ax
	ret
endp L2Move

proc L3Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call L3Undraw ;moving the piece
	add [cop],10
	call L3Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp L3Move

proc L0IsPlace
	PushAll
	jmp @@cod
@@leave2:
	call Stop
@@cod:
	cmp [ct],60
	jae @@toleave
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
@@true:
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,11
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	jmp @@cont
@@toleave:
	jmp @@exitproc
	; call stop
	@@cont:
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	inc bx
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@exitproc
	call LDraw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,11
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	;call ShowYAndHighestY
	@@exitproc:
	Call DrawAllx
	PopAll
	ret
endp L0IsPlace

proc L1IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	sub al,9
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	sub al,8
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp L1IsPlace

proc L2IsPlace
	PushAll
	call UpdateHighestYs
	jmp @@cod
@@leave2:
	call Stop
@@cod:
	cmp [ct],60
	jae @@toleave
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
@@true:
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	jmp @@exitproc
@@toleave:
	jmp @@exitproc
	; call stop
	@@cont:
	mov ax,0
	mov al,[cop]
	sub al,21
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@exitproc
	call L2Draw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	dec bx
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	;call ShowYAndHighestY
	@@exitproc:
	Call DrawAllx
	PopAll
	ret
endp L2IsPlace

proc L3IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	inc al
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp L3IsPlace

proc L0MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,13
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,8
	je @@leave
	call L0UnDraw
	inc [cop]
	Call L0Draw
@@leave:
	PopAll
	ret
endp L0MoveRight

proc L1MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,8
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,7
	je @@leave
	call L1UnDraw
	inc [cop]
	Call L1Draw
@@leave:
	PopAll
	ret
endp L1MoveRight

proc L2MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call L2UnDraw
	inc [cop]
	Call L2Draw
@@leave:
	PopAll
	ret
endp L2MoveRight

proc L2MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,11
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,1
	je @@leave
	call L2UnDraw
	dec [cop]
	Call L2Draw
@@leave:
	PopAll
	ret
endp L2MoveLeft

proc L3MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	add bx,3
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,7
	je @@leave
	call L3UnDraw
	inc [cop]
	Call L3Draw
@@leave:
	PopAll
	ret
endp L3MoveRight

proc L3MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,8
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call L3UnDraw
	dec [cop]
	Call L3Draw
@@leave:
	PopAll
	ret
endp L3MoveLeft


proc L1MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call L1UnDraw
	dec [cop]
	Call L1Draw
@@leave:
	PopAll
	ret
endp L1MoveLeft

proc L0MoveLeft 
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call L0UnDraw
	dec [cop]
	Call L0Draw
@@leave:
	PopAll
	ret
endp L0MoveLeft

;Try2place
;Draw
;Undraw
;Move
;OsPlace
;------------------------
; J Piece Functions here:
;------------------------
proc JDraw
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call J0Draw
jmp @@leave
@@one:
call J1Draw
jmp @@leave
@@two:
call J2Draw
jmp @@leave
@@three:
call J3Draw
jmp @@leave
@@leave:
	ret
endp JDraw

proc JUnDraw
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call J0UnDraw
jmp @@leave
@@one:
call J1UnDraw
jmp @@leave
@@two:
call J2UnDraw
jmp @@leave
@@three:
call J3UnDraw
jmp @@leave
@@leave:
	ret
endp JUnDraw


proc JMove
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call J0Move
jmp @@leave
@@one:
call J1Move
jmp @@leave
@@two:
call J2Move
jmp @@leave
@@three:
call J3Move
jmp @@leave
@@leave:
	ret
endp JMove

proc JIsPlace
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call J0IsPlace
jmp @@leave
@@one:
call J1IsPlace
jmp @@leave
@@two:
call J2IsPlace
jmp @@leave
@@three:
call J3IsPlace
jmp @@leave
@@leave:
	ret
endp JIsPlace

proc JMoveRight
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call J0MoveRight
jmp @@leave
@@one:
call J1MoveRight
jmp @@leave
@@two:
call J2MoveRight
jmp @@leave
@@three:
call J3MoveRight
jmp @@leave
@@leave:
	ret
endp JMoveRight

proc JMoveLeft
	cmp [flips],0
	je @@zero
	cmp [flips],2
	jb @@one
	je @@two
	ja @@three
@@zero:
call J0MoveLeft
jmp @@leave
@@one:
call J1MoveLeft
jmp @@leave
@@two:
call J2MoveLeft
jmp @@leave
@@three:
call J3MoveLeft
jmp @@leave
@@leave:
	ret
endp JMoveleft

proc J0Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'b'
	add bx,1
	mov [board + bx],'b'
	sub bx,10
	mov [board + bx],'b'
	sub bx,10
	mov [board + bx],'b'
	PopAll
	ret
endp J0Draw

proc J1Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'b'
	sub bx,10
	mov [board + bx],'b'
	add bx,11
	mov [board + bx],'b'
	inc bx
	mov [board + bx],'b'
	PopAll
	ret
endp J1Draw


proc J2Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'b'
	sub bx,1
	mov [board + bx],'b'
	add bx,10
	mov [board + bx],'b'
	add bx,10
	mov [board + bx],'b'
	PopAll
	ret
endp J2Draw

proc J3Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'b'
	inc bx
	mov [board + bx],'b'
	inc bx
	mov [board + bx],'b'
	add bx,10
	mov [board + bx],'b'
	PopAll
	ret
endp J3Draw

proc J0UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	add bx,1
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp J0UnDraw

proc J1UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	add bx,11
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	PopAll
	ret
endp J1UnDraw

proc J2UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,1
	mov [board + bx],'d'
	add bx,10
	mov [board + bx],'d'
	add bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp J2UnDraw

proc J3UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	add bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp J3UnDraw

proc J0Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call J0Undraw ;moving the piece
	add [cop],10
	call J0Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp J0Move

proc J1Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	add al,2
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call J1Undraw ;moving the piece
	add [cop],10
	call J1Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp J1Move

proc J2Move
	push ax
	push bx
	push dx
	;mov ax,0
	;mov al,[LineHighestY + 5]
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	sub al,21
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call J2Undraw ;moving the piece
	add [cop],10
	call J2Draw
	jmp @@exitproc
@@exitproc:
	mov [backb],dh
	pop dx
	pop bx
	pop ax
	ret
endp J2Move

proc J3Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	inc bx
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	mov ax,0
	mov al,[cop]
	add al,12
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@exitproc
	call J3Undraw ;moving the piece
	add [cop],10
	call J3Draw
	jmp @@exitproc
	@@exitproc:
	mov [backb],dh
	PopAll
	ret
endp J3Move

proc J0IsPlace
	PushAll
	jmp @@cod
@@leave2:
	call Stop
@@cod:
	cmp [ct],60
	jae @@toleave
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
@@true:
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	jmp @@cont
@@toleave:
	jmp @@exitproc
	; call stop
	@@cont:
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	inc bx
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@exitproc
	call JDraw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	add bx,1
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	;call ShowYAndHighestY
	@@exitproc:
	Call DrawAllx
	PopAll
	ret
endp J0IsPlace

proc J1IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,11
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,11
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	add al,12
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	add bx,11
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp J1IsPlace

proc J2IsPlace
	PushAll
	call UpdateHighestYs
	jmp @@cod
@@leave2:
	call Stop
@@cod:
	cmp [ct],60
	jae @@toleave
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
@@true:
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	jmp @@exitproc
@@toleave:
	jmp @@exitproc
	; call stop
	@@cont:
	mov ax,0
	mov al,[cop]
	add al,21
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@exitproc
	call J2Draw
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,1
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	mov [cop],5
	call RandomPiece
	inc [scorec]
	call UpdateHighestYs
	;call ShowYAndHighestY
	@@exitproc:
	Call DrawAllx
	PopAll
	ret
endp J2IsPlace

proc J3IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	inc al
	inc al
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
	jmp @@leave
@@cont2:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	inc al
	add al,11
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	add bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	call RandomPiece
	inc [scorec]
@@leave:
	call DrawAllx
	PopAll
	ret
endp J3IsPlace

proc J0MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,8
	je @@leave
	call J0UnDraw
	inc [cop]
	Call J0Draw
@@leave:
	PopAll
	ret
endp J0MoveRight

proc J1MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	add bx,12
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,7
	je @@leave
	call J1UnDraw
	inc [cop]
	Call J1Draw
@@leave:
	PopAll
	ret
endp J1MoveRight

proc J2MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	inc bx
	cmp [board + bx],'x'
	je @@leave
	add bx,10
	cmp [board + bx],'x'
	je @@leave
	add bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call J2UnDraw
	inc [cop]
	Call J2Draw
@@leave:
	PopAll
	ret
endp J2MoveRight

proc J2MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	add bx,11
	cmp [board + bx],'x'
	je @@leave
	add bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call J2UnDraw
	dec [cop]
	Call J2Draw
@@leave:
	PopAll
	ret
endp J2MoveLeft

proc J3MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	add bx,3
	cmp [board + bx],'x'
	je @@leave
	add bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,7
	je @@leave
	call J3UnDraw
	inc [cop]
	Call J3Draw
@@leave:
	PopAll
	ret
endp J3MoveRight

proc J3MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	add bx,12
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call J3UnDraw
	dec [cop]
	Call J3Draw
@@leave:
	PopAll
	ret
endp J3MoveLeft


proc J1MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	add bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call J1UnDraw
	dec [cop]
	Call J1Draw
@@leave:
	PopAll
	ret
endp J1MoveLeft

proc J0MoveLeft 
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,9
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call J0UnDraw
	dec [cop]
	Call J0Draw
@@leave:
	PopAll
	ret
endp J0MoveLeft

;Try2place
;Draw
;Undraw
;Move
;OsPlace
;------------------------
; I Piece Functions here:
;------------------------
proc I0Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'t'
	sub bx,10
	mov [board + bx],'t'
	sub bx,10
	mov [board + bx],'t'
	sub bx,10
	mov [board + bx],'t'
	PopAll
	ret
endp I0Draw

proc I1Draw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'t'
	inc bx
	mov [board + bx],'t'
	inc bx
	mov [board + bx],'t'
	inc bx
	mov [board + bx],'t'
	PopAll
	ret
endp I1Draw

proc IDraw
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call I0Draw
	jmp @@leave
@@Horizontal:
	call I1Draw
@@leave:
	PopAll
	ret
endp IDraw

proc I0UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	sub bx,10
	mov [board + bx],'d'
	PopAll
	ret
endp I0UnDraw

proc I1UnDraw
	PushAll
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	inc bx
	mov [board + bx],'d'
	PopAll
	ret
endp I1UnDraw

proc IUnDraw
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call I0UnDraw
	jmp @@leave
@@Horizontal:
	call I1UnDraw
@@leave:
	PopAll
	ret
endp IUnDraw

proc I0Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	call I0UnDraw
	add [cop],10
	call I0Draw
@@leave:
	PopAll
	ret
endp I0Move

proc I1Move
	PushAll
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	add al,3
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	add al,2
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	mov ax,0
	mov al,[cop]
	add al,1
	call GetXY
	mov bx,0
	mov bl,al
	cmp ah,[LineHighestY + bx]
	je @@leave
	call I1UnDraw
	add [cop],10
	call I1Draw
@@leave:
	PopAll
	ret
endp I1Move


proc IMove
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call I0Move
	jmp @@leave
@@Horizontal:
	call I1Move
@@leave:
	PopAll
	ret
Endp IMove

proc I0IsPlace
	PushAll
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	sub bx,10
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	inc [scorec]
	call RandomPiece
@@leave:
	call DrawAllx
	PopAll
	ret
endp I0IsPlace

proc I1IsPlace
	PushAll
	cmp [ct],60
	jae @@cont
	mov ax,0
	mov al,[cop]
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	inc [scorec]
	call RandomPiece
@@cont:
	cmp [ct],60
	jae @@cont2
	mov ax,0
	mov al,[cop]
	add al,1
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont2
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	inc [scorec]
	call RandomPiece
@@cont2:
	cmp [ct],60
	jae @@cont3
	mov ax,0
	mov al,[cop]
	add al,2
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@cont3
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	inc [scorec]
	call RandomPiece
@@cont3:
	cmp [ct],60
	jae @@leave
	mov ax,0
	mov al,[cop]
	add al,3
	call GetXY
	mov bx,0
	mov bl,al
	mov dl,[LineHighestY + bx]
	cmp ah,dl
	jne @@leave
	mov bx,0
	mov bl,[cop]
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	inc bx
	mov [board + bx],'x'
	call UpdateHighestYs
	mov [cop],5
	inc [scorec]
	call RandomPiece
@@leave:
	call DrawAllx
	PopAll
	ret
endp I1IsPlace

proc IIsPlace
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call I0IsPlace
	jmp @@leave
@@Horizontal:
	call I1IsPlace
@@leave:
	PopAll
	ret
endp IIsPlace

proc I0MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	inc bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,9
	je @@leave
	call I0UnDraw
	inc [cop]
	Call I0Draw
@@leave:
	PopAll
	ret
endp I0MoveRight

proc I1MoveRight
	PushAll
	xor bx,bx
	mov bl,[cop]
	add bx,3
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	add al,3
	call GetXY
	cmp al,9
	je @@leave
	call I1UnDraw
	inc [cop]
	Call I1Draw
@@leave:
	PopAll
	ret
endp I1MoveRight

proc I0MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	sub bx,10
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call I0UnDraw
	dec [cop]
	Call I0Draw
@@leave:
	PopAll
	ret
endp I0MoveLeft

proc I1MoveLeft
	PushAll
	xor bx,bx
	mov bl,[cop]
	dec bx
	cmp [board + bx],'x'
	je @@leave
	mov ax,0
	mov al,[cop]
	call GetXY
	cmp al,0
	je @@leave
	call I1UnDraw
	dec [cop]
	Call I1Draw
@@leave:
	PopAll
	ret
endp I1MoveLeft

proc IMoveRight
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call I0MoveRight
	jmp @@leave
@@Horizontal:
	Call I1MoveRight
@@leave:
	PopAll
	ret
endp IMoveRight

proc IMoveLeft
	PushAll
	cmp [Flips],1
	ja @@Horizontal
	call I0MoveLeft
	jmp @@leave
@@Horizontal:
	call I1MoveLeft
@@leave:
	PopAll
	ret
endp IMoveLeft

;Try2place
;Draw
;Undraw
;Move
;IsPlace


EndOfCsLbl:
END start

