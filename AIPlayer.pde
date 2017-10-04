
public class AIPlayer extends Paddle
{
 
  public AIPlayer(int x)
  {
    super(x);
  }
  public AIPlayer(int x, int y)
  {
    super(x, y);
  }
  
  public void AIAct(ArrayList<Gamespace.Ball> balls)
  {
   int priorityBall = priority(balls);
   if (priorityBall == -1)
    return;
   int yDes = destination(balls.get(priorityBall));
   if (yDes > getY())
   {
     move(false);
   } 
   else if (yDes < getY())
   {
     move(true);
   }
  }
  
  private int priority(ArrayList<Ball> balls)
  {
    int priority = 0;
    if (balls.size() == 0)
     return -1;
    int time = 1000; //width / 1;
    for (int i = 0; i < balls.size(); i++)
    {
      if (balls.get(i).getXVel() < 0 && -1 * balls.get(i).getXPos() / balls.get(i).getXVel() < time)
      {time = -1 * balls.get(i).getXPos() / balls.get(i).getXVel(); priority = i;}
    }
    return priority;
  }
  
  private int destination(Ball ball)
  {
    if (ball.getXVel() > 0)
     return 250;
    boolean yDir = true;
    int y = ball.getYPos();
    for (int i = ball.getXPos(); i > 10; i += ball.getXVel())
    {
      if (y < 0 || y > 500)
       yDir = !yDir;
       
      if (yDir)
       y += ball.getYVel();
      else
       y -= ball.getYVel();      
    }
    return y;
  }
}

