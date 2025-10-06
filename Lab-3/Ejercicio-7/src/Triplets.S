.globl main

# -------------------- Estructuras de datos --------------------

.data
N: .word 3
A: .word 7, 3, 2, 4, 5, 1, 8, 9, 6
B: .space 12 # N*4

.text

# -------------------------- Programa --------------------------

main:
    # Cargar índices i y j
    li t0, 0                    # i = 0
    li t1, 0                    # j = 0

    la s0, A                    # s0 = dirección de A[]
    la s1, B                    # s1 = dirección de B[]
    lw s2, N                    # s2 = N

    for_1:
        bge t0, s2, end_for_1   # Si i < N, continuar
                                # sino, terminar loop

        # Establecer argumentos para res_triplet
        mv a0, s0               # a0 = dirección de A[]
        mv a1, t1               # a1 = j

        # Guardar en la pila
        addi sp, sp, -4
        sw ra, 0(sp)

        # Saltar a función res_triplet
        jal res_triplet

        # Restaurar pila
        lw ra, 0(sp)
        addi sp, sp, 4

        # Guardar resultado en B[i]
        slli t2, t0, 2
        add t2, s1, t2
        sw a0, 0(t2)

        addi t1, t1, 3          # j = j + 3
        addi t0, t0, 1          # i = i + 1

        # Reiniciar for_1
        j for_1

    end_for_1:
        # Terminar programa
        j terminar

res_triplet:
    li t2, 0                    # i = 0 (i diferente del anterior)
    li t3, 0                    # sum = 0

    for_2:
        li t4, 3
        bge t2, t4, end_for_2   # Si i < 3, continuar
                                # sino, terminar loop
        
        add t5, t2, a1          # t5 = i + pos
        slli t5, t5, 2
        add t5, t5, a0
        lw t5, 0(t5)            # Cargar en t5 = V[pos + i]

        add t3, t3, t5          # sum = sum + V[pos + i]

        # Aumentar índice
        addi t2, t2, 1          # i = i + 1

        # Reiniciar for_2
        j for_2

    end_for_2:
        # Establecer parámetro para función abs
        mv a0, t3               # a0 = t3

        # Saltar a la función abs
        jal abs

        # Regresar a la dirección de retorno
        jr ra

abs:
    # Comparar sum con cero
    bge a0, zero, abs_salir     # Si sum < 0, continuar
                                # sino, salir de la función
    
    # Reemplazar a0 por su valor negado (para que quede +)
    neg a0, a0

abs_salir:
    # Regresar a la dirección de retorno
    jr ra

terminar:
    # Termina el programa
.end