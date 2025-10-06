# Ejercicio 4
#
# Este programa realiza la suma sin signo de los 4 bits más significativos
# y de los 4 switches menos significativos de los switches, y guarda esa
# suma en los 4 bits menos significativos de los LEDs. En el caso de que
# ocurra un desborde, se ilumina el 5 bit menos significativo.
#
# Autora: Daniela Fonseca Zumbado

#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

.globl main
main:

li x28, 0xFFFF
li x29, GPIO_INOUT
sw x28, 0(x29)                  # Escribir el Enable Register

next:
    li  a1, GPIO_SWs            # Leer switches, cargar inmediato en a1
    lw  t0, 0(a1)               # Cargar la palabra contenida en a1 en t0

    li  a0, GPIO_LEDs           # Leer LEDs, cargar inmediato en a0
    srl t0, t0, 16              # Aplicar shift right logical 16 bits

    srl t3, t0, 12              # Mover 12 bits a la derecha para obtener los 4 MSB

    li t4, 0x000F               # Crear máscara 0x000F = 0000000000001111
    and t4, t0, t4              # Aplicar máscara a valores de LEDs

    add t3, t3, t4              # Suma sin signo de 4 MSB y 4 LSB

    sw t3, 0(a0)                # Escribir en los LEDs

    beq zero, zero, next
.end
