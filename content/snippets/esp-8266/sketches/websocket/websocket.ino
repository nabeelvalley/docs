// Example from the ArduinoWebsockets docs: https://github.com/gilmaimon/ArduinoWebsockets
#include <ArduinoWebsockets.h>
#include <ESP8266WiFi.h>
#include "config.h"

using namespace websockets;

const char *ssid = STASSID;
const char *password = STAPSK;
const char *websockets_server = WSSERVER;

void onMessageCallback(WebsocketsMessage message)
{
    Serial.println("Received Websocket Message: ");
    Serial.println(message.data());
}

void onEventsCallback(WebsocketsEvent event, String data)
{

    Serial.println("Received Event");
    Serial.println(data);

    switch (event)
    {
    case WebsocketsEvent::ConnectionOpened:
        Serial.println("Connnection Opened");
        break;

    case WebsocketsEvent::ConnectionClosed:
        Serial.println("Connnection Closed");
        break;
    }
}

WebsocketsClient client;
void setup()
{
    Serial.begin(115200);
    WiFi.begin(ssid, password);

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

    // Setup Callbacks
    client.onMessage(onMessageCallback);
    client.onEvent(onEventsCallback);

    client.connect(websockets_server);
}

void loop()
{
    client.poll();
}