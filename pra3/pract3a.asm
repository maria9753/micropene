PRACT3A SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS: PRACT3A
    
    ; Función pública
    PUBLIC _comprobarNumeroSecreto
    PUBLIC _rellenarIntento
    
    _comprobarNumeroSecreto PROC FAR
    ; [BP]: IP para el ret
    ; [BP+2]: CS para el ret
    ; [BP+4]: offset del argumento
    ; [BP+6]: segmento del argumento
    PUSH BP         ; Guardar BP para no romperlo
    MOV BP, SP      ; BP apunta al tope de la pila actual
    
    ; [BP]: BP antiguo
    ; [BP+2]: IP para el ret
    ; [BP+4]: CS para el ret
    ; [BP+6]: offset del argumento
    ; [BP+8]: segmento del argumento
    PUSH DS
    MOV SI, [BP+6]  ; Cargar en SI offset del argumento
    MOV AX, [BP+8]
    MOV DS, AX      ; Cargar en DS segmento del argumento
    
    MOV AL, [SI]    ; AL = numero[0]
    CMP AL, [SI+1]
    JE repetido
    CMP AL, [SI+2]
    JE repetido
    CMP AL, [SI+3]
    JE repetido
    MOV AL, [SI+1]  ; AL = numero[1]
    CMP AL, [SI+2]
    JE repetido
    CMP AL, [SI+3]
    JE repetido
    MOV AL, [SI+2]  ; AL = numero[2]
    CMP AL, [SI+3]
    JE repetido
    JMP norepetido
    
repetido:
    MOV AX, 1
    JMP fin

norepetido:
    MOV AX, 0

fin: 
    POP DS
    POP BP
    ret
_comprobarNumeroSecreto ENDP

_rellenarIntento PROC FAR
    ; [BP]: IP para el ret
    ; [BP+2]: CS para el ret
    ; [BP+4]: argumento1
    ; [BP+6]: offset del argumento2
    ; [BP+8]: segmento del argumento2
    PUSH BP         ; Guardar BP para no romperlo
    MOV BP, SP      ; BP apunta al tope de la pila actual
    
    ; [BP]: BP antiguo
    ; [BP+2]: IP para el ret
    ; [BP+4]: CS para el ret
    ; [BP+6]: argumento1
    ; [BP+8]: offset del argumento1
    ; [BP+10]: segmento del argumento1
    PUSH DS
    PUSH SI
    
    MOV SI, [BP+8]  ; Offset del argumento2
    MOV AX, [BP+10]
    MOV DS, AX      ; Cargar segmento del argumento2

    MOV AX, [BP+6]  ; Argumento1
    MOV BX, 10      ; Divisor

    MOV DX, 0       ; Limpiar DX para dividir
    DIV BX          ; Cociente = AX, Resto = DX
    MOV [SI+3] , DL

    MOV DX, 0       ; Limpiar DX para dividir
    DIV BX          ; Cociente = AX, Resto = DX
    MOV [SI+2] , DL

    MOV DX, 0       ; Limpiar DX para dividir
    DIV BX          ; Cociente = AX, Resto = DX
    MOV [SI+1] , DL
    MOV [SI], AL

    POP SI
    POP DS
    POP BP
    ret
_rellenarIntento ENDP

PRACT3A ENDS
END