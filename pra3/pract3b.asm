PRACT3B SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS: PRACT3B
    
    ; Función pública
    PUBLIC _calcularAciertos
    PUBLIC _calcularSemiaciertos
    
    _calcularAciertos PROC FAR
    ; [BP]: IP para el ret
    ; [BP+2]: CS para el ret
    ; [BP+4]: offset del argumento1
    ; [BP+6]: segmento del argumento1
    ; [BP+8]: offset del argumento2
    ; [BP+10]: segmento del argumento2
    PUSH BP         ; Guardar BP para no romperlo
    MOV BP, SP      ; BP apunta al tope de la pila actual
    
    ; [BP]: BP antiguo
    ; [BP+2]: IP para el ret
    ; [BP+4]: CS para el ret
    ; [BP+6]: offset del argumento1
    ; [BP+8]: segmento del argumento1
    ; [BP+10]: offset del argumento2
    ; [BP+12]: segmento del argumento2
    PUSH DS
    PUSH SI
    PUSH DI

    MOV SI, [BP+6]  ; Cargar en SI offset del argumento1
    MOV AX, [BP+8]
    MOV DS, AX      ; Cargar en DS segmento del argumento1
    
    MOV DI, [BP+10] ; Cargar en SI offset del argumento2
    MOV AX, [BP+12]
    MOV ES, AX      ; Cargar en DS segmento del argumento2
    
    MOV DX, 0       ; Contador de aciertos
    MOV CX, 4       ; Contador de dígitos
    
bucle:
    MOV AL, DS:[SI]
    MOV BL, ES:[DI]
    CMP AL, BL
    JNE fallo1
    INC DX

fallo1:
    INC SI
    INC DI
    SUB CX, 1
    JNZ bucle

    MOV AX, DX

    POP DI
    POP SI
    POP DS
    POP BP
    ret
_calcularAciertos ENDP

_calcularSemiaciertos PROC FAR
    ; [BP]: IP para el ret
    ; [BP+2]: CS para el ret
    ; [BP+4]: offset del argumento1
    ; [BP+6]: segmento del argumento1
    ; [BP+8]: offset del argumento2
    ; [BP+10]: segmento del argumento2
    PUSH BP         ; Guardar BP para no romperlo
    MOV BP, SP      ; BP apunta al tope de la pila actual
    
    ; [BP]: BP antiguo
    ; [BP+2]: IP para el ret
    ; [BP+4]: CS para el ret
    ; [BP+6]: offset del argumento1
    ; [BP+8]: segmento del argumento1
    ; [BP+10]: offset del argumento2
    ; [BP+12]: segmento del argumento2
    PUSH DS
    PUSH SI
    PUSH DI
    
    MOV SI, [BP+6]  ; Offset del argumento1
    MOV AX, [BP+8]
    MOV DS, AX      ; Cargar segmento del argumento1
    
    MOV DI, [BP+10]  ; Offset del argumento2
    MOV AX, [BP+12]
    MOV ES, AX      ; Cargar segmento del argumento2

    MOV DX, 0       ; Contador de semiaciertos
    MOV BX, 0       ; Contador en argumento1

bucleSI:
    CMP BX, 4       ; Si son iguales, ya se han comprobado los 4 números de argumento1
    JE fin
    MOV CX, 0       ; Contador en argumento2
    PUSH DI         ; Guardamos DI para cada número de argumento1

bucleDI:
    CMP CX, 4       ; Si son iguales, ya se han comprobado los 4 números de argumento2
    JE salirBucleDI
    CMP BX, CX      ; Si son el mismo índice incrementamos el contador de argumento2
    JE fallo2

    MOV AL, DS:[SI] ; Comparamos un número de argumento1 con otro de argumento2
    MOV AH, ES:[DI]
    CMP AL, AH
    JNE fallo2       ; Si no son el mismo, no sumamos un semiacierto
    INC DX
    
fallo2:
    INC DI          ; Incrementamos contador argumento2 
    INC CX
    JMP bucleDI     ; Siguiente número de argumento2
    
salirBucleDI:
    POP DI
    INC SI
    INC BX
    JMP bucleSI

fin:
    MOV AX, DX

    POP DI
    POP SI
    POP DS
    POP BP
    ret
_calcularSemiaciertos ENDP

PRACT3B ENDS
END
