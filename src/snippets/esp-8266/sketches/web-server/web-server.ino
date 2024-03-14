// Based on the ESP8266WebServer example
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include "config.h"

const char *ssid = STASSID;
const char *password = STAPSK;

ESP8266WebServer server(80);

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

void setup(void)
{
  Serial.begin(115200);

  pinMode(LED_BUILTIN, OUTPUT);

  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);

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

  if (MDNS.begin("esp8266"))
  {
    Serial.println("MDNS responder started");
  }

  server.on("/", handleRoot);

  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");
}

void loop()
{
  server.handleClient();
  MDNS.update();
}
