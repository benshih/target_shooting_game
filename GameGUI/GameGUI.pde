import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import processing.serial.*;
import fullscreen.*; 
import cc.arduino.*;


AudioPlayer player;
Minim minim;
FullScreen fs; 
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

/***********MODIFY HERE ONLY ********/
//analog ir value threshold that indicates when you've hit something
final int IRTHRESHOLD1 = 120; 
final int IRTHRESHOLD2 = 240;
final int IRTHRESHOLD3 = 76;
final int IRTHRESHOLD4 = 300+++-;

String animalImage1 = "raccoon.jpg";
int pts1 = 5000;

String animalImage2 = "goose.jpg";
int pts2 = 5000;

String animalImage3 = "coyote.jpg";
int pts3 = 5000;

String animalImage4 = "vulture.jpg";
int pts4 = 5000;
/************************************/

//fsm output signals
int buttonPressed = 0;
int done = 0;
boolean isRunning = false;

//target pin assignment
int target1 = 0;
int target2 = 1;
int target3 = 2;
int target4 = 3;

//target analog values that we read
int t1;
int t2;
int t3;
int t4;

//gun pin assignment
//int gun1 = 7;
//int gun2 = 6;

//gun digital values that we read
int g1;
int g2;

//button pin assignment
int button1 = 5;

//button digital values that we read
int b1;

//testing LED
int test = 12;

int[] buttArray;

//arduino
Arduino ar;

Animal p1one;
Animal p1two;
Animal p1three;
Animal p1four;
Animal p2one;
Animal p2two;
Animal p2three;
Animal p2four;
Player one;
Player two;
int onePrev;
int oneOff;
int twoPrev;
int twoOff;

//load all images
PImage bg;
PImage home;
PImage v1;
PImage v2;


Timer time;

int p1; //playerr 1 score
int p2; //player 2 score
PFont font; //font
int p2shiftX = 322; //pixels shifted to obtain player 2's positions

int higher;
boolean isVictoryDone = false;

int gun1off = 4;
int gun2off = 3;

void setup() 
{
  size(640, 480);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[1];
  print("arduino name: ");
  println(portName);

  bg = loadImage("gui.jpg");
  home = loadImage("home.jpg");
  v1 = loadImage("v1.jpg");
  v2 = loadImage("v2.jpg");

  ar = new Arduino(this, "COM4", 57600);
  //declares all the target pins to be inputs
  ar.pinMode(target1, Arduino.INPUT);
  ar.pinMode(target2, Arduino.INPUT);
  ar.pinMode(target3, Arduino.INPUT);
  ar.pinMode(target4, Arduino.INPUT);

  //declares all the gun pins to be inputs
  //ar.pinMode(gun1, Arduino.INPUT);
  //ar.pinMode(gun2, Arduino.INPUT);

  //declares all the button pins to be inputs
  ar.pinMode(button1, Arduino.INPUT);
  b1 = 0;

  //gun signals as digital inputs
  ar.pinMode(gun1off, Arduino.INPUT);
  ar.pinMode(gun2off, Arduino.INPUT);

  //enables the test indicator LED
  ar.pinMode(test, Arduino.OUTPUT);

  //instantiate the two players
  one = new Player();
  two = new Player();

  //enable full screen mode
  fullscreen();

  //display home screen
  home();
  //gui();

  //declare button check array
  buttArray = new int[5];

  higher = 0;
  
  minim = new Minim(this);
  
  player = minim.loadFile("gunshot.wav", 2048);
  
  
}


//debouncing
//int buttonState;             // the current reading from the input pin
//int lastButtonState = Arduino.LOW;   // the previous reading from the input pin

// the following variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
//long lastDebounceTime = 0;  // the last time the output pin was toggled
//long debounceDelay = 50;    // the debounce time; increase if the output flickers

void draw()
{
  //home();
  if (isVictoryDone) {
    delay(9000);
    
    reset();
    isRunning = false;
  }
  else if (!isRunning) {
    b1 = ar.digitalRead(button1);
    buttArray[4] = buttArray[3];
    buttArray[3] = buttArray[2];    
    buttArray[2] = buttArray[1];
    buttArray[1] = buttArray[0];
    buttArray[0] = b1;
    print("idle state ");
    println(b1);
    //shot(50+p2shiftX,64);
    delay(500);
    if (1 == buttArray[0] && 1 == buttArray[1] && 1 == buttArray[2] && 1 == buttArray[3] && 1 == buttArray[4]) {
      isRunning = true;
      gui();
      time = new Timer(60000);
      time.start();
      println("Started timer");
    }
  } 
  else // Game is running, do logic shit
  {
    //println("Game: Running");
    //print("I think higher is: ");
    //println(higher);
    onePrev = oneOff;
    oneOff = ar.digitalRead(gun1off);
    twoPrev = twoOff;
    
    twoOff = ar.digitalRead(gun2off);
    //twoOff = 1; // FIXME
    int roundedtime = (((millis() / 1000) * 1000) % 2000);
    int roundedtime2 = (((millis() / 100) * 100) % 100);
    //print("oneOff: ");
    //println(oneOff);
    if (((oneOff == 0 && onePrev == 1)|| (twoOff == 0 && twoPrev == 1)))// && roundedtime == 0) //&& roundedtime2 == 0)
    {
      println("Playing sound!");
      player = minim.loadFile("gunshot.wav", 2048);
      player.play();
    }

    if (one.win() || two.win() || 1 == higher || 2 == higher) {
      //println("SOMEBODY WON THE GAME");
      isRunning = false;
      if (one.win() || 1 == higher)
        victory(1);
      else if (two.win() || 2 == higher)
        victory(2);
    }

    time.display();
    one.drawScore(1);
    two.drawScore(2);
    checkTarget(target1);
    checkTarget(target2);
    checkTarget(target3);
    checkTarget(target4);

    if (time.isFinished()) {
      //println("DERP, GAME FINISHED");
      if(one.score() > two.score())
        higher = 1;
      else
        higher = 2;
      //print("higher: ");
      //println(higher);
    }
  }
}

void reset()
{
  b1 = 0;
  higher = 0;
  isVictoryDone = false;
  home();
  one.reset();
  two.reset();
}

//checks if a target has been hit by reading its analog value and checking against a threshold
void checkTarget(int pin)
{
  int ir = ar.analogRead(pin);
  print("pin ");
  print(pin);
  print(": ");
  println(ir);
    //ar.digitalWrite(test, Arduino.HIGH);
    switch(pin)
    {
    case 0:
      if (ir > IRTHRESHOLD1)
      {
        if(0 == oneOff && one.hit1 == 0)
        {
          one.hit1();
          one.add(pts1 - time.scorePenalty());
          shot(50,64);
        }
        else if (0 == twoOff && two.hit1 == 0)
        {
          two.hit1();
          two.add(pts1 - time.scorePenalty());
          shot(50+p2shiftX,64);
        }
      }
      break;

    case 1:
      if (ir > IRTHRESHOLD2)
      {
        if(0 == oneOff && one.hit2 == 0)
        {
          one.hit2();
          one.add(pts2 - time.scorePenalty());
          shot(176,64);
        }
        else if (0 == twoOff && two.hit2 == 0)
        {
          two.hit2();
          two.add(pts2 - time.scorePenalty());
          shot(176+p2shiftX,64);
        }
      }
      break;

    case 2:
      if (ir > IRTHRESHOLD3)
      {
        if(0 == oneOff && one.hit3 == 0)
        {
          one.hit3();
          one.add(pts3 - time.scorePenalty());
          shot(50,162);
        }
        else if (0 == twoOff && two.hit3 == 0)
        {
          two.hit3();
          two.add(pts3 - time.scorePenalty());
          shot(50+p2shiftX,162);
        }
      }
      break;

    case 3:
      if (ir > IRTHRESHOLD4)
      {
        if(0 == oneOff && one.hit4 == 0)
        {
          one.hit4();
          one.add(pts4 - time.scorePenalty());
          shot(176,162);
        }
        else if (0 == twoOff && two.hit4 == 0)
        {
          two.hit4();
          two.add(pts4 - time.scorePenalty());
          shot(176+p2shiftX,162);
        }
      }
      break;
    }
}

void shot(int topLeftX, int topLeftY)
{
  fill(204, 102, 0);
  strokeWeight(10);
  line(topLeftX, topLeftY, topLeftX+100, topLeftY+88);
  line(topLeftX, topLeftY+88, topLeftX+100, topLeftY);
}

void fullscreen()//enables full screen mode
{

  //full screen mode  
  // 5 fps
  frameRate(5);

  // Create the fullscreen object
  fs = new FullScreen(this); 

  // enter fullscreen mode
  fs.enter();
}

void gui() //renders the gui background
{
  background(0);
  //load the background image
  bg.resize(640,480);
  image(bg,0,0);

  loadAnimals(); 

  println("update: finished gui");
}

void home() //renders the home background
{
  //load the background image
  home = loadImage("home.jpg");
  home.resize(640,480);
  image(home,0,0);
}

void victory(int player)
{
  if(1 == player)
  {
    v1.resize(640,480);
    image(v1,0,0);
  }
  else
  {
    v2.resize(640,480);
    image(v2,0,0);
  }

  //delay(9000);
  isVictoryDone = true;
}

void loadAnimals() //loads the animal files onto the screen. MODIFY THIS FUNCTION TO CHANGE WHAT IMAGES APPEAR
{
  //unless otherwise noted, values are relative to player 1's position
  int xdim = 94;
  int ydim = 90;
  int topleftX = 50;
  int topleftY = 64;
  PImage current;
  int secondRowShift = 7;
  int secondColShift = 32;

  //player 1
  current = loadImage(animalImage1);
  current.resize(xdim, ydim);
  p1one = new Animal(topleftX, topleftY, xdim, ydim, current, pts1);

  current = loadImage(animalImage2);
  current.resize(xdim, ydim);
  p1two = new Animal(topleftX+xdim+secondColShift, topleftY, xdim, ydim, current, pts2);

  current = loadImage(animalImage3);
  current.resize(xdim, ydim);  
  p1three = new Animal(topleftX, topleftY+ydim+secondRowShift, xdim, ydim, current, pts3);

  current = loadImage(animalImage4);
  current.resize(xdim, ydim);
  p1four = new Animal(topleftX+xdim+secondColShift, topleftY+ydim+secondRowShift, xdim, ydim, current, pts4);


  //player 2
  current = loadImage(animalImage1);
  current.resize(xdim, ydim);
  p2one = new Animal(topleftX+p2shiftX, topleftY, xdim, ydim, current, pts1);

  current = loadImage(animalImage2);
  current.resize(xdim, ydim);
  p2two = new Animal(topleftX+xdim+p2shiftX+secondColShift, topleftY, xdim, ydim, current, pts2);

  current = loadImage(animalImage3);
  current.resize(xdim, ydim);
  p2three = new Animal(topleftX+p2shiftX, topleftY+ydim+secondRowShift, xdim, ydim, current, pts3);

  current = loadImage(animalImage4);
  current.resize(xdim, ydim);
  p2four = new Animal(topleftX+xdim+p2shiftX+secondColShift, topleftY+ydim+secondRowShift, xdim, ydim, current, pts4);


  p1one.showAnimal();
  p1two.showAnimal();
  p1three.showAnimal();
  p1four.showAnimal();
  p2one.showAnimal();
  p2two.showAnimal();
  p2three.showAnimal();
  p2four.showAnimal();
}

void interaction() //renders the dynamic timer and score
{
  one.score();
  two.score();
}

void serialResponse()
{
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.read();         // read it and store it in val
  }
  background(255);             // Set background to white
  if (val == 0) 
  {              // If the serial value is 0,
    fill(0);
    print(0);    // set fill to black
  } 
  else 
  {                       // If the serial value is not 0,
    fill(random(255));                 // set fill to light gray
    println(255);
  }
  fill(255,255,0);
}

/////////////////////////// TEMPORARY TEST FUNCTIONS

void mouseReleased()
{
  println("up");
}

void mousePressed()
{
  test_mouseLoc();
}

void test_mouseLoc()
{
  println("mouseX: " + mouseX + ". mouseY: " + mouseY); //print the location of the mouse for reading coordinates
}

