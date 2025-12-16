# Class Projects
In order of significance/coolness

## Intro to Electrical Engineering (Elec_Eng 202)
Shout out to my lab partners AJ Klein and Max Maiers.

### Useless Box
We built a useless box, which turns itself off when its turned on. We then reconstructed this box to operate with an ESP32 microcontroller along with [code](Intro%20to%20Electrical%20Engineering%20(Elec_Eng%20202)/UselessBox/Code/UselessBoxNormalCode.ino) to operate it. Finally, we edited the code to give the box some "personality." Images of the circuit as well as the .ino code files can be found [here](Intro%20to%20Electrical%20Engineering%20(Elec_Eng%20202)/UselessBox).

### LED Matrix
We first built a simple 3x3 LED matrix that could be controlled by shift registers. Like the Useless Box, we then redid the old matrix with an ESP32 and relevant code incorporated into it. After that, we learned about filtering and built our own filter circuit with four bands. We then combined this filter circuit with a PCB we soldered (PCB design credit to Prof. Ilya Mickelson) to make an audio spectrum vizualizer. Finally, used a larger prebuilt LED matrix and microphone to apply these topics on a larger scale. Images and code of the project throughout each step can be found [here](Intro%20to%20Electrical%20Engineering%20(Elec_Eng%20202)/LEDMatrix).

## Design Thinking and Communication I (DTC I)
### SPICALIGN
As part of the first year Design Thinking & Communication class at Northwestern University, I, along with three other teammates, created a prototype of an intraoperative guide featuring foot-pedal automated positioning and servo-controlled reference arms that enable medical personnel to adjust hip spica casts to fit standard car seats, reducing safety risks and post-operative costs for pediatric patients.
A summary of the issue, an explanation of our design, and a poster of the project can be see in the [Design Summary](Design%20Thinking%20and%20Communication%20I%20(DTC%20I)/design_summary.pdf).

#### Electronics
My main contribution to the project was creating two simple circuits to move the linear actuator and servos via foot pedals.

##### Linear Actuator Circuit
<img src="Design%20Thinking%20and%20Communication%20I%20(DTC%20I)/actuator_circuit.png" 
     alt="Actuator Circuit Diagram" 
     width="300"/><br>
To wire up the linear actuator, I used a DPDT foot pedal that allowed operation of the device in both directions.

##### Servo Circuit
<img src="Design%20Thinking%20and%20Communication%20I%20(DTC%20I)/Servo_circuit.png" 
     alt="Servo Circuit Diagram" 
     width="300"/><br>
To operate the servos, I used an ESP32 microcontroller loaded with [some code](code/servo_control.ino) that took in inputs from two switches (foot pedals we bought) and then wrote positions to the two servos.

## Honors Engineering Analysis I (Gen_Eng 206-1)
To supplement our learning of lienar algebra, we wrote some scripts in MATLAB to solve different problems/tasks. Code files can be found [here](Honors%20Engineering%20Analysis%20I%20%28Gen_Eng%20206-1%29).

## Honors Calculus for Engineers I (Es_Appm 252-1)
While learning Multivariable Differential Calculus, we used python to solve computational problem related to the topics we were learning. Code files can be found [here](Honors%20Calculus%20for%20Engineers%20I%20%28ES_APPM%20252-1%29).
