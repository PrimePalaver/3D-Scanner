// Include packages
#include <Arduino.h>
#include <stdint.h>
#include <Servo.h>

// Define constants
#define PC_BAUD 250000
float x2 = -.00015422;
float x1 = .0552;
float b = 32.4954;

// Define serial port
HardwareSerial & pcSer = Serial;

// Define servo
Servo tiltServo;

// Define pin numbers
int button = 2;
int startButton = 4;
int panServoOne = 5;
int panServoTwo = 6;
int tiltServoPin = 9;

// State variables
unsigned long long int currentTime;
unsigned long long int prevTime = 0;
boolean start = 0;
boolean buttonState = 0;
boolean prevButtonState = 0;
boolean dir = 0;
float lastButtonTime = 0.0;
float distance;
int buttonCount = 0;
int phi = 150;

void setup() {
  // Begin serial at refresh rate
  pcSer.begin(PC_BAUD);
  
  // Define pin modes
  pinMode(startButton, INPUT);
  pinMode(button, INPUT);
  pinMode(panServoOne, OUTPUT);
  pinMode(panServoTwo, OUTPUT);

  // Set servo pin number and starting position
  tiltServo.attach(tiltServoPin);
}

void loop() {
  // Wait for the start button to be pressed before running code
  if (!start) {
    start = digitalRead(startButton);
  }
  // Collect data until phi hits a certain value
  else if (phi >= 110) {
    // Get current time in microseconds
    currentTime = millis() + 1000;
  
    // Check the state of the button
    buttonState = digitalRead(button);
  
    // Set the pan servo to spin in the correct direction
    panServo(dir, !dir);
  
    // Set the tilt servo to the correct position
    tiltServo.write(phi);

    // Collect data or switch directions based on button input
    switch(buttonCount) {
      case 1:
        collectData();
        break;
      case 2:
        panServo(0, 0);
        dir = !dir;
        phi -= 2;
        buttonCount = 0;
        delay(750);
        break;
    }

    // Check for the aluminum foil button to make contact
    if (buttonState == 0 && prevButtonState == 1 && currentTime-lastButtonTime>1000){
        buttonCount ++;
        lastButtonTime = currentTime;
    }
  
    // Define the previous state of the button
    prevButtonState = buttonState;
  }
  else {
    pcSer.print("This means we are done with serial.");
    delay(10000);
  }
}

void panServo(boolean dir1, boolean dir2) {
  // Takes in 0 or 1 for each parameter and sets servo power
  analogWrite(panServoOne, dir1*255);
  analogWrite(panServoTwo, dir2*255);
}

void collectData() {
  // Read the IR sensor and convert to cm
  distance = analogRead(A0);  
  distance = distance*(50/float(1023.0));
  distance = -1.94512951295*distance + 68.33512195;

  // Alternate distance equation based on material of scanned object
  //  distance = sq(distance)*x2 + distance*x1 + b;

  // Push data through serial
  sendToSerial(distance, phi, dir);
}

void sendToSerial(float dist, int p, boolean d) {
  // Send distance, phi, and direction through serial delimited by commas
  pcSer.print(dist, 6);
  pcSer.print(", ");
  pcSer.print(p);
  pcSer.print(", ");
  pcSer.println(d);
}
