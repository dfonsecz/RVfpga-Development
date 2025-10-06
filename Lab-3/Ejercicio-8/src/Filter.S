.globl main

# -------------------- Estructuras de datos --------------------

.data
N: .word 6
A: .word 48, 64, 56, 80, 96, 48
B: .space 24 # N*4

.text

# -------------------------- Programa --------------------------

main:
    # Cargar índices i y j
    li t0, 0                        # i = 0
    li t1, 0                        # j = 0

    la s0, A                        # s0 = dirección de A[]
    la s1, B                        # s1 = dirección de B[]
    lw s2, N                        # s2 = N

    for:
        # Verificar condición
        addi t2, s2, -1             # t2 = N - 1
        bge t0, t2, end_for         # Si i < (N - 1), continuar
                                    # sino, salir del loop
        
        # Obtener valor A[i]
        slli t2, t0, 2              # t2 = i << 2 (4*i)
        add t2, t2, s0              # t2 = 4*i + A[0]
        lw t3, 0(t2)                # t3 = A[i]

        # Obtener valor de A[i + 1]
        lw t4, 4(t2)                # t4 = A[i + 1]

        # Establecer A[i] y A[i + 1] como argumentos para myFilter
        mv a0, t3
        mv a1, t4

        # Guardar a0 en la pila
        addi sp, sp, -4
        sw a0, 0(sp)

        # Saltar a la función myFilter
        jal myFilter

        # Verificar resultado de la función myFilter
        if:
            beq a0, zero, out_if    # Si el resultado de myFilter == 1,
                                    # continuar, sino ir a else
            
            # Reestablecer a0 de la pila
            lw a0, 0(sp)
            addi sp, sp, 4

            # Realizar cálculos
            add t4, a0, a1          # t4 = A[i] + A[i + 1]
            addi t4, t4, 2          # t4 = A[i] + A[i + 1] + 2

            # Calcular posición B[j]
            slli t3, t1, 2          # t3 = j << 2 (4*i)
            add t3, t3, s1          # t3 = 4*j + B[0]
            sw t4, 0(t3)            # B[j] = A[i] + A[i + 1] + 2

            # Aumentar índice j
            addi t1, t1, 1          # j = j + 1

        out_if:
            # Aumentar índice i
            addi t0, t0, 1             # i = i + 1

    end_for:
        # Salir del loop y terminar programa
        j terminar

myFilter:
    li t2, 16                       # t2 = 16
    rem t2, a0, t2                  # t2 = a0 % 16

    bne t2, zero, salir_myFilter    # Si a0 no es múltiplo de 16, salir

    # Comparar si a0 < a1
    bge a0, a1, salir_myFilter      # Si a0 < a1, continuar, sino salir

    li a0, 1                        # Si pasa los filtros, retornar a0 = 1

    # Regresar a dirección de retorno
    jr ra

salir_myFilter:
    li a0, 0                        # Si no pasa los filtros, retornar a0 = 0

    # Regresar a dirección de retorno
    jr ra

terminar:
    # Terminar programa
.end