class Player
{

  //assumes there are 4 targets
  int hit1 = 0;
  int hit2 = 0;
  int hit3 = 0;
  int hit4 = 0;

  int score = 0;

  void reset()
  {
    score = 0;
    hit1 = 0;
    hit2 = 0;
    hit3 = 0;
    hit4 = 0;
  }

  void hit1()
  {
    hit1 = 1;
  }

  void hit2()
  {
    hit2 = 1;
  }

  void hit3()
  {
    hit3 = 1;
  }

  void hit4()
  {
    hit4 = 1;
  }  

  //12
  //34
  void crossout(int loc) //places a large red x over the target
  {
  }

  //checks if a player has hit all the targets
  boolean win() 
  {
    if(1 == hit1 && 1 == hit2 && 1 == hit3 && 1 == hit4)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  void add(int points)
  {
    score+=points;
  }

  int score() 
  {
    return score;
  }

  void drawScore(int playerid)
  {
    String str;
    PFont font = loadFont("Aharoni-Bold-48.vlw");
    str = Integer.toString(score);
    textFont(font, 40);

    if (playerid == 1) {
      fill(0);
      rect(100, 290, 100, 40);
      fill(255);
      text(str, 105, 320);
    } 
    else {
      fill(0);
      rect(440, 290, 100, 40);
      fill(255);
      text(str, 445, 320);
    }
  }
}

