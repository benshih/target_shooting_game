class Animal
{
  int points;
  PImage pic;
  int xLoc; //top left corner
  int yLoc; //top left corner
  int xDim;
  int yDim;
  
  public Animal(int xLoc, int yLoc, int xDim, int yDim, PImage pic, int points)
  {
    this.xLoc = xLoc;
    this.yLoc = yLoc;
    pic.resize(xDim, yDim);
    this.xDim = xDim;
    this.yDim = yDim;
    this.pic = pic;
    this.points = points;
  }

  public int getX()
  {
    return xLoc;
  }

  public int getY()
  {
    return yLoc;
  }
  
  public PImage getPic()
  {
    return pic;
  }
  
  void showAnimal()
  {
    image(pic, xLoc, yLoc);
  }
  

}

