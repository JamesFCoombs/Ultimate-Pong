import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Gamespace extends PApplet {


private ArrayList<Ball> balls = new ArrayList<Ball>();
private int timer = 500;
private Paddle padRight;
private Paddle padLeft; 

private int rightScore = 5;
private int leftScore = 5;

private int gameOver = 0;

private boolean startScreen = true;
private boolean helpScreen = false;
private int redScreenCounter = 0;

private boolean[] lettersPressed = new boolean[4];

public void setup()
{
 size(1000, 500); 

 padRight = new Paddle(width - 10);
 balls.add(new Ball());
 
 for (int i = 0; i < lettersPressed.length; i++)
 {
   lettersPressed[i] = false;
 }
}

public void draw()
{
  if (startScreen)
    {displayStartScreen(); return;}
  if (helpScreen)
    {displayHelpScreen(); return;}
  if (redScreenCounter > 0)
  {redScreenCounter--; return;}
  if (gameOver == -1)
  {loseDisplay(-1); return;}
  if (gameOver == 1)
  {loseDisplay(1); return;}
  
  
 background(0);
 fill(255);

  padLeft.AIAct(balls);
   
   if (lettersPressed[0] && padLeft.getTop() > 0)  
    padLeft.move(true);
   if (lettersPressed[1] && padLeft.getBottom() < height)  
    padLeft.move(false);
   if (lettersPressed[2] && padRight.getTop() > 0)  
    padRight.move(true);
   if (lettersPressed[3] && padRight.getBottom() < height)  
    padRight.move(false);
 
 for (int i = 0; i < balls.size(); i++)
 {
   if (lose(balls.get(i)))
     {redScreenCounter = 20; return;}
   for (int j = 0; j < balls.size(); j++)
   {
     if (i != j)
     {
        balls.get(i).collidesWith(balls.get(j));
     }
   }
   
   
   if (doeshitWall(balls.get(i)))
    balls.get(i).hitWall();
   if (doeshitPaddle(balls.get(i)))
     balls.get(i).hitPaddle(balls.get(i).getXPos() > width/2);
  
 }
 
 timer--;
 if ((timer < 190 && timer > 160) || (timer < 140 && timer > 110) || (timer < 90 && timer > 60) || timer < 40)
 {
  textSize(75);
   fill(255,0,0);
  text("WARNING", width / 2 - 170, 100); 
 }
 if (timer == 0)
 {
  balls.add(new Ball());
 timer = 500;
 }
  display(); 
}

public void display()
{
  for (int i = 0; i < balls.size(); i++)
  {
    balls.get(i).move(); 
    balls.get(i).colorChange();
    for (int j = 0; j < balls.get(i).path.size(); j++)
    {
      fill(balls.get(i).path.get(j).getC1(), balls.get(i).path.get(j).getC2(), balls.get(i).path.get(j).getC3(), j * 10);
      noStroke();
      ellipse(balls.get(i).path.get(j).getX(), balls.get(i).path.get(j).getY(), Ball.RADIUS * 2, Ball.RADIUS * 2);
    }
    stroke(0);
    fill(balls.get(i).getC1(), balls.get(i).getC2(), balls.get(i).getC3());
    ellipse(balls.get(i).getXPos(), balls.get(i).getYPos(), Ball.RADIUS * 2, Ball.RADIUS * 2);
  }
  
  fill(255);
  
  rect(0, padLeft.getTop(), 10, 60);
  rect(width - 10, padRight.getTop(), 10, 60);
  
  fill(255, 0, 0);
  textSize(50);
  
  text(leftScore, 30, 70);
  text(rightScore, width - 80, 70);
}

private boolean doeshitWall(Ball bll)
{
  return (bll.getYPos() + Ball.RADIUS > height || bll.getYPos() - Ball.RADIUS < 0);
}

private boolean doeshitPaddle(Ball bll)
{
  if (bll.getXPos() - Ball.RADIUS <= 10)
    return (bll.getYPos() < padLeft.getBottom() && bll.getYPos() > padLeft.getTop());
   if (bll.getXPos() + Ball.RADIUS >= width - 10)
    return (bll.getYPos() < padRight.getBottom() && bll.getYPos() > padRight.getTop());
   return false;
}

public void keyPressed()
{
  if (key == 'w')
    lettersPressed[0] = true;
  if (key == 's')
    lettersPressed[1] = true;
  if (keyCode == UP)
    lettersPressed[2] = true;
  if (keyCode == DOWN)
    lettersPressed[3] = true;
    
  if (gameOver != 0 && key == ' ')
    {gameOver = 0; rightScore = 5; leftScore = 5;}
}

public void keyReleased()
{
    if (key == 'w')
    lettersPressed[0] = false;
  if (key == 's')
    lettersPressed[1] = false;
  if (keyCode == UP)
    lettersPressed[2] = false;
  if (keyCode == DOWN)
    lettersPressed[3] = false;
}

private boolean lose(Ball bll)
{
  if (bll.getXPos() < 0)
    {
      leftScore--; 
      if (leftScore == 0)
        gameOver = -1;
      background(255, 0, 0);
      timer = 30;
      int x = balls.size();
      for (int i = x - 1; i >= 0; i--)
        balls.remove(i); 
      return true;
    }
    
    if (bll.getXPos() > width)
    {
      rightScore--; 
      if (rightScore == 0)
        gameOver = 1;
      background(255, 0, 0);
      timer = 30;
      int x = balls.size();
      for (int i = x - 1; i >= 0; i--)
        balls.remove(i); 
      return true;
    }
    return false;
}

private void loseDisplay(int sideLost)
{
  background (125, 0, 255);
  //Text "Player -- Wins!"
  if (gameOver == 1)
  {
    textSize(100);
    fill(255, 125, 0);
    text("Left Side Wins!", 30, 100); 
  }
  
  if (gameOver == -1)
  {
    textSize(100);
    fill(255, 125, 0);
    text("Right Side Wins!", 30, 100); 
  }
  
  textSize(60);
  text("Press space to play again", 200, 250);
}

private void displayStartScreen()
{
  background(0);
  stroke(255);
  fill(0);
  rect(1 * width/4 - 100, height / 2 - 50, 200, 100);
  rect(2 * width/4 - 100, height / 2 - 50, 200, 100);
  rect(3 * width/4 - 100, height / 2 - 50, 200, 100);
  
  textSize(100);
  fill(140, 10, 60);
  text("ULTIMATE PONG", width / 2 - 400, 150);
  
  textSize(40);
  fill(255);
  
  text("Player vs", width / 4 - 90, height / 2 - 10);
  text("Player", width / 4 - 60, height / 2 + 40);
  
  text("Player vs", 2 * width / 4 - 90, height / 2 - 10);
  text("AI", 2 * width / 4 - 20, height / 2 + 40);
  
  text("Help", 3* width / 4 - 45, height / 2 + 15);
  
  if (mousePressed)
  {
    if (mouseY > height / 2 - 50 && mouseY < height / 2 + 50)
    {
      if (mouseX > width / 4 - 100 && mouseX < width / 4 + 100)
      {
       padLeft = new Paddle(10);
       startScreen = false;
       return;
      }
      if (mouseX > 2 * width / 4 - 100 && mouseX < 2 * width / 4 + 100)
      {
       padLeft = new AIPlayer(10);
       startScreen = false;
       return;
      }
      
      if (mouseX > 3 * width / 4 - 100 && mouseX < 3* width / 4 + 100)
      {
       helpScreen = true;
       startScreen = false;
       return;
      }
    }
  }

}

private void displayHelpScreen()
{
  background(0);
  textSize(40);
  fill(255);
  
  text("An easy guide to Pong:", 30, 50);
  
  textSize(30);
    
  text("Each side has 5 'lives'. Losing all of your lives causes you to lose", 30, 130);
  text("the game. You lose a life if you fail to defend your side of the field", 30, 170);
  text("with your paddle.", 30, 210);
  text("The left side controls their paddle with the 'w' and 's' key, and the", 30, 250);
  text("right side controls their paddle with the up and down arrow keys.", 30, 290);
  text("Careful when you see WARNING flash across the screen... Another ball", 30, 330);
  text("is about to spawn!", 30, 370);
  text("Good luck!", 30, 410);
  
  
  fill(0);
  
  rect(width - 250, height - 150, 200, 100);
  
  
  fill(255);
  textSize(40);
  text("Back", width - 195, height - 85);
  
   if (mousePressed)
  {
    if (mouseY > height - 150 && mouseY < height - 50)
    {
      if (mouseX > width - 250 && mouseX < width - 50)
      {
        helpScreen = false;
       startScreen = true;
       return;
      }
    }
  }
  
}






public class AIPlayer extends Paddle
{
 
  public AIPlayer(int x)
  {
    super(x);
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
    xVel = (int)((Math.random() - .5f)*10);
    yVel = (int)((Math.random() - .5f)*10);
    
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
    
    if (choice < .33f)
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
        else if (choice < .66f)
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
  
  public void collidesWith(Ball other)
  {
    if (4 * Ball.RADIUS * Ball.RADIUS <= (xPos - other.getXPos()) * (xPos - other.getXPos()) + (yPos - other.getYPos()) * (yPos - other.getYPos())) 
     return;
     
     double xDif = 1.0f * xPos - other.getXPos();
     double yDif = 1.0f * yPos - other.getYPos();
     double distance = Math.sqrt((yPos - other.getYPos())*(yPos - other.getYPos())+(xPos - other.getXPos())*(xPos - other.getXPos()));
     
     XVelChange = (int) (xDif / distance * Math.abs(xVel - other.getXVel()));
     YVelChange = (int) (yDif / distance * Math.abs(yVel - other.getYVel()));
  }
}
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Gamespace" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
