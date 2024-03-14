// Based on example from: https://www.arduino.cc/en/Tutorial/BuiltInExamples/Blink

void setup()
{
  Serial.begin(115200);

  Serial.println("STARTING BLINK");
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop()
{
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}
