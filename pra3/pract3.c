int main( void ) {
    unsigned char numSecreto[4] = {1, 2, 2, 4}; // Forzamos un repetido para probar
    unsigned char intentoDigitos[4];
    unsigned int intento = 4567;
    unsigned int repetido;

    // 1. Probar comprobarNumeroSecreto
    printf("Probando repetidos en {1,2,2,4}...\n");
    repetido = comprobarNumeroSecreto(numSecreto);
    if (repetido == 1) 
        printf("RESULTADO: Detectado repetido (BIEN)\n");
    else 
        printf("RESULTADO: No detectado (ERROR)\n");

    // 2. Probar rellenarIntento
    printf("\nProbando rellenarIntento con %u...\n", intento);
    rellenarIntento(intento, intentoDigitos);
    printf("Array resultante: [%u, %u, %u, %u]\n", 
            intentoDigitos[0], intentoDigitos[1], intentoDigitos[2], intentoDigitos[3]);
    
    return 0;
}