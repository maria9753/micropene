DATOS SEGMENT
    jug1_x db 20
    jug1_y db 12
    jug2_x db 60
    jug2_y db 12
DATOS ENDS

PILA SEGMENT STACK
    db 256 dup(?)
PILA ENDS

CODIGO SEGMENT
    ASSUME CS:CODIGO, DS:DATOS, SS:PILA

inicio:
    MOV AX, DATOS
    MOV DS, AX

    MOV AH, 00h     ; Establecer modo de vídeo
    MOV AL, 03h     ; Modo de exto 80x25 con 16 colores
    INT 10h

    CALL JUG1_PINTAR
    CALL JUG2_PINTAR

bucle:
    MOV AH, 01h     ; Comprobar si se ha pulsado una tecla
    INT 16h
    JZ bucle        ; Si Z=1, no se ha pulsado ninguna tecla

    MOV AH, 00h     ; Leer tecla pulsada, se guarda en AL
    INT 16h         

    CMP AL, 'q'     ; Si la tecla es q, salir
    JNE teclas
    MOV AX, 4C00h   ; Acabar el programa si es q
    INT 21h

teclas:
    CMP AL, 'w'     ; Teclas del jugador 1
    JE jug1_arriba
    CMP AL, 's'
    JE jug1_abajo
    CMP AL, 'a'
    JE jug1_izquierda
    CMP AL, 'd'
    JE jug1_derecha

    CMP AL, 'i'     ; Teclas del jugador 2
    JE jug2_arriba
    CMP AL, 'k'
    JE jug2_abajo
    CMP AL, 'j'
    JE jug2_izquierda
    CMP AL, 'l'
    JE jug2_derecha

    JMP bucle       ; Otras teclas: esperar a pulsar otra tecla

jug1_arriba:
    CMP jug1_y, 24
    JE saltar_bucle1
    INC jug1_y
    JMP llamar_jug1_pintar

jug1_abajo:
    CMP jug1_y, 0
    JE saltar_bucle1
    DEC jug1_y
    JMP llamar_jug1_pintar

jug1_izquierda:
    CMP jug1_x, 0
    JE saltar_bucle1
    DEC jug1_x
    JMP llamar_jug1_pintar

jug1_derecha:
    CMP jug1_x, 79
    JE saltar_bucle1
    INC jug1_x
    JMP llamar_jug1_pintar

llamar_jug1_pintar: 
    CALL JUG1_PINTAR
    JMP bucle
saltar_bucle1:
    JMP bucle

jug2_arriba:
    CMP jug2_y, 24
    JE saltar_bucle2
    INC jug2_y
    JMP llamar_jug2_pintar

jug2_abajo:
    CMP jug2_y, 0
    JE saltar_bucle2
    DEC jug2_y
    JMP llamar_jug2_pintar

jug2_izquierda:
    CMP jug2_x, 0
    JE saltar_bucle2
    DEC jug2_x
    JMP llamar_jug2_pintar

jug2_derecha:
    CMP jug2_x, 79
    JE saltar_bucle2
    INC jug2_x
    JMP llamar_jug2_pintar

llamar_jug2_pintar: 
    CALL JUG2_PINTAR
saltar_bucle2:
    JMP bucle

JUG1_PINTAR PROC
    MOV AL, jug1_x
    MOV AH, jug1_y
    INT 55h
    RET
JUG1_PINTAR ENDP

JUG2_PINTAR PROC
    MOV AL, jug2_x
    MOV AH, jug2_y
    INT 57h
    RET
JUG2_PINTAR ENDP

CODIGO ENDS
END inicio