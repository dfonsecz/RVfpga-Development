/** Ejercicio 3
 * Este desplaza hacia atrás y hacia adelante el número
 * cada vez mayor de leds iluminados hasta que todos estén encendidos.
 * Luego, el patrón se repite.
 * 
 * 1. Un led encendido se desplaza de derecha a izquierda, y luego de
 * izquierda a derecha.
 * 2. Dos leds iluminados se desplazan de derecha a izquierda, y luego
 * de izquierda a derecha.
 * 3. Tres leds iluminados se desplazan de derecha a izquierda, y luego
 * de izquierda a derecha.
 * 4. Así continúa sucesivamente, incrementando la cantidad de leds,
 * hasta que se enciendan todos.
 * 5. El patrón se repite.
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

void displaceLeft(int led_value, int limit) {
    
    while (1) {
        // Si el LED es menor o igual al de la posición 16
        if (led_value <= limit) {
            // Poner en alto el LED actual
            WRITE_GPIO(GPIO_LEDs, led_value);

            // Agregar un retardo
            delay(2000000);

            // Apagar el LED
            WRITE_GPIO(GPIO_LEDs, 0);

            // Desplazar LED encendido a la izquierda
            led_value = led_value << 1;
        } else {
            return;
        }
        
    }

    limit++;
    
}

void displaceRight(int led_value, int limit) {
    
    while (1) {
        // Si el LED es menor o igual al de la posición 16
        if (led_value >= limit) {
            // Poner en alto el LED actual
            WRITE_GPIO(GPIO_LEDs, led_value);

            // Agregar un retardo
            delay(2000000);

            // Apagar el LED
            WRITE_GPIO(GPIO_LEDs, 0);

            // Desplazar LED encendido a la izquierda
            led_value = led_value >> 1;
        } else {
            return;
        }
        
    }
    
}

int main(void) {
    int En_Value=0xFFFF;
    int limit_left = 0x8000;
    int limit_right = 0x0001;
    int led_value_left = 1;
    int led_value_right = 0x8000;
    int counter = 0;

    while (counter < 16) {
        // Llamar a función que desplaza a la izquierda
        displaceLeft(led_value_left, limit_left);

        // Aumentar la cantidad de bits que se iluminan en 1
        led_value_left = led_value_left | (led_value_left << 1);

        // Llamar a la función que desplaza a la derecha
        displaceRight(led_value_right, limit_right);

        // Aumentar la cantidad de bits que se iluminan en 1
        led_value_right = led_value_right | (led_value_right >> 1);

        // Aumentar el límite a la derecha para evitar que baje a 0
        limit_right = limit_right << 1;

        counter++;
    }
    
    return(0);
}