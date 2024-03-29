int switchPin = 4;                       // Switch connected to pin 4

void setup() 
{
  pinMode(switchPin, INPUT);             // Set pin 0 as an input
  Serial.begin(9600);                    // Start serial communication at 9600 bps
}

void loop() 
{
  if (digitalRead(switchPin) == LOW) 
  {  // If switch is ON,
    Serial.print(1, BYTE);               // send 1 to Processing
  } 
  else 
  {                               // If the switch is not ON,
    Serial.print(0, BYTE);               // send 0 to Processing
  }
  
  Serial.print(1, BYTE);
  delay(100);             // Wait 100 milliseconds
  Serial.print(0,BYTE);
  delay(1000);
}
