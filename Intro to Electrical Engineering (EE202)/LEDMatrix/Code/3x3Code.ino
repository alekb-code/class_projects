// pin declarations
const int clk_a = 27;
const int d_a = 14;
const int rst_a = 13;
const int clk_b = 4;
const int d_b = 5;
const int rst_b = 16;
// matrix to hold pattern
uint8_t mat[3][3] = {
  {1, 0, 0},
  {0, 1, 1},
  {1, 0, 1}
};

// hardware timer initializations

void reset_matrix() {
  digitalWrite(rst_a, HIGH);
  digitalWrite(rst_b, HIGH);
  delayMicroseconds(pin_set_time);
  digitalWrite(rst_a, LOW);
  digitalWrite(rst_b, LOW);
  for (int i = 0; i<4; i++)
  {
    shift_one_bit_a(1);
  }
}

void shift_one_bit_a(uint8_t d) {
  digitalWrite(d_a, d);
  digitalWrite(clk_a, HIGH);
  digitalWrite(clk_a, LOW);
}

void shift_one_bit_b(uint8_t d) {
  digitalWrite(d_b, d);
  digitalWrite(clk_b, HIGH);
  digitalWrite(clk_b, LOW);
}

void IRAM_ATTR animation_handler() {
  portENTER_CRITICAL_ISR(&timermux);
  
  // load the contents of a single row into the shift registers.
  // keep track of your 'row' variable and increment and reset
  // it appropriately.
  
  portEXIT_CRITICAL_ISR(&timermux);
}

void update_mat(uint8_t *cols, uint8_t num_rows, uint8_t num_cols) {
  // this function updates the pattern matrix by taking an array of
  // columns. each value in 'cols' determines the number of LEDs
  // lit up in that column, from the bottom.
}

void setup() {
  // same as before.
  Serial.begin(115200);
  pinMode(clk_a, OUTPUT);
  pinMode(d_a, OUTPUT);
  pinMode(rst_a, OUTPUT);
  pinMode(clk_b, OUTPUT);
  pinMode(d_b, OUTPUT);
  pinMode(rst_b, OUTPUT);
  digitalWrite(clk_a, LOW);
  digitalWrite(d_a, LOW);
  digitalWrite(clk_b, LOW);
  digitalWrite(d_b, LOW);
  digitalWrite(rst_a, LOW);
  digitalWrite(rst_b, LOW);
  reset_matrix();
  // start timer using a delay that results in no flicker.
}

void loop() {
  static uint8_t cols[3];
  
  cols[0] = 1; cols[1] = 2; cols[2] = 1;
  update_mat(cols, 3, 3);
  delay(1000);
  cols[0] = 2; cols[1] = 1; cols[2] = 3;
  update_mat(cols, 3, 3);
  delay(1000);
}
