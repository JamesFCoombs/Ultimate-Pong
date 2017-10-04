public class Fade
{
  private int x;
  private int y;
  private int c1;
  private int c2;
  private int c3;
  
  public Fade(int xPos, int yPos, int a, int b, int c)
  {
    x = xPos;
    y = yPos;
    c1 = a;
    c2 = b;
    c3 = c;
  }
  
  public int getX()
  {return x;}
  
  public int getY()
  {return y;}
  
  public int getC1()
  {return c1;}
  
  public int getC2()
  {return c2;}
  
  public int getC3()
  {return c3;}
}
