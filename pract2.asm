; DEFINICION DEL SEGMENTO DE DATOS 

DATOS    SEGMENT 
    A DB -32, 54, 54, 2, -34, 0, 0, 0, 1
    B DB 1, 0, 0, 0, 1, 0, 0, 0, 1
    RES DW 9 DUP (0)
    I DW 1, 0, 0, 0, 1, 0, 0, 0, 1
    RESULT DB "SI", '$'
    AUX DB "NO", '$'
    L0 DB "        ", '$' ; 5 ESPACIOS
    L1 DB "|", '$'  
    L2 DB 13, 10, '$'
    L3 DB "C =     ", '$' ; 3 ESPACIOS
    L4 DB "Resultado = B ", '$'
    L5 DB " ", '$' ; 1 ESPACIO
    L6 DB "A * B = ", '$'
    L7 DB " * ", '$'
    L8 DB " = C", '$'
    L9 DB " es la matriz inversa de A", '$'
    L10 DB "-", '$'
    L11 DB "   ", '$' ; 3 ESPACIOS

DATOS ENDS 

; DEFINICION DEL SEGMENTO DE PILA 

PILA    SEGMENT STACK "STACK" 
    DB   40H DUP (0) 
PILA ENDS 


; DEFINICION DEL SEGMENTO EXTRA 

EXTRA     SEGMENT 

EXTRA ENDS 


; DEFINICION DEL SEGMENTO DE CODIGO 

CODE    SEGMENT 
    ASSUME CS:CODE, DS:DATOS, ES: EXTRA, SS:PILA 

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 

START PROC 
    ;INICIALIZA LOS REGISTROS DE SEGMENTO CON SUS VALORES 
    MOV AX, DATOS 
    MOV DS, AX 

    MOV AX, PILA 
    MOV SS, AX 

    MOV AX, EXTRA 
    MOV ES, AX 

    ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 
    MOV SP, 64 

    ; FIN DE LAS INICIALIZACIONES 

    ;COMIENZO DEL PROGRAMA 
    
    CALL MULTIPLICAR
    CALL COMPROBAR_ID

    CALL IMPRIMIR_5ESP
    MOV AX, 0
    MOV SI, AX
    MOV BX, OFFSET A
    CALL IMPRIMIR_LINAB
    CALL IMPRIMIR_3ESP
    MOV BX, OFFSET B
    CALL IMPRIMIR_LINAB
    CALL IMPRIMIR_SALTO
    CALL IMPRIMIR_AB
    ADD SI, 3
    MOV BX, OFFSET A 
    CALL IMPRIMIR_LINAB
    CALL IMPRIMIR_PUN
    MOV BX, OFFSET B 
    CALL IMPRIMIR_LINAB
    CALL IMPRIMIR_C2
    CALL IMPRIMIR_SALTO
    CALL IMPRIMIR_5ESP
    ADD SI, 3
    MOV BX, OFFSET A
    CALL IMPRIMIR_LINAB
    CALL IMPRIMIR_3ESP
    MOV BX, OFFSET B
    CALL IMPRIMIR_LINAB
    CALL IMPRIMIR_SALTO
    CALL IMPRIMIR_5ESP
    SUB SI, 6
    MOV BX, OFFSET RES
    CALL IMPRIMIR_LINC
    CALL IMPRIMIR_SALTO
    CALL IMPRIMIR_C1
    ADD SI, 6
    CALL IMPRIMIR_LINC
    CALL IMPRIMIR_SALTO
    CALL IMPRIMIR_5ESP
    ADD SI, 6
    CALL IMPRIMIR_LINC
    CALL IMPRIMIR_SALTO
    CALL IMPRIMIR_RES

    MOV AX, 4C00h
    int 21h

START ENDP 

;_______________________________________________________________ 
; SUBRUTINA QUE CAMBIA EL VALOR DE LA VARIABLE RESULT EN FUNCIÓN
; DE SI LA MATRIZ ES LA IDENTIDAD
;_______________________________________________________________ 
COMPROBAR_ID PROC 
    PUSH AX     ; Guardar contexto
    PUSH SI
    PUSH DI
    PUSH CX
    PUSH ES
    
    MOV SI, 0   ; Índice de la matriz
    MOV CX, 9   ; 9 elementos a comprobar

comparacion:
    MOV AX, RES[SI]
    CMP AX, I[SI]
    JNE cambio
    ADD SI, 2
    DEC CX
    JNZ comparacion
    JMP fin1

cambio:
    MOV AX, DATOS
    MOV ES, AX
    MOV SI, OFFSET AUX
    MOV DI, OFFSET RESULT
    MOV CX, 3
    CLD
    REP MOVSB 

fin1:
    POP ES
    POP CX
    POP DI
    POP SI
    POP AX
    RET
COMPROBAR_ID ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA MULTIPLICAR DOS MATRICES Y GUARDAR EL
; RESULTADO EN OTRA
;_______________________________________________________________ 
MULTIPLICAR PROC
    PUSH AX     ; Guardar contexto.
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    PUSH BP

    MOV BP, 0   ; Índice para C (saltos de 2)
    MOV SI, 0   ; Índice de fila de A (saltos de 3)
    
bucleFilas:
    MOV DI, 0   ; Índice de columna de B(saltos de 1)

bucleColumnas:
    PUSH SI     ; Fila actual de A
    PUSH DI     ; Columna actual de B
    
    ; Primer elemento
    MOV AL, A[SI]   
    MOV BL, B[DI]
    IMUL BL      ; AX = AL * BL
    MOV CX, AX  ; Guardar el resultado en CX
    
    ; Segundo elemento
    INC SI      ; Siguiente elemento en la fila de A
    ADD DI, 3   ; Siguiente elemento en la columna de B
    MOV AL, A[SI]
    MOV BL, B[DI]
    IMUL BL      ; AX = AL * BL
    ADD CX, AX  ; Sumar el nuevo resultado al anterior en CX
    
    ; Tercer elemento
    INC SI      ; Siguiente elemento en la fila de A
    ADD DI, 3   ; Siguiente elemento en la columna de B
    MOV AL, A[SI]
    MOV BL, B[DI]
    IMUL BL      ; AX = AL * BL
    ADD CX, AX  ; Sumar el último resultado al anterior en CX

    ; Guardar en C
    MOV DI, BP  ; Usar DI como índice temporal para C
    MOV RES[DI], CX
    ADD BP, 2   ; Aumentar índice de C para el siguiente elemento
    
    POP DI      ; Recuperar columna actual de B
    POP SI      ; Recuperar fila actual de A
    
    INC DI      ; Siguiente columna
    CMP DI, 3   ; ¿Se han hecho ya las tres columnas de una fila?
    JNE bucleColumnas
    
    ; Si se han hecho ya los tres elementos de una fila
    ADD SI, 3   ; Siguiente fila
    CMP SI, 9   ; ¿Se han hecho ya las tres filas completas?
    JNE bucleFilas
    
    ; Si ya se han hecho todos los elementos de las tres filas
    POP BP      ; Recuperar contexto
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
MULTIPLICAR ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UN NÚMERO DE UNO O 
; VARIOS DÍGITOS EN ASCII 
;_______________________________________________________________ 
IMPRIMIR_NUM PROC 
    PUSH AX     ; Guardar contexto
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0   ; Contador de dígitos
    MOV BX, 10  ; Divisor
    MOV BP, 0

    CMP AX, 0   ; Ver si es positivo o negativo
    JGE divi    ; Si es positivo, se salta lo siguiente
    
    PUSH AX
    MOV AH, 9   ; Imprimir "-"
    MOV DX, OFFSET L10
    int 21h
    POP AX
    NEG AX
    MOV DX, 1
    MOV BP, DX
    
divi:
    MOV DX, 0   ; Limpiar DX para la división (DX:AX)
    DIV BX      ; AX = cociente, DX = resto, BX = divisor, (DX:AX) = dividento (antes de realizar la operación)
    PUSH DX     ; Guardar resto en la pila
    INC CX      ; Incrementar contador de dígitos
    CMP AX, 0   ; ¿El cociente es 0?
    JNE divi    ; Si no es 0, volver a dividir
    
    ADD BP, CX  ; Guardar temporalmente el número de dígitos
    
impri:
    POP DX      ; Sacar el último resto, que será el primer dígito
    ADD DL, 30h ; Sumarle 30h para pasarlo a ASCII
    MOV AH, 02h ; Función que imprime un caracter
    int 21h
    
    DEC CX      ; En CX estaba el número de dígitos
    JNZ impri   ; Si CX no es 0, todavía quedan dígitos y se repite
    
    MOV CX, 5   ; Cada celda ocupa 5 espacios
    SUB CX, BP  ; Mirar cuántos espacios hay sin ocupar, se guarda en CX
    JZ fin2     ; Si es 0, acabar
    
esps: 
    CALL IMPRIMIR_ESP
    DEC CX
    JNZ esps

fin2:
    POP DX      ; Recuperar contexto
    POP CX
    POP BX
    POP AX
    RET
IMPRIMIR_NUM ENDP 

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR EL RESULTADO
;_______________________________________________________________ 
IMPRIMIR_RES PROC 
    MOV AH, 9

    MOV DX, OFFSET L4
    int 21h

    MOV DX, OFFSET RESULT
    int 21h
    
    MOV DX, OFFSET L9
    int 21h
    
    RET
IMPRIMIR_RES ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UN SALTO DE LÍNEA
;_______________________________________________________________ 
IMPRIMIR_SALTO PROC 
    MOV AH, 9

    MOV DX, OFFSET L2
    int 21h

    RET
IMPRIMIR_SALTO ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR A · B =
;_______________________________________________________________ 
IMPRIMIR_AB PROC 
    MOV AH, 9

    MOV DX, OFFSET L6
    int 21h

    RET
IMPRIMIR_AB ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UN ESPACIO
;_______________________________________________________________ 
IMPRIMIR_ESP PROC 
    MOV AH, 9
    
    MOV DX, OFFSET L5
    int 21h

    RET
IMPRIMIR_ESP ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR CINCO ESPACIOS
;_______________________________________________________________ 
IMPRIMIR_5ESP PROC 
    MOV AH, 9
    
    MOV DX, OFFSET L0
    int 21h

    RET
IMPRIMIR_5ESP ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR TRES ESPACIOS
;_______________________________________________________________ 
IMPRIMIR_3ESP PROC 
    MOV AH, 9
    
    MOV DX, OFFSET L11
    int 21h

    RET
IMPRIMIR_3ESP ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UNA LÍNEA DE LA MATRÍZ C
; Parámetros: 
;   - BX = dirección de inicio de la matríz
;   - SI = desplazamiento (0, 6 o 12)
;_______________________________________________________________ 
IMPRIMIR_LINC PROC 
    PUSH AX
    PUSH DX
    PUSH CX
    PUSH BX
    
    ADD BX, SI

    CALL IMPRIMIR_BAR
    MOV AX, [BX]
    CALL IMPRIMIR_NUM
    ADD BX, 2
    CALL IMPRIMIR_ESP
    MOV AX, [BX]
    CALL IMPRIMIR_NUM
    ADD BX, 2
    CALL IMPRIMIR_ESP
    MOV AX, [BX]
    CALL IMPRIMIR_NUM
    CALL IMPRIMIR_BAR

    POP BX
    POP CX
    POP DX
    POP AX
    RET
IMPRIMIR_LINC ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UNA LÍNEA DE LA MATRÍZ A O B
; Parámetros: 
;   - BX = dirección de inicio de la matríz
;   - SI = desplazamiento (0, 3 O 6)
;_______________________________________________________________ 
IMPRIMIR_LINAB PROC 
    PUSH AX
    PUSH DX
    PUSH CX
    PUSH BX
    
    ADD BX, SI

    CALL IMPRIMIR_BAR
    MOV AH, 0
    MOV AL, [BX]
    CMP AL, 0
    JGE normal1
    MOV AH, 0FFh
normal1: 
    CALL IMPRIMIR_NUM
    INC BX
    CALL IMPRIMIR_ESP
    MOV AH, 0
    MOV AL, [BX]
    CMP AL, 0
    JGE normal2
    MOV AH, 0FFh
normal2: 
    CALL IMPRIMIR_NUM
    INC BX
    CALL IMPRIMIR_ESP
    MOV AH, 0
    MOV AL, [BX]
    CMP AL, 0
    JGE normal3
    MOV AH, 0FFh
normal3: 
    CALL IMPRIMIR_NUM
    CALL IMPRIMIR_BAR

    POP BX
    POP CX
    POP DX
    POP AX
    RET
IMPRIMIR_LINAB ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UNA BARRA
;_______________________________________________________________
IMPRIMIR_BAR PROC 
    MOV AH, 9

    MOV DX, OFFSET L1
    int 21h

    RET
IMPRIMIR_BAR ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR UN · 
;_______________________________________________________________
IMPRIMIR_PUN PROC 
    MOV AH, 9

    MOV DX, OFFSET L7
    int 21h

    RET
IMPRIMIR_PUN ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR C =
;_______________________________________________________________
IMPRIMIR_C1 PROC 
    MOV AH, 9

    MOV DX, OFFSET L3
    int 21h

    RET
IMPRIMIR_C1 ENDP 

;_______________________________________________________________ 
; SUBRUTINA PARA IMPRIMIR = C
;_______________________________________________________________
IMPRIMIR_C2 PROC 
    MOV AH, 9

    MOV DX, OFFSET L8
    int 21h

    RET
IMPRIMIR_C2 ENDP 

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END START 
