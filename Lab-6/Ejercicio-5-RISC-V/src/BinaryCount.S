# Programa en ensamblador RISC-V que implementa un contador binario que se
# muestra en los LEDs de una Nexys A7-100T.
#
# El programa implementa un contador que incrementa su valor en 1 progresiva-
# mente, mostrando el valor actual en los LEDs. La velocidad de conteo se puede
# ajustar mediante el botón central de la placa, el cual está conectado al bit[0]
# del puerto GPIO2. Cada vez que se presiona el botón, la velocidad de conteo
# aumenta, al reducir el tiempo de retardo entre incrementos.
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define GPIO2_BTNs  0x80001800
#define GPIO2_INOUT 0x80001808

#define DEFAULT_DELAY 0x1000000
#define SPEED_LEVEL 1

.globl main

main:

    # Configurar GPIO como salida
    li x28, 0xFFFF                      
    li a0, GPIO_INOUT
    sw x28, 0(a0)

    li t0, 0x0001                       # Valor inicial a mostrar en LEDs 
    li t3, SPEED_LEVEL                  # Nivel de velocidad por defecto

# Incrementar actualizar los LEDs e incrementar el contador
binaryCount:
    # Cargar valor en LEDs
    li a0, GPIO_LEDs                    # Cargar dirección de LEDs
    sw t0, 0(a0)                        # Cargar valor a representar en LEDs
    li a0, 0                            # Reiniciar a0
    sw t0, 0(a0)                        # Escribir a LEDs

    # Incrementar contador
    addi t0, t0, 1                      # Sumar 1

    # Configurar delay
    li t1, DEFAULT_DELAY                # Cargar valor de delay

setDelay:
    # Leer botones para ajustar nivel de velocidad
    li a1, GPIO2_BTNs                   # Cargar dirección de botones
    lw t2, 0(a1)                        # Cargar valor en los botones
    andi t2, t2, 0x0001                 # Aplicar máscara para tomar bit[0]
    bne t2, zero, increaseSpeedLevel    # Si bit[0] es 1, aumentar nivel

    j setSpeed                          # Si no, continuar aplicando delay actual

# Si se presiona el botón, aumentar nivel de velocidad
increaseSpeedLevel:
    addi t3, t3, 1                      # Aumentar nivel de velocidad

# Configurar la velocidad según el nivel
setSpeed:
    div t1, t1, t3                      # Delay / nivel

# Aplicar delay
addDelay:
    addi t1, t1, -1                     # Decrementar contador
    bne t1, zero, addDelay              # Si no es 0, seguir esperando
    j binaryCount                