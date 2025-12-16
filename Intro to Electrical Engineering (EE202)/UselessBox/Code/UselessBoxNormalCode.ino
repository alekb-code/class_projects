const int Q12 = 33; //Top Right
const int Q34 = 32; //Bottom Right
const int lim_read = 25;
const int dpdt_read = 26;
volatile int state[2];
bool justHitSwitch = false;

void setup() {
  // Set up the pins:
  pinMode(Q12, OUTPUT);
  pinMode(Q34, OUTPUT);
  pinMode(lim_read, INPUT);
  pinMode(dpdt_read, INPUT);

  //Establish serial comms
  Serial.begin(115200);
  Serial.println("Starting Serial Comms");
  randomSeed(analogRead(0));
}

void loop() {

  int switchRead = digitalRead(lim_read);
  int dpdtRead = digitalRead(dpdt_read);

  if (dpdtRead == 0) {
    forward();
    justHitSwitch = false;
  } else if (dpdtRead == 1) {
    if (switchRead == 0) {
      motorStop();
      justHitSwitch = true;
    } else if (switchRead == 1) {
      if (justHitSwitch) {
        delay(random(2000, 5001));
        justHitSwitch = false;
      }
      backward();
    }
  }

  delay(100);

  Serial.println(dpdtRead);

}

void forward() {

  digitalWrite(Q12, LOW);
  digitalWrite(Q34, HIGH);
  Serial.println("Clockwise!");

}

void backward() {

  digitalWrite(Q34, LOW);
  digitalWrite(Q12, HIGH);
  Serial.println("Counterclockwise!");

}

void motorStop() {

  digitalWrite(Q34, LOW);
  digitalWrite(Q12, LOW);
  Serial.println("Motor off!");

}
