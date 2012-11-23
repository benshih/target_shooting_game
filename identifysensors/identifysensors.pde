int a = 0;
int b = 1;
int c = 2;
int d = 3;

void setup()
{    
  pinMode(a, INPUT);
  pinMode(b, INPUT);
  pinMode(c, INPUT);
  pinMode(d, INPUT);
  Serial.begin(9600);
}


void loop()
{
  int aa = analogRead(a);
  int bb = analogRead(b);
  int cc = analogRead(c);
  int dd = analogRead(d);
  Serial.print("a: ");
  Serial.print(aa);
  Serial.print(". b: ");
  Serial.print(bb);
  Serial.print(". c: ");
  Serial.print(cc);
  Serial.print(". d: ");
  Serial.println(dd);
  delay(400);
}

