org 0x7c00
jmp 0x0000:start

data:
    positionX dw 40
    positionY dw 57
    finalX dw 9
    finalY dw 9
    X dw 14
    Y dw 0
    VX times 640 dw 0
    VY times 640 dw 0

delay: 
;; Função que aplica um delay(improvisado) baseado no valor de dx
    push dx
    mov dx, 2300
	mov bp, dx
	back:
        dec bp
        nop
        jnz back
        dec dx
        cmp dx,0    
        jnz back
    pop dx
    ret

printPixel:				  	; Imprime al em cx, dx
    push bx
    xor bx, bx
	mov ah, 0ch
	int 10h
    pop bx
	ret

alfa:                       ; Converte coordenadas da matriz para coordenadas em pixel e seta para printPosition
    mov ax, word[X]
    mov dx, 10
    mul dx
    mov [positionX], ax
    add ax, 9
    mov [finalX], ax
    
    mov ax, word[Y]
    mov dx, 10
    mul dx
    mov [positionY], ax
    add ax, 9
    mov [finalY], ax
    ret
    

printPosition:			  	; Imprime um quadrado nas coordenadas dadas da grade de 32x20 na cor de al
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
	ret

start:
    xor ax, ax
    mov es, ax
    mov ds, ax

    mov ah, 00h
    mov al, 13h
    int 10h

; IMPRIME QUADRADO
    call alfa
    mov al, 14
    call printPosition

    ; mov bx, X
    ; mov word[bx], 15
    ; call alfa
    ; mov al, 14
    ; call printPosition


    
; IMPRIME PIXEL ISOLADO
    ; mov cx, [positionX]
    ; mov dx, [positionY]
    ; call printPixel

;IMPRIME CARACTER ISOLADO
    ; mov bl, 14
    ; xor ax, ax
    ; mov al, 10
    ; mov dx, 10
    ; mul dx
    ; mov ah, 0eh
    ; int 10h

    ; mov al, 14
    ; call printPosition

times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final do setor