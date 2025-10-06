# Ejercicio 2
#
# Este programa lee el valor de entrada de los switches, obtiene su valor
# inverso, bit por bit, y carga este valor inverso en los LEDs, de modo
# que, al "encender" el switch, el LED respectivo se "apaga", y viceversa.
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

    li t3, 0xFFFF               # Cargar máscara
    xor t3, t0, t3              # Hacer toggle a valores de los bits de los LEDs t3 = GPIO_LEDs ^ 0xFFFF

    sw  t3, 0(a0)               # Escribir en los LEDs

    beq zero, zero, next
.end
