/** Ejercicio 1
 * Este programa flashea los valores de los switches.
 */

// memory-mapped I/O addresses
#define GPIO_SWs 0x80001400
#define GPIO_LEDs 0x80001404
#define GPIO_INOUT 0x80001408
#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

void delay(volatile unsigned int counter) {
    while (counter > 0) {
        counter--;
    }
}

int main ( void )
{
    int En_Value=0xFFFF, switches_value;
    WRITE_GPIO(GPIO_INOUT, En_Value);
    while (1) {
        // Leer el valor de los switches
        switches_value = READ_GPIO(GPIO_SWs);

        // Hacer shift a los 16 bits más bajos
        switches_value = switches_value >> 16;

        // Mostrar el valor de los switches en los LEDs
        WRITE_GPIO(GPIO_LEDs, switches_value);

        // Agregar delay
        delay(5000000);

        // Apagar todos los switches
        WRITE_GPIO(GPIO_LEDs, 0);

        // Agregar delay
        delay(5000000);
    }
    return(0);
}