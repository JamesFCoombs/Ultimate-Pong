public class BallFade extends ArrayList<Fade>
{
  
  private int maxSize;
   public BallFade()
  {
    maxSize = 10; 
  }
  
  public BallFade(int x)
  {
    maxSize = x;
  }
  
  public void act()
  {
    if (size() > maxSize)
      remove(0);
  } 
}
