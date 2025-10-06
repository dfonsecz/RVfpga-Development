#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define GPIO2_BTNs  0x80001800
#define GPIO2_INOUT 0x80001808

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define DEFAULT_DELAY 10000000

// Función que agrega retardo
void delay(volatile unsigned int counter) {
    while (counter > 0) {
        counter--;
    }
}

// Desplaza un LED encendido hacia la izquierda
void increaseBinaryCount(int leds_value, int limit, int speed_level) {

    while (leds_value <= limit) {
        // Leer el valor del botón
        int buttons_value = READ_GPIO(GPIO2_BTNs);
        int BTNC_value = buttons_value & 0x0001;

        // Al presionar el botón, aumentar nivel de velocidad
        if (BTNC_value) {
            speed_level++;
        }

        WRITE_GPIO(GPIO_LEDs, leds_value);

        delay(DEFAULT_DELAY / (speed_level));

        WRITE_GPIO(GPIO_LEDs, 0);

        leds_value = leds_value + 1;
    }
}


int main(void) {
    int leds_value = 0x0001;
    int leds_limit = 0xFFFF;
    int speed_level = 1;
    int counter = 0;

    // Configurar LEDs como salida
    WRITE_GPIO(GPIO_INOUT, 0xFFFF);

    // Configurar botones como entrada
    WRITE_GPIO(GPIO2_INOUT, 0x0000);

    while (counter != leds_limit) {
        increaseBinaryCount(leds_value, leds_limit, speed_level);
        counter++;
    }

    return 0;
}
