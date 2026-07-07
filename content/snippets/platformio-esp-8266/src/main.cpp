// COmbination of all the examples into something together
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include "config.h"
#include "Arduino.h"

const char *ssid = STASSID;
const char *password = STAPSK;

ESP8266WebServer server(80);

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C // This value depends on the screen, running the i2x-detect script will give you the correct one for your screen

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void displayIP(String ip)
{
  display.clearDisplay();

  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);

  display.println("IP Address");
  display.println(ip);

  display.display();
}

void handleRoot()
{
  digitalWrite(LED_BUILTIN, HIGH);
  server.send(200, "text/plain", "hello from esp8266!\r\n");
  digitalWrite(LED_BUILTIN, LOW);
}

void handleNotFound()
{
  digitalWrite(LED_BUILTIN, HIGH);
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i = 0; i < server.args(); i++)
  {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
  digitalWrite(LED_BUILTIN, LOW);
}

void setupScreen()
{
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
  {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ; // Don't proceed, loop forever
  }
}

void setupWiFi()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");

  Serial.print("Connecting to WIFI");
  while (WiFi.status() != WL_CONNECTED)
  {
    // Wait for connection
    delay(500);
    Serial.print(".");

    if (WiFi.status() == WL_WRONG_PASSWORD)
    {
      Serial.print("INCORRECT WIFI PASSWORD");
      return;
    }
  }
  Serial.println("");

  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void setupServer()
{
  if (MDNS.begin("esp8266"))
  {
    Serial.println("MDNS responder started");
  }

  server.on("/", handleRoot);

  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");
}

void setup()
{
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);

  setupScreen();
  setupWiFi();
  setupServer();
}

void loop()
{
  server.handleClient();
  MDNS.update();

  String ip = WiFi.localIP().toString();
  displayIP(ip);
}
