; DEFINICION DEL SEGMENTO DE DATOS 

DATOS    SEGMENT 
    A DW 10, 0, 0, 0, 1, 0, 0, 0, 1
    RESULT DB "SI", '$'
    AUX DB "NO", '$'
    L0 DB "     ", '$' ; 5 ESPACIOS
    L1 DB "|", '$'
    L2 DB "|", 13, 10, '$'
    L3 DB "C=   ", '$' ; 3 ESPACIOS
    L4 DB " : ES IDENTIDAD ", '$'
    L5 DB " ", '$' ; 1 ESPACIO

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
    
    CMP A, 1
    JNE cambio
    CMP A+2, 0
    JNE cambio
    CMP A+4, 0
    JNE cambio
    CMP A+6, 0
    JNE cambio
    CMP A+8, 1
    JNE cambio
    CMP A+10, 0
    JNE cambio
    CMP A+12, 0 
    JNE cambio
    CMP A+14, 0 
    JNE cambio
    CMP A+16, 1
    JE resultado
    

cambio:
    MOV AX, DATOS
    MOV ES, AX
    MOV SI, OFFSET AUX
    MOV DI, OFFSET RESULT
    MOV CX, 3
    CLD
    REP MOVSB 

resultado:
    MOV DX, OFFSET L0 ; 5 ESPACIOS
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L1 ; |
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L5
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+2
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L5
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+4
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L2
    MOV AH, 9
    int 21h

    MOV DX, OFFSET L3
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L1 ; |
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+6
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L5
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+8
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L5
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+10
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L1 ; |
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L4
    MOV AH, 9
    int 21h
    MOV DX, OFFSET RESULT
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L2
    MOV AH, 9
    int 21h
    
    MOV DX, OFFSET L0 ; 5 ESPACIOS
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L1 ; |
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+12
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L5
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+14
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L5
    MOV AH, 9
    int 21h
    MOV DX, OFFSET A+16
    MOV AH, 9
    int 21h
    MOV DX, OFFSET L2
    MOV AH, 9
    int 21h

    ; FIN DEL PROGRAMA 
    MOV AX, 4C00H 
    INT 21H 

START ENDP 
;_______________________________________________________________ 
; SUBRUTINA PARA CALCULAR EL FACTORIAL DE UN NUMERO 
; ENTRADA CL=NUMERO 
; SALIDA AX=RESULTADO, DX=0 YA QUE CL<=9 
;_______________________________________________________________ 

FACTOR PROC NEAR 
    
FACTOR ENDP 

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END START 

