public class Slider
{
  private int xCorner, yCorner, xLength, yLength;
  private int cursorLoc;
  
  public Slider(int xC, int yC, int xL, int yL)
  {
    xCorner = xC;
    yCorner = yC;
    xLength = xL;
    yLength = yL;
    
    cursorLoc = xCorner;
  }
  
  public void displaySlider()
  {
    fill(255);
    rect(xCorner, yCorner, xLength, yLength);
    
    if (returnPercent() < .25)
    {
      fill(0, 0, 255);
      textSize(20);
      text("Very easy", xCorner, yCorner + yLength + 40);
    }
    
    else if (returnPercent() < .5)
    {
      fill(0, 0, 255);
      textSize(20);
      text("Easy", xCorner + xLength / 4, yCorner + yLength + 40);
    }
    
    else if (returnPercent() < .80)
    {
      fill(125, 0, 125);
      textSize(20);
      text("Medium", xCorner + xLength / 2, yCorner + yLength + 40);
    }
    
    else if (returnPercent() < .95)
    {
      fill(255, 0, 0);
      textSize(20);
      text("Hard", xCorner + xLength - xLength / 4, yCorner + yLength + 40);
    }
    
    else
    {
      fill(255, 0, 0);
      textSize(20);
      text("Default, VERY HARD", xCorner + xLength - 80, yCorner + yLength + 40);
    }
    
    rect(cursorLoc - 5, yCorner - 5, 10, yLength + 5);
  }
  
  public void moveCursor(int x)
  {
    cursorLoc = x;
  }
  
  public double returnPercent()
  {
    return (1.0 * cursorLoc - xCorner) / xLength;
  }
  
  
}
