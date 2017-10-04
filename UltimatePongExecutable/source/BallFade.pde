public class BallFade extends ArrayList<Fade>
{
   public BallFade()
  {
  } 
  
  public void act()
  {
    if (size() > 10)
      remove(0);
  } 
}
