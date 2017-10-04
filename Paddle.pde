public class Paddle{
  
  private int xPos;
  private int yPos;
  private int yLength;

public Paddle(int x, int h)
  {
    xPos = x;
    yPos = height/2;
    yLength = h;
  }
  
  public Paddle(int x)
  {
    this(x, 60);
  }
  
  public int getY()
  {
    return yPos;
  }
  
  public void move(boolean direction)
  {
    if (direction)
      yPos-= 5;
    else
      yPos+= 5;  
    
  }
  
  
  public int getBottom()
  {
    return yPos + yLength / 2;
  }
  
  public int getTop()
  {
    return yPos - yLength / 2;
  }
  
   public void AIAct(ArrayList<Gamespace.Ball> balls){}
}
