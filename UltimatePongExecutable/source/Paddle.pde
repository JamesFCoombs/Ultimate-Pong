public class Paddle{
  
  private int xPos;
  private int yPos;

public Paddle(int x)
  {
    xPos = x;
    yPos = height/2;
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
    return yPos + 30;
  }
  
  public int getTop()
  {
    return yPos - 30;
  }
  
   public void AIAct(ArrayList<Gamespace.Ball> balls){}
}
