include irvine32.inc

player_input proto, shipLen:byte, character : byte
compinput proto, shipLen : byte, character : byte
decHp proto, character : byte, shipR : PTR byte, shipB : PTR byte, shipU : PTR byte, shipS : PTR byte, shipD : PTR byte, structureVar : PTR byte,compT: byte

.Data
shipstr byte "Place your ships! ", 0
Rship byte "Place a 5-lengthed ship (R)(UPPERCASE LETTERS EX: A0 A4): ", 0
Bship byte "Place a 4-lengthed ship (B)(UPPERCASE LETTERS EX: B5 B8): ", 0
Uship byte "Place a 3-lengthed ship (U)(UPPERCASE LETTERS EX: D7 D9): ", 0
Sship byte "Place a 3-lengthed ship (S)(UPPERCASE LETTERS EX: F4 H4): ", 0
Dship byte "Place a 2-lengthed ship (D)(UPPERCASE LETTERS EX: H0 I0): ", 0
fireCoor byte "Place a fire coordinate:", 0
compTurn byte "Computers turn...", 0
playerTurn byte "Your turn...", 0
hitt byte "Hit the target!", 0
hitsunk byte "Hit the target & Sunk! SHIP ", 0
miss byte "Miss", 0
win byte "YOU WIN!!", 0
lose byte "YOU LOSE", 0
alreadyfired byte "INVALID COORDINATE", 0
wrongplacement byte "invalid Place Try Again", 0
WRONGCORD BYTE "Wrong Cordinate", 0

playerRShip byte 5
playerBShip byte 4
playerUShip byte 3
playerSShip byte 3
playerDShip byte 2
computerRShip byte 5
computerBShip byte 4
computerUShip byte 3
computerSShip byte 3
computerDShip byte 2

playerVar byte 17
computerVar byte 17
randomval byte ?
randomval2 byte ?
randomz byte ?
var byte ?
display byte 'A'
column byte ?
ro    byte ?
column2 byte ?
ro2 byte ?
par byte 0
firecord byte 3 dup(? ), 0
pinputstr byte 6 dup(? )
firstOffset byte ?
secondOffset byte ?
fireval byte ?
col = 10
row = 10

hitmode byte 0
hitcord byte ?
validation byte 0
left byte 1
right byte 1
up byte 10
down byte 10

READ BYTE 2 DUP(? )
ogp byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')

ogc byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')
byte 10  dup('-')

tgc byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')



tgp byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')
byte 10  dup('*')

firedplace byte 2 dup(0)
.code

main proc

call displayfu
mov edx, offset shipstr
mov ecx, lengthof shipstr
call writestring
call crlf

mov edx, offset Rship
mov ecx, lengthof Rship
call writestring

invoke player_input, 5, 'R'
call displayFu


mov edx, offset Bship
mov ecx, lengthof Bship
call writestring
invoke player_input, 4, 'B'
call displayFu

mov edx, offset Uship
mov ecx, lengthof Uship
call writestring

invoke player_input, 3, 'U'
call displayFu

mov edx, offset Sship
mov ecx, lengthof Sship
call writestring

invoke player_input, 3, 'S'
call displayFu

mov edx, offset Dship
mov ecx, lengthof Dship
call writestring
invoke player_input, 2, 'D'
call displayFu


call randomize
invoke compinput, 5, 'R'
invoke compinput, 4, 'B'
invoke compinput, 3, 'U'
invoke compinput, 3, 'S'
invoke compinput, 2, 'D'
; CALL DISPLAYFU;; REMOVE COMMENT ON THIS LINE, LINE 165, LINE 172, LINE 186 TO SEE COMPUTER BOARDS
; CALL DISPLAYCOMP
GAME :
mov edx, offset playerTurn
call writestring
call crlf
call playerfire
CALL DISPLAYFU
; call displayCOMP
movzx EAX, computervar
cmp eax, 0
je player1s
mov edx, offset compTurn
call writestring
mov eax, 1500
call delay
call crlf
call COMPfire
movzx EAX, PLAYERvar
cmp eax, 0
je gameOver
CALL DISPLAYFU
;CALL DISPLAYCOMP
cmp al, 1
je gameOver
JMP GAME
gameOver :
call displayFu
mov edx, offset lose
mov ecx, lengthof lose
call writestring
jmp gosleep
player1 :
call displayfu
mov edx, offset win
mov ecx, lengthof win
call writestring
gosleep :
call waitmsg
exit
main endp



; ----------------------------------------------
; FIRE AT A SPECIFIC COORDINATE
; ---------------------------------------------- -
COMPfire proc
input :
mov validation,0
cmp hitmode,1
jne normal
cmp left,0
je rigt
mov bl,hitcord
add bl,left
ADD left,1
mov fireval,bl
call validate
cmp validation,1
je input
jmp cont
rigt:
cmp right,0
je above
mov bl,hitcord
SUB bl,right
ADD right,1
mov fireval, bl
call validate
cmp validation, 1
je input
jmp cont
above:
cmp up,0
je below
mov bl,hitcord
SUB bl,up
add up,10
mov fireval,bl
call validate
cmp validation, 1
je input
jmp cont
below:
cmp down,0
je normal
mov bl,hitcord
add bl,down
ADD down,10
mov fireval,bl
call validate
cmp validation, 1
je input
jmp cont
normal:
mov eax, 100
call randomrange
mov fireval, al
cont:
movzx ebx, fireval
mov al, tgc[ebx]
cmp al, '*'
jne inputagain
mov edx, offset firedplace
mov ecx, 2
call writestring
call crlf
mov al, ogp[ebx]
cmp al, '-'
je mis
mov tgc[ebx], 'O'
mov al, ogp[ebx]
mov ogp[ebx], '*'
cmp hitmode,1
je alrActv
mov hitmode , 1
mov hitcord , bl
alrActv:
mov par, al
invoke decHp, par, OFFSET playerRShip, OFFSET playerBShip, OFFSET playerUShip, OFFSET playerSShip, OFFSET playerDShip, OFFSET playerVar,1
jmp whatever
inputagain :
JMP input
mis :
mov tgc[ebx], 'X'
mov edx, offset miss
call writestring
mov eax, 1000
call delay
cmp hitmode,1
jne whatever
cmp left,0
je clearRight
mov left,0
jmp whatever
clearRight:
cmp right,0
je clearAbove
mov right,0
jmp whatever
clearAbove:
cmp up,0
je clearBelow
mov up,0
jmp whatever
clearBelow:
mov hitmode,0
mov hitcord,100
mov left,1
mov right,1
mov up,10
mov down,10
whatever :
ret
COMPfire endp

; ----------------------------------------------
; VALIDATES THE FIRECORD GENERATED BY HITMODE
; ----------------------------------------------
validate proc
cmp left,0
je Rigt
movzx ax, fireval
mov cl, 10
div cl
mov bh, al
movzx ax, hitcord
mov cl,10
div cl
cmp bh, al
je valFin
mov left,0
mov validation,1
jmp valFin
Rigt:
cmp right,0
je aboveAndBelow
movzx ax,fireval
mov cl,10
div cl
mov bh,al
movzx ax,hitcord
mov cl,10
div cl
cmp bh,al
je valFin
mov right, 0
mov validation, 1
jmp valFin
aboveAndBelow:
cmp up,0
je below
mov al,fireval
cmp al,99
jbe valFin
mov up, 0
mov validation, 1
jmp valFin
ret
below:
mov al, fireval
cmp al, 0
jae valFin
mov down, 0
mov validation, 1
valFin:
ret
validate endp

; ----------------------------------------------
; FIRE AT A SPECIFIC COORDINATE
; ----------------------------------------------
playerfire proc

input :
mov edx, offset fireCoor
mov ecx, lengthof fireCoor
call writestring
CALL CRLF
mov edx, offset firecord
mov ecx, lengthof firecord
call readstring
mov ecx, 1
mov eax, 0
mov al, firecord[ecx]
sub al, 48
cmp al, 9;;;;;;;;;;;
JA inputA;;;;;;;;;;;;;;
mov column, al

mov ecx, 0
mov eax, 0
mov al, firecord[ecx]
sub al, 65
mov ro, al

MOV ECX, 2
MOV EAX, 0
MOV AL, FIRECORD[ECX];;;;;;;;;;;;;;;;;;;;;;
CMP AL, " "
JG INPUTA
mov al, " "

mov edx, 0
mov eax, col
mul ro
add al, column

cmp eax, 0
jl inputa
cmp eax, 99
jg inputA
mov fireval, al
movzx ebx, fireval
mov al, tgp[ebx]
cmp al, '*'
jne inputAGAIN
mov al, ogc[ebx]
cmp al, '-'
je mis
mov tgp[ebx], 'O'
mov al, ogc[ebx]
mov ogc[ebx], '*'
mov par, al
invoke decHp, par, OFFSET computerRShip, OFFSET computerBShip, OFFSET computerUShip, OFFSET computerSShip, OFFSET computerDShip, OFFSET computerVar,0
jmp whatever
INPUTA :
MOV EDX, OFFSET WRONGCORD
CALL WRITESTRING
CALL CRLF
jmp input
inputagain :
mov edx, offset alreadyfired
call writestring
call crlf
JMP input
mis :
mov tgp[ebx], 'X'
mov edx, offset miss
call writestring
mov eax, 1000
call delay
whatever :


ret
playerfire endp

; -------------------------------------------------------------------------- -
; DECREASE THE LIFE POINTS OF THE SHIP THAT WAS HIT
; RECIEVES CHARACTER CONTAINS THE SHIP CHARACTER THAT WAS HIT
; RECIEVES SHIPR CONTAINS SHIP R LIFEPOINTS, SHIPB CONTAINS SHIP B LIFEPOINTS
; RECIEVES SHIPS CONTAINS SHIP S LIFEPOINTS, SHIPU CONTAINS SHIP U LIFEPOINTS
; RECIEVES SHIPD CONTAINS SHIP D LIFEPOINTS, STRUCTUREVAR THE TOTAL POINTS OF ALL SHIPS
; ----------------------------------------------------------------------------
decHp proc, character:byte, shipR : PTR BYTE, shipB : PTR BYTE, shipU : PTR BYTE, shipS : PTR BYTE, shipD : PTR BYTE, structureVar : PTR BYTE,compT: byte

movzx eax, character
mov edx, offset hitt
mov ecx, lengthof hitt

cmp eax, 'R'
jne b
MOV EDI, SHIPR
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
mov al, [EDI]
cmp al, 0
je sunkShip
call writestring
mov eax, 1000
call delay
MOV EDI, structureVar
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
jmp skip

b :
cmp eax, 'B'
jne u

MOV EDI, SHIPB
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
mov al, [EDI]
cmp al, 0
je sunkShip
call writestring
mov eax, 1000
call delay

MOV EDI, structureVar
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
jmp skip

u :
cmp eax, 'U'
jne s
MOV EDI, SHIPU
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
mov al, [EDI]
cmp al, 0
je sunkShip
call writestring
mov eax, 1000
call delay

MOV EDI, structureVar
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
jmp skip
s :
cmp eax, 'S'
jne d
MOV EDI, SHIPS
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
mov al, [EDI]
cmp al, 0
je sunkShip
call writestring
mov eax, 1000
call delay

MOV EDI, structureVar
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
jmp skip
d :
cmp eax, 'D'
jne skip
MOV EDI, SHIPD
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
mov al, [EDI]
cmp al, 0
je sunkShip

call writestring
mov eax, 1000
call delay

MOV EDI, structureVar
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
JMP SKIP
sunkShip :
mov edx, offset Hitsunk
mov ecx, lengthof Hitsunk
call writestring
MOV AL,CHARACTER
CALL WRITECHAR
call crlf
mov eax, 1000
call delay
MOV EDI, structureVar
MOV ESI, [EDI]
DEC ESI
mov[edi], esi
cmp compT,1
jne skip
mov hitmode,0
mov hitcord,100
mov left,1
mov right,1
mov up,10
mov down,10
skip :
ret
decHp endp


; ----------------------------------------------
; PLACE COMPUTER SHIPS AT SPECIFIC COORDINATES
; RECIEVES SHIPLEN CONTAINS THE LENGTH OF SHIP
; RECIEVES CHARACTER CONTAINS SHIP CHARACTER
; ---------------------------------------------- -

compinput proc, shiplen:byte, character : byte
beg :

L2 :
	mov eax, 100
	call randomrange
	mov randomval, al
	mov randomval2, al
	mov eax, 2
	call randomrange
	cmp eax, 0
	jne L1
	mov al, shiplen
	sub al, 1
	mov var, 1
	add randomval2, al
	jmp skip
L1 :
   mov edx, 0
	   mov ebx, 10
	   mov al, var
	   mul bl
	   add randomval2, al
	   mov var, 10
   skip:
   mov al, randomval2
	   cmp al, 99
	   ja beg


	   mov ecx, 0
	   mov ax, 0
	   mov al, randomval
	   mov cl, 10
	   div cl

	   mov ebx, 0
	   mov bl, 10
	   sub bl, ah
	   mov  ah, shiplen
	   cmp bl, ah
	   jl beg
	   movzx eax, var
	   movzx edx, randomval
	   movzx ecx, shiplen
   loob :
   movzx ebx, ogc[edx]
	   cmp ebx, '-'
   jne beg
	   add edx, eax
	   loop loob

	   movzx ecx, shiplen
	   movzx edx, randomval
   loob2 :
   mov al, character
	   mov ogc[edx], al
	   add dl, var
	   loop loob2

	   ret
	   compinput endp


	   ; ----------------------------------------------
	   ; PLACE USER SHIPS AT SPECIFIC COORDINATES
	   ; RECIEVES SHIPLEN CONTAINS THE LENGTH OF SHIP
	   ; RECIEVES CHARACTER CONTAINS SHIP CHARACTER
	   ; ---------------------------------------------- -
	   player_input proc, shipLen:byte, character : byte
   input :
   mov edx, offset   pinputstr
	   mov ecx, lengthof pinputstr
	   call readstring

	   mov bl, [edx]
	   cmp bl, pinputstr[3]
	   mov var, 1
	   je next
	   mov bl, [edx + 1]
	   cmp bl, pinputstr[4]
	   jne wrong

	   mov var, 10
   next:
   mov ecx, 1
	   mov eax, 0
	   mov al, pinputstr[ecx]
	   sub al, 48
	   cmp al,9
	   ja wrong
	   mov column, al

	   mov ecx, 0
	   mov eax, 0
	   mov al, pinputstr[ecx]
	   sub al, 65
	   jc wrong
	   mov ro, al


	   mov al, pinputstr[4]
	   sub al, 48
	   cmp al, 9
	   ja wrong
	   mov column2, al

	   mov ecx, 3
	   mov eax, 0
	   mov al, pinputstr[ecx]
	   sub al, 65
	   jc wrong
	   mov ro2, al



	   mov edx, 0
	   mov eax, col
	   mul ro
	   add al, column

	   cmp eax, 0
	   jb wrong
	   cmp eax, 99
	   ja wrong
	   mov firstOffset, al

	   mov edx, 0
	   mov eax, col
	   mul ro2
	   add al, column2

	   cmp eax, 0
	   jb wrong
	   cmp eax, 99
	   ja wrong


	   mov secondOffset, al
	   mov bl, secondOffset
	   sub bl, firstOffset
	   mov cl, shipLen
	   sub cl, 1
	   cmp bl, cl
	   je next2
	   mov bl, ro2
	   sub bl, ro
	   mov cl, shipLen
	   sub cl, 1
	   cmp bl, cl
	   jne wrong
   next2:
   mov eax, 0
	   mov ebx, 0
	   mov ecx, 0
	   mov edx, 0

	   movzx eax, var
	   movzx edx, firstoffset
	   movzx ecx, shiplen
   loob :
   movzx ebx, ogp[edx]
	   cmp ebx, '-'
       jne wrong
	   add edx, eax
	   loop loob

	   movzx ecx, shiplen
	   movzx edx, firstoffset
   loob2 :
   mov al, character
	   mov ogp[edx], al
	   add dl, var
	   loop loob2

	   jmp f
       wrong :
       mov edx, offset wrongplacement
	   call writestring
	   call crlf
	   mov edx, 0
	   jmp input

   f :
   ret
	   player_input endp


	   ; ----------------------------------------------
	   ; DISPLAY PLAYER OCEAN AND TARGET
	   ; ---------------------------------------------- -
	   displayFu proc
	   mov eax, white + (black * 16)
	   call settextcolor
	   call clrscr
	   mov ecx, 10
	   mov ebx, 0
	   mov al, ' '
	   call writechar
   digitIndex :
   mov al, ' '
	   call writechar
	   mov eax, ebx
	   call writedec
	   inc ebx
	   loop digitIndex

	   mov ecx, 0
	   mov ebx, 0
	   call crlf
	   call crlf

	   mov display, 'A'
	   mov ecx, 10
	   ; loop ely bt3rd el 2D array bta3 elplayer "ocean grid"
   oceanDisplay:
   push ecx
	   mov ecx, 10
	   mov al, display
	   call writechar
	   mov al, ' '
	   call writechar
	   inc display
   l1 :
   mov al, ogp[ebx]
	   call setOceanColor
	   call writechar
	   mov eax, white + (black * 16)
	   call settextcolor
	   mov al, ' '
	   call writechar
	   inc ebx
	   loop l1
	   call crlf
	   pop ecx
	   loop oceanDisplay

	   ; d b2a loop ely bt5lena n7ot el 2D array eltany bta3 eltarget gnb elocean grid kda msh t7tha btbd2 tktb mn awl row 2 ely hwa bn7ot elrows fl(dh) w btzwd 3la elrows fl loop ely bara ely btmshe 3l rows w l colums btb2a fl(dl) ely hya mn awl column 23 w bn7oto gwa el loop 3shan 3nd kol row gwa elrow nafso bnbd2 mn 23 w nzwd l7d ma n5ls el 10 columbs w nrg3 tany nzwd elrow(elrow bara 3shan bnzwd 3leh kol mara msh bnbd2 mn nafs elrow lakn elcolumn gwa l2n kol mara bnbd2 mn 23 w nzwd <3) :)
	   mov dh, 0
	   mov dl, 27
	   call gotoxy
	   mov ecx, 10
	   mov ebx, 0
   targetDigitIndex :
   mov eax, ebx
	   call writedec
	   inc dl
	   call gotoxy
	   mov al, ' '
	   call writechar
	   inc dl
	   call gotoxy
	   inc ebx
	   loop targetDigitIndex
	   call crlf
	   mov ecx, 10
	   mov ebx, 0
	   mov dh, 2
	   mov display, 'A'
   targetDisplay:
   mov dl, 25
	   call gotoxy
	   push ecx
	   mov ecx, 10
	   mov al, display
	   call writechar
	   mov al, ' '
	   call writechar
	   inc display
   l2 :
   MOV al, tgp[ebx]
	   call setTargetColor
	   call writechar
	   mov eax, white + (black * 16)
	   call settextcolor
	   mov al, ' '
	   call writechar
	   inc ebx
	   inc dl
	   loop l2
	   call crlf
	   call crlf
	   pop ecx
	   inc dh
	   loop targetDisplay

	   ret
	   displayFu endp

	   ; ----------------------------------------------
	   ; DISPLAY COMPUTER OCEAN AND TARGET
	   ; ---------------------------------------------- -
	   DISPLAYCOMP PROC
	   mov eax, white + (black * 16)
	   call settextcolor
	   mov ecx, 10
	   mov ebx, 0
	   MOV DH,14
	   mov dl,0
	   call gotoxy
	   mov al, ' '
	   call writechar
	   MOV DL,1
       digitIndex :
	   call gotoxy
       mov al, ' '
	   call writechar
	   mov eax, ebx
	   call writedec
	   inc ebx
	   add dl,2
	   loop digitIndex
	   mov ecx, 0
	   mov ebx, 0
	   mov display, 'A'
	   mov ecx, 10
	   MOV DH,15
	   ; loop ely bt3rd el 2D array bta3 elplayer "ocean grid"
   oceanDisplay:
   push ecx
	   MOV DL,0
	   CALL GOTOXY
	   mov ecx, 10
	   mov al, display
	   call writechar
	   mov al, ' '
	   call writechar
	   inc display
   l1 :
   mov al, ogc[ebx]
	   call setOceanColor
	   call writechar
	   mov eax, white + (black * 16)
	   call settextcolor
	   mov al, ' '
	   call writechar
	   inc ebx
	   loop l1
	   INC DH
	   pop ecx
	   loop oceanDisplay

	   ; d b2a loop ely bt5lena n7ot el 2D array eltany bta3 eltarget gnb elocean grid kda msh t7tha btbd2 tktb mn awl row 2 ely hwa bn7ot elrows fl(dh) w btzwd 3la elrows fl loop ely bara ely btmshe 3l rows w l colums btb2a fl(dl) ely hya mn awl column 23 w bn7oto gwa el loop 3shan 3nd kol row gwa elrow nafso bnbd2 mn 23 w nzwd l7d ma n5ls el 10 columbs w nrg3 tany nzwd elrow(elrow bara 3shan bnzwd 3leh kol mara msh bnbd2 mn nafs elrow lakn elcolumn gwa l2n kol mara bnbd2 mn 23 w nzwd <3) :)

	   mov ecx, 10
	   mov ebx, 0
	   mov dh, 15
   targetDisplay:
   mov dl, 27
	   call gotoxy
	   push ecx
	   mov ecx, 10
   l2 :
	  MOV al, tgc[ebx]
	  call setTargetColor
	  call writechar
	  mov eax, white + (black * 16)
	  call settextcolor
	  mov al, ' '
	  call writechar
	  inc ebx
	  inc dl
	  loop l2
	  call crlf
	  call crlf
	  pop ecx
	  inc dh
	  loop targetDisplay

	  ret
	  displaycomp endp


	  ; ----------------------------------------------
	  ; SET THE COLOR OF CHARACTERS IN OCEAN GRID
	  ; RECIEVER AL CONTAINS THE CHARACTER
	  ; RETURNS EAX CONATINS THE COLOR
	  ;-----------------------------------------------
	  setOceanColor proc USES eax
	  cmp al, 'R'
	  jne B
	  mov eax, yellow + (black * 16)
	  call settextcolor
	  jmp write
  B :
   cmp al, 'B'
	   jne U
	   mov eax, lightcyan + (black * 16)
	   call settextcolor
	   jmp write
   U :
   cmp al, 'U'
	   jne S
	   mov eax, lightmagenta + (black * 16)
	   call settextcolor
	   jmp write
   S :
   cmp al, 'S'
	   jne D
	   mov eax, lightgreen + (black * 16)
	   call settextcolor
	   jmp write
   D :
   cmp al, 'D'
	   jne ast
	   mov eax, lightgray + (black * 16)
	   call settextcolor
	   jmp write
   ast :
   cmp al, '*'
	   jne write
	   mov eax, lightred + (black * 16)
	   call settextcolor
   write :
   ret
	   setOceanColor endp

	   ; ----------------------------------------------
	   ; SET THE COLOR OF CHARACTERS IN TARGET GRID
	   ; RECIEVER AL CONTAINS THE CHARACTER
	   ; RETURNS EAX CONATINS THE COLOR
	   ; ---------------------------------------------- -
	   setTargetColor proc USES eax
	   cmp al, 'O'
	   jne X
	   mov eax, lightgreen + (black * 16)
	   call settextcolor
	   jmp write
   X :
   cmp al, 'X'
	   jne write
	   mov eax, lightred + (black * 16)
	   call settextcolor
   write :
   ret
	   setTargetColor endp
	   end main
