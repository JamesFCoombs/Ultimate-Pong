
private ArrayList<Ball> balls = new ArrayList<Ball>();
private int timer = 500;
private Paddle padRight;
private Paddle padLeft;
private Slider sizeLeft;
private Slider sizeRight;

private int rightScore;
private int leftScore;

private int gameOver = 0;

private boolean startScreen = true;
private boolean helpScreen = false;
private boolean chooseSizePvP = false;
private boolean chooseSizeAI = false;
private int redScreenCounter = 0;
private boolean gamePaused = false;

private boolean[] lettersPressed = new boolean[4];

private Ball startColor;

private int loseBallX;
private int loseBallY;
private int losePaddleColor;
private int loseBackgroundColor;
private int losePaddleY;
private int loseBallC1;
private int loseBallC2;
private int loseBallC3;
private BallFade loseBallFade;

private boolean isThereAI;

void setup()
{
 size(1000, 500); 

 padRight = new Paddle(width - 10);
 balls.add(new Ball());
 
 startColor = new Ball();
 
 for (int i = 0; i < lettersPressed.length; i++)
 {
   lettersPressed[i] = false;
 }
}

void draw()
{
  if (startScreen)
    {displayStartScreen(); return;}
  if (helpScreen)
    {displayHelpScreen(); return;}
  if (chooseSizePvP)
  {chooseSizePvP(); return;}
  if (chooseSizeAI)
  {chooseSizeAI(); return;}
  if (redScreenCounter > 0)
  {redScreenCounter--; return;}
  if (gameOver == -1)
  {loseDisplay(); return;}
  if (gameOver == 1)
  {loseDisplay(); return;}
  if (gamePaused)
  {return;}
  
  
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

void display()
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
  
  rect(0, padLeft.getTop(), 10, padLeft.getBottom() - padLeft.getTop());
  rect(width - 10, padRight.getTop(), 10, padRight.getBottom() - padRight.getTop());
  
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

void keyPressed()
{
  if (key == 'p' || key == 'P')
    gamePaused = !gamePaused;
  
  
  if (key == 'w')
    lettersPressed[0] = true;
  if (key == 's')
    lettersPressed[1] = true;
    if (key == 'W')
    lettersPressed[0] = true;
  if (key == 'S')
    lettersPressed[1] = true;
  if (keyCode == UP)
    lettersPressed[2] = true;
  if (keyCode == DOWN)
    lettersPressed[3] = true;
    
  if ((chooseSizeAI || chooseSizePvP) && key == ' ')
  {
    chooseSizeAI = false;
    chooseSizePvP = false;
  }
    
  if (gameOver != 0 && key == ' ')
    {gameOver = 0; rightScore = 5; leftScore = 5;}
  if (gameOver != 0 && (key == 'm' || key == 'M'))
    {gameOver = 0; startScreen = true;}
}

void keyReleased()
{
    if (key == 'w')
    lettersPressed[0] = false;
  if (key == 's')
    lettersPressed[1] = false;
    if (key == 'W')
    lettersPressed[0] = false;
  if (key == 'S')
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
        {
          gameOver = -1;
          
          loseBallX = 700;
          loseBallY = 350;
          losePaddleColor = 255;
          loseBackgroundColor = 0;
          losePaddleY = 0;
          loseBallC1 = 255;
          loseBallC3 = 255;
          loseBallC2 = 255;
          loseBallFade = new BallFade(70);
        }
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
        {
          gameOver = 1;
       
          loseBallX = 300;
          loseBallY = 350;
          losePaddleColor = 255;
          loseBackgroundColor = 0;
          losePaddleY = 0;
          loseBallC1 = 255;
          loseBallC3 = 255;
          loseBallC2 = 255;
          loseBallFade = new BallFade(70);
        }
      background(255, 0, 0);
      timer = 30;
      int x = balls.size();
      for (int i = x - 1; i >= 0; i--)
        balls.remove(i); 
      return true;
    }
    return false;
}


private void loseDisplay()
{
  
  if (gameOver == 1)
  {
    if (loseBackgroundColor < 255)
    {
      background(loseBackgroundColor, 0, 0);
     
      for (int i = 0; i < loseBallFade.size(); i++)
      {
        fill(loseBallFade.get(i).getC1(), loseBallFade.get(i).getC2(), loseBallFade.get(i).getC3(), i * 5);
        ellipse(loseBallFade.get(i).getX(), loseBallFade.get(i).getY(), 200, 200);
      }
      
      fill(loseBallC1, loseBallC2, loseBallC3);
      stroke(0);
      ellipse(loseBallX, loseBallY, 200, 200);
      noStroke();
      
      loseBallFade.add(new Gamespace.Fade(loseBallX, loseBallY, loseBallC1, loseBallC2, loseBallC3));
      
      loseBallFade.act();
      
      fill(255, losePaddleColor, losePaddleColor);
      rect(width - 200, losePaddleY - 400, 200, 600);
      
      loseBallC1 -= 1;
      loseBallC2 -= 2;
      loseBallC3 -= 4;
      
      if (loseBallX < width + 200)
      {loseBallX += 4; loseBallY += 1; losePaddleY += 1;}
      else if(losePaddleColor > 85)
      {losePaddleColor-= 3; losePaddleY += 1;}
      else if(losePaddleColor > 0)
      {losePaddleColor-= 3; loseBackgroundColor+= 3; losePaddleY += 1;}
      else
      {loseBackgroundColor+= 3;}
    }
    
    else
    { 
      textSize(100);
      fill(0);
      text("Left Side Wins!", 30, 100); 
        
      textSize(60);
      text("Press space to play again", 200, 250);
      textSize(40);
      text("Or m to go back to the main menu", 200, 320);
      
      if (isThereAI)
      {
        textSize(40);
        text("u suk", 400, 400);
      }
    }
  }
  
if (gameOver == -1)
  {
    if (loseBackgroundColor < 255)
    {
      background(loseBackgroundColor, 0, 0);
     
      for (int i = 0; i < loseBallFade.size(); i++)
      {
        fill(loseBallFade.get(i).getC1(), loseBallFade.get(i).getC2(), loseBallFade.get(i).getC3(), i * 5);
        ellipse(loseBallFade.get(i).getX(), loseBallFade.get(i).getY(), 200, 200);
      }
      
      fill(loseBallC1, loseBallC2, loseBallC3);
      stroke(0);
      ellipse(loseBallX, loseBallY, 200, 200);
      noStroke();
      
      loseBallFade.add(new Gamespace.Fade(loseBallX, loseBallY, loseBallC1, loseBallC2, loseBallC3));
      
      loseBallFade.act();
      
      fill(255, losePaddleColor, losePaddleColor);
      rect(0, losePaddleY - 400, 200, 600);
      
      loseBallC1 -= 1;
      loseBallC2 -= 2;
      loseBallC3 -= 4;
      
      
      if (loseBallX > -200)
      {loseBallX -= 4; loseBallY += 1; losePaddleY += 1;}
      else if(losePaddleColor > 85)
      {losePaddleColor-= 3; losePaddleY += 1;}
      else if(losePaddleColor > 0)
      {losePaddleColor-= 3; loseBackgroundColor+= 3; losePaddleY += 1;}
      else
      {loseBackgroundColor+= 3;}
    }
    
    else
    { 
      textSize(100);
      fill(0);
      text("Right Side Wins!", 30, 100); 
        
      textSize(60);
      text("Press space to play again", 200, 230);
      textSize(40);
      text("Or m to go back to the main menu", 200, 300);
      if (isThereAI && sizeRight.returnPercent() > .95)
      {
        textSize(40);
        text("Holy-...! You did it! You actually....", 300, 360);
        text("Hall of Fame:", 400, 420);
        text("James     Kieto     Jonathon", 400, 480);
      }
    }
  }
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
  
  startColor.colorChange();
  fill(startColor.getC1(), startColor.getC2(), startColor.getC3());
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
    rightScore = 5;
    leftScore = 5;
    if (mouseY > height / 2 - 50 && mouseY < height / 2 + 50)
    {
      if (mouseX > width / 4 - 100 && mouseX < width / 4 + 100)
      {
       isThereAI = false;
       startScreen = false;
       chooseSizePvP = true;
       sizeLeft = new Slider(width / 2 - 375, height / 2 - 5, 300, 10);
       sizeRight = new Slider(width / 2 + 75, height / 2 - 5, 300, 10);
       return;
      }
      if (mouseX > 2 * width / 4 - 100 && mouseX < 2 * width / 4 + 100)
      {
       padLeft = new AIPlayer(10);
       isThereAI = true;
       startScreen = false;
       chooseSizeAI = true;
       sizeRight = new Slider(width / 2 - 150, height / 2 - 5, 300, 10);
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

private void chooseSizePvP()
{
  background(0);
  sizeRight.displaySlider();
  sizeLeft.displaySlider();
  
  fill(255);
  textSize(30);
  text("Space to start", width / 2 - 110, height / 2 + 100);
  
    if (mousePressed)
  {
    if (mouseY > height / 2 - 15 && mouseY < height / 2 + 15)
    {
      if (mouseX > width / 2 + 75 && mouseX < width / 2 + 375)
      {
        sizeRight.moveCursor(mouseX);
      }
      if (mouseX > width / 2 - 375 && mouseX < width / 2 - 75)
      {
        sizeLeft.moveCursor(mouseX);
      }
    }
  }
  padRight = new Paddle(width - 10, (int) (150.0 - 90.0 * sizeRight.returnPercent()));
  padLeft = new Paddle(10, (int) (150.0 - 90.0 * sizeLeft.returnPercent()));
}


private void chooseSizeAI()
{
  background(0);
  sizeRight.displaySlider();
  
  fill(255);
  textSize(30);
  text("Space to start", width / 2 - 110, height / 2 + 100);
  
  if (mousePressed)
  {
    if (mouseY > height / 2 - 15 && mouseY < height / 2 + 15)
    {
      if (mouseX > width / 2 - 150 && mouseX < width / 2 + 150)
      {
        sizeRight.moveCursor(mouseX);
      }
    }
  }
  padRight = new Paddle(width - 10, (int) (150.0 - 90.0 * sizeRight.returnPercent()));
  
}



