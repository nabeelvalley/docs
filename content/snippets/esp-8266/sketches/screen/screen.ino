// Based on Example for AdaFruit Monochrome OLEDs based on SSD1306 drivers

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C // This value depends on the screen, running the i2x-detect script will give you the correct one for your screen

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void displayText(void)
{
    display.clearDisplay();

    display.setTextSize(3);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(10, 0);
    display.println(F("Hello"));
    display.println(F("WORLD!!"));
    display.display();
}

void setup()
{
    Serial.begin(9600);

    if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
    {
        Serial.println(F("SSD1306 allocation failed"));
        for (;;)
            ; // Don't proceed, loop forever
    }
}

void loop()
{
    displayText();
}
