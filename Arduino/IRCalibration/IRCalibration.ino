float distance;
int rollingNum = 1000;

float x2 = -.00015422;
float x1 = .0552;
float b = 32.4954;

void setup() {
  Serial.begin(9600);
}

void loop() {
  distance = 0.0;
  for (int i = 0; i < rollingNum; i++) {
    distance = distance + analogRead(A0);
  }

  distance = distance / float(rollingNum);
  Serial.println(distance);
  Serial.println((sq(distance)*x2) + (distance*x1) + b);
  delay(1000);
}
