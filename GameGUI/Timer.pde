// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 10-5: Object-oriented timer
//////////////////////////////////////////////////

// modified by Benjamin Shih 4/11/2011 for TSA Booth 2011
class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  int scorePenalty()
  {
    return (millis() - savedTime) % 100;
  }

  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display() //display the seconds remaining
  {
    String str;
    int timeLeft = totalTime - (millis() - savedTime);
    //if(0 > timeLeft)
    //{
      //timeLeft = 0;
    //}
   
    clear();
    PFont font = loadFont("Aharoni-Bold-48.vlw");
    fill(255);
    textFont(font, 40);
    str = Integer.toString(timeLeft/1000);
    text(str, 300, 450);
  }
  
  void clear() //clear the area where the time shows up
  {
    fill(0);
    rect(295, 420, 40, 40);
  }
}

