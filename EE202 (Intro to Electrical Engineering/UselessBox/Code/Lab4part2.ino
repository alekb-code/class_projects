const int Q12 = 33;  //Top Right
const int Q34 = 32;  //Bottom Right
const int lim_read = 25;
const int dpdt_read = 19;
//This variable makes sure that our personality doesn't happen continuously
volatile bool jitterCanRun = 1;
void setup() {
  // Set up the pins:
  pinMode(Q12, OUTPUT);
  pinMode(Q34, OUTPUT);
  pinMode(lim_read, INPUT);
  pinMode(dpdt_read, INPUT);
  //Establish serial comms
  Serial.begin(115200);
  Serial.println("Starting Serial Comms");
}
void loop() {
  //Read the switches once per loop
  int switchRead = digitalRead(lim_read);
  int dpdtRead = digitalRead(dpdt_read);
  //Perform the logic in the flow chart:
  if (dpdtRead == 0) {
    //If we haven't already done jittering, we run the jitter function
    if (jitterCanRun) {
      jitter();
      jitterCanRun = 0;
    }
    //If the switch is on, swing the arm to turn it off
    forward();
  } else if (dpdtRead == 1) {
    //When the switch is off:
    if (switchRead == 0) {
      //If the switch is off, we stop if the limit switch is closed
      motorStop();
      //Enable jittering since the arm has returned to the home state
      jitterCanRun = 1;
    } else if (switchRead == 1) {
      //If the switch is off, we turn until we hit the limit switch
      backward();
    }
  }
  //Log the value of the dpdt switch (since ours only works when you hold it at the
right angle)
//Serial.println(dpdtRead);
}
//jitter function for when the
void jitter() {
  //We will choose a random number of times to loop the jittering
  for (int i = 0; i < random(1, 10); i++) {
    //We will only jitter if we haven't already hit the switch
    if (digitalRead(dpdt_read) == 0) {
      //Jittering involves moving forward, backwards, then pausing, before repeating
      forward();
      delay(150);
      backward();
      delay(100);
      motorStop();
      delay(500);
    }
    //Prints that we are jittering
    Serial.println("Jitter");
  }
}
//Forward function that turns the motor clockwise when called
void forward() {
  //Write the mosfets
  digitalWrite(Q12, LOW);
  digitalWrite(Q34, HIGH);
  //Serial.println("Clockwise!");
}
//Backward function that turns the motor cc when called
void backward() {
  digitalWrite(Q34, LOW);
  digitalWrite(Q12, HIGH);
  //Serial.println("Counterclockwise!");
}
//Stops the motor when called
void motorStop() {
  digitalWrite(Q34, LOW);
  digitalWrite(Q12, LOW);
  //Serial.println("Motor off!");
}