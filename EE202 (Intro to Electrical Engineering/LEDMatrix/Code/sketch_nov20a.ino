// rows
const int clk_a = 23;
const int d_a = 21;
const int rst_a = 22;
// cols
const int clk_b = 32;
const int d_b = 26;
const int rst_b = 25;
// filter pin declarations
const int filter1 = 36;
const int filter2 = 39;
const int filter3 = 34;
const int filter4 = 35;




const int width = 8;
const int height = 8;




uint8_t mat[8][8] = {
 
  {1,0,0,0,0,0,0,1},
  {0,1,0,0,0,0,1,0},
  {0,1,1,0,0,1,0,0},
  {0,0,0,1,1,0,0,1},
  {0,0,0,1,1,0,0,0},
  {1,0,1,0,0,1,0,0},
  {0,1,0,0,0,0,1,0},
  {1,0,0,0,0,0,0,1}
};


const uint8_t mat_size = 8;
const uint8_t num_filters = 4;
const uint16_t buf_len = 40;
uint16_t filter_buf [num_filters][buf_len] = {0};
uint16_t filter_mean[num_filters];
const uint8_t filter_pins[num_filters] = {filter1 , filter2 , filter3 , filter4};
const float filter_scalers[num_filters] = {200, 140, 140, 110};




//hardware timer init
hw_timer_t * led_timer = NULL;
portMUX_TYPE timer_mux = portMUX_INITIALIZER_UNLOCKED;




// delay between LEDs
uint32_t delay_time_us = 2000;
//uint32_t delay_time_us = 1000000;




// counter for current row;
volatile uint8_t current_row = 0;




void reset_matrix(){
    digitalWrite(rst_b, HIGH);
    digitalWrite(rst_b, LOW);
    for(int i=0; i<height; i++){
      shift_one_bit_a(1);
    }
}




void shift_one_bit_a(uint8_t d){
  digitalWrite(d_a, d);
  digitalWrite(clk_a, HIGH);
  delayMicroseconds(5);
  digitalWrite(clk_a, LOW);
}




void shift_one_bit_b(uint8_t d){
  digitalWrite(d_b, d);
  digitalWrite(clk_b, HIGH);
  delayMicroseconds(5);
  digitalWrite(clk_b, LOW);
}








void IRAM_ATTR animation_handler(){
  portENTER_CRITICAL_ISR(&timer_mux);




  // update the columns in the row
  for(int j=width-1; j>=0; j--){
    if(mat[current_row][j]>0){
      shift_one_bit_b(1);
    }else{
      shift_one_bit_b(0);
    }
    //Serial.println(j);
  }
  // update the rows
  if(current_row == 0){
    shift_one_bit_a(0);
  }else{
    shift_one_bit_a(1);
  }
  // update row counter
  if(current_row == height-1){
    current_row = 0;
  }else{
    current_row++;
  }




  portEXIT_CRITICAL_ISR(&timer_mux);
}








void update_mat(uint8_t * cols, uint8_t num_rows, uint8_t num_cols){
  for(int i=num_rows-1; i>=0; i--){
    for(int j=0; j<num_cols; j++){
      mat[i][j] = cols[j];
      if(cols[j]>0){
        cols[j]--;
      }
    }
  }
}


uint16_t calc_buf_mean(uint16_t * buf, uint16_t len) {
  uint16_t sum = 0;
  for (uint16_t i=0; i < len; i++) {
    sum += buf[i];
  }
  return (sum/len);


 // given a buffer of values and its length , calculate its mean and
 // return that as an integer .
}




void setup(){
  //Begin serial com
  Serial.begin(115200);
  //init pins
  pinMode(clk_a, OUTPUT);
  pinMode(d_a, OUTPUT);
  pinMode(rst_a, OUTPUT);
  pinMode(clk_b, OUTPUT);
  pinMode(d_b, OUTPUT);
  pinMode(rst_b, OUTPUT);
  //default pin vals
  digitalWrite(rst_a, LOW);
  digitalWrite(rst_b, LOW);
  // reset matrix
  reset_matrix();




  //timer setup
  led_timer = timerBegin(1, 80, true);
  timerAttachInterrupt(led_timer, &animation_handler, true);
  timerAlarmWrite(led_timer, delay_time_us, true);
  timerAlarmEnable(led_timer);
}




void loop(){
  static uint8_t cols[mat_size];
  static uint16_t counter = 0; // counter for filter buf
  // use a for loop to read every filter pin and store it in filter buf .
  // make sure to update ‘counter’ appropriately.
  for (uint8_t ii = 0; ii < num_filters; ii++){
    filter_buf[ii][counter] = analogRead(filter_pins[ii]);
  }
  if (counter < buf_len-1) {
    counter ++;
  }
  else {
    counter = 0;
  }




// calculate the means of the filter buffers and store the results in
// ‘filter mean ’.
  for (uint8_t ii = 0; ii < num_filters; ii++ ) {
    filter_mean[ii] = calc_buf_mean(filter_buf[ii], buf_len);
  }
  Serial.printf("%4d", filter_mean[0]);
  for (uint8_t ii = 1; ii<num_filters; ii++) {
    Serial.printf("%4d", filter_mean[ii]);
  }
  Serial.print("\r\n");
 // for each column of your matrix , scale the value in ‘filter mean’ to
 // fit in your matrix size . write this value into ‘cols ’.
  for(int ii = 0; ii<num_filters; ii++){
    cols[2*ii] = round((float)mat_size * ((float)filter_mean[ii]) / filter_scalers[ii]);
    cols[2*ii+1] = cols[2*ii];
  }
 // update the matrix based on ‘cols ’.
  update_mat(cols, mat_size, mat_size);
 // print the ‘filter mean’ values to the screen , separated by commas.
 
}
