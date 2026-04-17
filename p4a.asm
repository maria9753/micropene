CODIGO SEGMENT
    ASSUME CS:CODIGO
    ORG 256

inicio:
    JMP ejecutar
    
    firma_digital db 'SNAKE'; Huella para comprobar si la rutina ya está instalada
    snake db '*'            ; Carácter de la serpiente
    instalado db 's'        ; Flag: s si instalado, n si no
    autor db 'Autor: Maria Pozo', 13, 10, '$'
    uso db 'Uso: p4a.com [/I || /D]', 13, 10, '$'
    estado1 db 'Estado: ', '$'
    estado2 db 'instalado', 13, 10, '$'
    no db 'no ', '$' 

    ; Reciben en AL la posición X y en AH la posición Y.
rsi55h PROC 
    PUSH DX
    PUSH AX
    PUSH BX
    PUSH CX

    MOV DH, AH              ; Guardar posición en otros registros
    MOV DL, AL

    MOV AH, 02h             ; Mover el cursor a (X, Y)
    MOV BH, 0               ; Página de vídeo, 0 por defecto
    INT 10h

    MOV AH, 09h             ; Escribir carácter
    MOV AL, CS:snake
    MOV BL, 09h
    MOV CX, 1
    INT 10h

    POP CX
    POP BX
    POP AX
    POP DX
    
    IRET
rsi55h ENDP

rsi57h PROC 
    PUSH DX
    PUSH AX
    PUSH BX
    PUSH CX

    MOV DH, AH              ; Guardar posición en otros registros
    MOV DL, AL

    MOV AH, 02h             ; Mover el cursor a (X, Y)
    MOV BH, 0               ; Página de vídeo, 0 por defecto
    INT 10h

    MOV AH, 09h             ; Escribir carácter
    MOV AL, CS:snake
    MOV BL, 04h
    MOV CX, 1
    INT 10h

    POP CX
    POP BX
    POP AX
    POP DX
    
    IRET
rsi57h ENDP

ejecutar:
    PUSH CS
    POP DS

    ; Mirar si está instalado o no
    XOR AX, AX
    MOV ES, AX
    MOV AX, ES:[55h*4]      ; Offset de rsi55h
    MOV BX, ES:[55h*4+2]    ; Segmento de rsi55h
    CMP AX, 0
    JNZ comprobar_firma
    CMP BX, 0
    JZ cambio_instalado

comprobar_firma:
    MOV ES, BX
    MOV BX, OFFSET firma_digital
    CMP BYTE PTR ES:[BX], 'S'
    JNE cambio_instalado
    CMP BYTE PTR ES:[BX+1], 'N'
    JNE cambio_instalado
    CMP BYTE PTR ES:[BX+2], 'A'
    JNE cambio_instalado
    CMP BYTE PTR ES:[BX+3], 'K'
    JNE cambio_instalado
    CMP BYTE PTR ES:[BX+4], 'E'
    JE parametros

cambio_instalado:
    MOV instalado, 'n'

    ; Dependiendo de los parámetros de hace una cosa u otra
parametros:
    PUSH CS
    POP ES

    MOV SI, 82h
    MOV AL, ES:[SI]
    CMP AL, '/'
    JNE mostrar

    INC SI
    MOV AL, ES:[SI]
    CMP AL, 'I'
    JE instalar
    CMP AL, 'D'
    JE desinstalar
    JMP mostrar

instalar:
    CMP instalado, 's'
    JE fin

    XOR AX, AX
    MOV ES, AX

    CLI
    MOV AX, OFFSET rsi55h
    MOV ES:[55h*4], AX
    MOV ES:[55h*4+2], CS
    MOV AX, OFFSET rsi57h
    MOV ES:[57h*4], AX
    MOV ES:[57h*4+2], CS
    STI
    
    MOV DX, OFFSET ejecutar
    INT 27h

mostrar:    
    MOV AH, 09h
    MOV DX, OFFSET estado1
    INT 21h
    CMP instalado, 's'
    JE si_instalado
    MOV DX, OFFSET no
    INT 21h
si_instalado:    
    MOV DX, OFFSET estado2
    INT 21h
    MOV DX, OFFSET autor
    INT 21h
    MOV DX, OFFSET uso
    INT 21h
    RET

desinstalar:
    CMP instalado, 'n'
    JE fin

    XOR AX, AX
    MOV ES, AX

    CLI
    MOV ES:[55h*4], AX
    MOV ES:[55h*4+2], AX
    MOV ES:[57h*4], AX
    MOV ES:[57h*4+2], AX
    STI

    RET

fin:
    RET

CODIGO ENDS
END inicio