#include <ESP32Servo.h>

Servo myServo1;
Servo myServo2;
const int servo1Pin = 13;
const int servo2Pin = 27;
const int button1Pin = 12;
const int button2Pin = 14;

int currentPos1 = 90; 
int currentPos2 = 90; 
int targetPos1 = 90; 
int targetPos2 = 90;

void setup() {
  Serial.begin(115200);
  
  pinMode(button1Pin, INPUT_PULLUP);
  pinMode(button2Pin, INPUT_PULLUP);

  myServo1.attach(servo1Pin);
  myServo2.attach(servo2Pin);
  
  myServo1.write(currentPos1);
  myServo2.write(currentPos2);
}

void loop() {
  bool button1Pressed = digitalRead(button1Pin) == LOW;
  bool button2Pressed = digitalRead(button2Pin) == LOW;

  if (button1Pressed) {
    targetPos1 = 15;
    targetPos2 = 180;
  } 
  else if (button2Pressed) {
    targetPos1 = 145;
    targetPos2 = 45;
  }

  if (currentPos1 < targetPos1) {
    currentPos1++;
    myServo1.write(currentPos1);
  } else if (currentPos1 > targetPos1) {
    currentPos1--;
    myServo1.write(currentPos1);
  }

  if (currentPos2 < targetPos2) {
    currentPos2++;
    myServo2.write(currentPos2);
  } else if (currentPos2 > targetPos2) {
    currentPos2--;
    myServo2.write(currentPos2);
  }

  delay(15);  // Pulse width modulation to determine speed
}