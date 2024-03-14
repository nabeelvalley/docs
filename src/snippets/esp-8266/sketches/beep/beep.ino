
// Note frequencies from https://learn.adafruit.com/circuit-playground-o-phonor/musical-note-basics
//
//         octave = 1    2    3    4    5     6     7     8
// NOTES = { "C" : (33,  65, 131, 262, 523, 1047, 2093, 4186),
//           "D" : (37,  73, 147, 294, 587, 1175, 2349, 4699),
//           "E" : (41,  82, 165, 330, 659, 1319, 2637, 5274),
//           "F" : (44,  87, 175, 349, 698, 1397, 2794, 5588),
//           "G" : (49,  98, 196, 392, 785, 1568, 3136, 6272),
//           "A" : (55, 110, 220, 440, 880, 1760, 3520, 7040),
//           "B" : (62, 123, 247, 494, 988, 1976, 3951, 7902)}

// Speaker connected to the D5 Pin and Ground
const int PIN_SPEAKER = D5;

void setup()
{
  Serial.begin(115200);

  Serial.println("STARTING BEEP");

  pinMode(PIN_SPEAKER, OUTPUT);

  playSound();
}

const int FREQ_HIGH = 880;
const int FREQ_LOW = 65;

void playSound()
{
  int duration = 500;

  tone(PIN_SPEAKER, FREQ_HIGH, duration);
  delay(duration);
  tone(PIN_SPEAKER, FREQ_LOW, duration);
  delay(duration * 2);
}

void loop() {}
