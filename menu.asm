org 0x7e00
jmp 0x0000:start

data:
	positionX dw 100	
	finalX dw 119	
	positionY dw 90		  
	finalY dw 109	
	posicao dw 0
	bomba dw 0
	score1 dw 0
	score2 dw 0
	player dw 0
	string1 db "Player 1", 0
	string2 db "Player 2", 0
	string dw 0
	stringFim db " Fim De Jogo", 0
	vitoriaP1 db "O Player 1 Venceu!", 0
	vitoriaP2 db "O Player 2 Venceu!", 0

reverse:              ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret

tostring:              ; mov ax, int / mov di, string
  push di
  .loop1:
    cmp ax, 0
    je .endloop1
    xor dx, dx
    mov bx, 10
    div bx            ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx       ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1
  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
  mov al, 0
  stosb
  call reverse
  ret

putchar:
  mov ah, 0x0e
  int 10h
  ret

prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret
	
	
printPixel:				  	; imprime al em cx, dx
	xor bx, bx
	mov ah, 0ch
	int 10h
	ret

printPosition:			  	; Imprime um quadrado nas coordenadas dadas da grade de 32x20 na cor de al
	
	push cx
	mov cx, [positionX]
	mov dx, [positionY]

	.linha:
		call printPixel
		cmp cx, [finalX]
        inc cx
		jae .finalLinha
		jmp .linha

	.finalLinha:
		mov cx, [positionX]
		cmp dx, [finalY]
        inc dx
		jb .linha

	pop cx
	ret

printTabuleiro:
	mov cx, 0
	call printQuadrado
	mov cx, 1
	call printQuadrado
	mov cx, 2
	call printQuadrado
	mov cx, 3
	call printQuadrado
	mov cx, 4
	call printQuadrado
	mov cx, 5
	call printQuadrado
	mov cx, 6
	call printQuadrado
	mov cx, 7
	call printQuadrado
	mov cx, 8
	call printQuadrado

printQuadrado:
	cmp cx, 0
	je .quadrado0
	cmp cx, 1
	je .quadrado1
	cmp cx, 2
	je .quadrado2
	cmp cx, 3
	je .quadrado3
	cmp cx, 4
	je .quadrado4
	cmp cx, 5
	je .quadrado5
	cmp cx, 6
	je .quadrado6
	cmp cx, 7
	je .quadrado7
	cmp cx, 8
	je .quadrado8

	.quadrado0:
		call posicao0x0
		ret

	.quadrado1:
		call posicao0x1
		ret

	.quadrado2:
		call posicao0x2
		ret

	.quadrado3:
		call posicao1x0
		ret

	.quadrado4:
		call posicao1x1
		ret

	.quadrado5:
		call posicao1x2
		ret

	.quadrado6:
		call posicao2x0
		ret

	.quadrado7:
		call posicao2x1
		ret

	.quadrado8:
		call posicao2x2
		ret

quadradoPadrao:
	mov al, 14
	call printQuadrado
	ret

quadradoCursor:
	cmp word[player], 1
	je .p1 

	mov al, 13
	call printQuadrado
	ret

	.p1:
	mov al, 11
	call printQuadrado
	ret


posicao0x0:
	mov word[positionX], 100
	mov word[finalX], 119
	mov word[positionY], 60
	mov word[finalY], 79
	call printPosition
	ret
		

posicao0x1:
	mov word[positionX], 130
	mov word[finalX], 149
	mov word[positionY], 60
	mov word[finalY], 79
	call printPosition
	ret

posicao0x2:
	mov word[positionX], 160
	mov word[finalX], 179
	mov word[positionY], 60
	mov word[finalY], 79
	call printPosition
	ret

posicao1x0:
	mov word[positionX], 100
	mov word[finalX], 119
	mov word[positionY], 90
	mov word[finalY], 109
	call printPosition
	ret

posicao1x1:
	mov word[positionX], 130
	mov word[finalX], 149
	mov word[positionY], 90
	mov word[finalY], 109
	call printPosition
	ret

posicao1x2:
	mov word[positionX], 160
	mov word[finalX], 179
	mov word[positionY], 90
	mov word[finalY], 109
	call printPosition
	ret

posicao2x0:
	mov word[positionX], 100
	mov word[finalX], 119
	mov word[positionY], 120
	mov word[finalY], 139
	call printPosition
	ret

posicao2x1:
	mov word[positionX], 130
	mov word[finalX], 149
	mov word[positionY], 120
	mov word[finalY], 139
	call printPosition
	ret

posicao2x2:
	mov word[positionX], 160
	mov word[finalX], 179
	mov word[positionY], 120
	mov word[finalY], 139
	call printPosition
	ret

getchar:
	mov ah, 0h 
	int 16h
	ret

delay: 
;; Função que aplica um delay(improvisado) baseado no valor de dx
	mov bp, dx
	back:
	dec bp
	nop
	jnz back
	dec dx
	cmp dx,0    
	jnz back
ret

mudarScore: ;mov ax, int / mov di, string
	cmp word[player], 1
	je .mudarScore1

	mov ax, [score2]
	mov di, string
	call tostring

	mov ah, 02h
	mov dh, 2
	mov dl, 12
	int 10h

	mov bl, 13
	mov si, string
	call prints

	ret	


	.mudarScore1:
		mov ax, [score1]
		mov di, string
		call tostring

		mov ah, 02h
		mov dh, 0
		mov dl, 12
		int 10h

		mov bl, 11
		mov si, string
		call prints

		ret

rndGen:
	mov ah, 00h
	int 1AH

	mov ax, dx
	xor dx, dx
	mov cx, 10
	div cx
	mov [bomba], dl
	cmp word[bomba], 9
	je rndGen
	ret


cursor:

	mov cx, [posicao]
	call quadradoCursor

	 ;mov word[bomba], 4

	;  mov bl, 4
	;  mov si, string
	;  call prints
	 
	.loop1:
		call getchar

		cmp al, 'w'
		je .cima

		cmp al, 'a'
		je .esquerda

		cmp al, 's'
		je .baixo

		cmp al, 100
		je .direita

		cmp al, 32
		je .combate

		jmp .loop1

		.combate:
			cmp [bomba], cx
			je .colisao

			mov al, 4
			call printQuadrado
			mov dx, 1500
			call delay
			call quadradoCursor
			ret


			.colisao:

			mov al, 2
			call printQuadrado
			mov dx, 1500
			call delay
			call quadradoCursor

			call rndGen

			cmp word[player], 1
			je .plusp1

			add word[score2], 1
			call mudarScore
			ret
			.plusp1:
				add word[score1], 1
				call mudarScore
				ret

		.cima:
			mov cx, [posicao]
			cmp cx, 2
			jbe .loop1

			call quadradoPadrao

			add cx, -3
			mov word[posicao], cx
			call quadradoCursor

			jmp .loop1

		
		.baixo:
			mov cx, [posicao]
			cmp cx, 6
			jae .loop1

			call quadradoPadrao

			add cx, 3
			mov word[posicao], cx
			call quadradoCursor


			jmp .loop1


		.esquerda:
			mov cx, [posicao]
			
			cmp cx, 0
			je .loop1
			cmp cx, 3
			je .loop1
			cmp cx, 6
			je .loop1

			call quadradoPadrao

			add cx, -1
			mov word[posicao], cx
			call quadradoCursor

			jmp .loop1


		.direita:
			mov cx, [posicao]
			
			cmp cx, 2
			je .loop1
			cmp cx, 5
			je .loop1
			cmp cx, 8
			je .loop1

			call quadradoPadrao

			add cx, 1
			mov word[posicao], cx
			call quadradoCursor

			jmp .loop1


jogada:

	 mov bl, 11
	 mov si, string1
	 call prints

	 mov ah, 02h
	 mov dh, 2
	 mov dl, 0
	 int 10h

	 mov bl, 13
	 mov si, string2
	 call prints

	 mov word[player], 2
	 call mudarScore

	 mov word[player], 1
	 call mudarScore

	 call rndGen

	.jogador1:
		mov al, 11
		mov word[player], 1
		call cursor
		cmp word[score1], 7
		je .fimDeJogo
		jmp .jogador2


	.jogador2:
		mov al, 13
		mov word[player], 2
		call cursor
		cmp word[score2], 7
		je .fimDeJogo
		jmp .jogador1

	.fimDeJogo:
		mov ah, 02h
		mov dh, 4
		mov dl, 12
		int 10h

		mov bl, 10
		mov si, stringFim
		call prints

		mov ah, 02h
		mov dh, 6
		mov dl, 10
		int 10h

		cmp word[player], 1
		je .ganhou1
		mov bl, 10
		mov si, vitoriaP2
		call prints		
		ret
		.ganhou1:
			mov bl, 10
			mov si, vitoriaP1
			call prints
			ret


clear:                    ; mov bl, color
	; Set the cursor to top left-most corner of screen
	mov dx, 0 
	mov bh, 0      
	mov ah, 0x2
	int 0x10

	; print 2000 blank chars to clean  
	mov cx, 2000 
	mov bh, 0
	mov al, 0x20 ; blank char
	mov ah, 0x9
	int 0x10
	
	; reset cursor to top left-most corner of screen
	mov dx, 0 
	mov bh, 0
	mov ah, 0x2
	int 0x10
	ret


start:
	xor ax, ax
  	mov ds, ax
  	mov es, ax


	mov ah, 00h
	mov al, 13h
	int 10h

	mov al, 14
	call printTabuleiro
	call jogada

	mov ah, 00h
	int 16h

times 63*512-($-$$) db 0