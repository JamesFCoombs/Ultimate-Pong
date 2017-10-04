
public class Ball
{
  private int xVel;
  private int yVel;
  private int xPos;
  private int yPos;
  private int c1; private int c2; private int c3;
  private boolean c1Dir, c2Dir, c3Dir;
  private int XVelChange = 0;
  private int YVelChange = 0;
  
  public BallFade path;
  public static final int RADIUS = 8;
  
  public Ball()
  {
    yPos = height/2;
    xPos = width/2;
    xVel = (int)((Math.random() - .5)*10);
    yVel = (int)((Math.random() - .5)*10);
    
    if (xVel == 0)
    xVel = -5;
    if (yVel == 0)
    yVel = 5;
    
    c1 = 255;
    c2 = 255;
    c3 = 255;
    
    c1Dir = true;
    c2Dir = true;
    c3Dir = true;
    
    path = new BallFade();
  }
  
  public int getXPos()
  {
    return xPos;
  }
  
  public int getYPos()
  {
    return yPos;
  }
  
  public int getXVel()
  {
    return xVel;
  }
  
  public int getC1()
  {
    return c1;
  }
  
  public int getC2()
  {
    return c2;
  }
  
  public int getC3()
  {
    return c3;
  }
  
  public int getYVel()
  {
    return yVel;
  }
  
  public void hitWall()
  {
    yVel -= 2*yVel;
  }
  
  public void hitPaddle(boolean direction) // True is right, false is left side
  {
    if (direction)
      xVel = -1 * Math.abs(xVel);
    else
      xVel = Math.abs(xVel);
  }
  
  public void move()
  {
    xVel += XVelChange;
    XVelChange = 0;
    yVel += YVelChange;
    YVelChange = 0;
    
    if (xVel == 0)
    xVel = -1;
    if (yVel == 0)
    yVel = 1;
    
    path.add(new Fade(xPos, yPos, c1, c2, c3));
    path.act();
    xPos += xVel;
    yPos += yVel;
  }
  
  public void colorChange()
  {
    double choice = Math.random();
    if (c1 < 40 && c2 < 40)
    {c1Dir = true; c2Dir = true;}
    if (c3 < 40 && c2 < 40)
    {c3Dir = true; c2Dir = true;}
    if (c1 < 40 && c3 < 40)
    {c1Dir = true; c3Dir = true;}
    
    if (choice < .33)
        {
          if (c1 == 255)
            c1Dir = false;
          if (c1 == 0)
            c1Dir = true;
          if (c1Dir)
            c1+=5;
          else
            c1-=5;
        }  
        else if (choice < .66)
        {
          if (c2 == 255)
            c2Dir = false;
          if (c2 == 0)
            c2Dir = true;
          if (c2Dir)
            c2+=5;
          else
            c2-=5;
        }
        else
        {
          if (c3 == 255)
            c3Dir = false;
          if (c3 == 0)
            c3Dir = true;
          if (c3Dir)
            c3+=5;
          else
            c3-=5;
        }
  }
  
  void collidesWith(Ball other)
  {
    if (4 * Ball.RADIUS * Ball.RADIUS <= (xPos - other.getXPos()) * (xPos - other.getXPos()) + (yPos - other.getYPos()) * (yPos - other.getYPos())) 
     return;
     
     double xDif = 1.0 * xPos - other.getXPos();
     double yDif = 1.0 * yPos - other.getYPos();
     double distance = Math.sqrt((yPos - other.getYPos())*(yPos - other.getYPos())+(xPos - other.getXPos())*(xPos - other.getXPos()));
     
     XVelChange = (int) (xDif / distance * Math.abs(xVel - other.getXVel()));
     YVelChange = (int) (yDif / distance * Math.abs(yVel - other.getYVel()));
  }
}
