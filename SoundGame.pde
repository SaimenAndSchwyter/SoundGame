import ddf.minim.*; //<>// //<>//

AudioPlayer player;
Minim minim;
int element =0;
int margin = 90;
PImage bg;
int jumpCounter=0;
//Player
int currentY=150;
boolean gameStart =false;
int score;
int currentScore;
int initCount;
long lastTime = 0;

Rect[] rectArray = new Rect[12];
void setup() {
  frameRate(60);
  lastTime = millis();
  size(1024, 200, P2D);
  bg = loadImage("bg.png");
  background(bg);

  reset();
}

void draw() {
  int lowTot = 0;
  for (int i = 0; i < player.left.size()/3.0; i+=5) {
    lowTot+= (abs(player.left.get(i)) * 50 );
  }
  drawRect(element, lowTot);
  println(lowTot);

  element++;
  if (element >=rectArray.length) {
    element =0;
  }
}

void stop() {
  try {
    player.close();
  }
  catch(Exception err) {
  }
}

void jump() {
  jumpLoop(20);
  rejumpLoop(20);
}

void jumpLoop(int eHeight) {
  for (int i=0; i<=eHeight; i++) {
    fill(#11aaff);
    ellipse(50, currentY+i, 20, 20);
  }
  currentY+=eHeight;
}
void rejumpLoop(int eHeight) {
  for (int i=eHeight; i<=0; i--) {
    fill(#11aaff);
    ellipse(50, currentY-i, 20, 20);
  }
  currentY-=eHeight;
}
public class Rect {
  int x;
  int y;
  public Rect(int i, int y) {
    this.x = width+(i * margin);
    this.y = height - (y%200) - 20;
  }
}
void drawRect(int i, int y) {

  //play game  
  noStroke();
  stroke(255);
  fill(#9b3611);
  if (i<rectArray.length) {
    if (rectArray[i] == null) {
      rectArray[i] = new Rect(i, y);
      rect(rectArray[i].x, (rectArray[i].y), 20, 20);
      if (i == rectArray.length-1) {
        margin=0;
      }
    } else {
      if (rectArray[i].x<=0) {
        rectArray[i] = null;
      }
      clear();

      //BG
      background(bg);
      //init game
      if (initCount < 5) {
        textSize(32);
        fill(#000000);
        textAlign(CENTER, CENTER);
        text("Game starts in 10s", width/2, 100);
        if (millis() - lastTime > 10000) {
          initCount++;
        }
      } else {
        //Score
        textSize(15);
        fill(#000000);
        textAlign(RIGHT, CENTER);
        text("Score:"+score, 950, 50);
        fill(#ffa100);
        for (int j=0; j<rectArray.length; j++) {
          if (rectArray[j] != null) {
            rectArray[j].x --;
            rect(rectArray[j].x, (rectArray[j].y), 20, 20);
          }

          if (keyPressed) {
            if (jumpCounter%40 ==0) {
              fill(#ffa100);
              ellipse(50, currentY-1, 20, 20);
              currentY-=1;
            } else {
              jumpCounter++;
            }
          } else {
            int rectelement =0;
            boolean elokay = false;
            for (int k=0; k<rectArray.length; k++) {
              if (rectArray[k] != null) {
                if (rectArray[k].x <= 60 && rectArray[k].x >= 30) {
                  rectelement = k;
                  elokay = true;
                }
              }
            }
            if (rectArray[rectelement] != null && elokay) {
              if (currentY+10 == rectArray[rectelement].y) {
                ellipse(50, currentY, 20, 20);
                currentScore++;
              } else {
                if (!gameStart) {
                  if (rectArray[0].x ==50) {
                    gameStart =true;
                  }
                }
                if (gameStart) {
                  ellipse(50, currentY+1, 20, 20);
                  currentY+=1;
                }
              }
            } else {
              if (gameStart) {
                ellipse(50, currentY+1, 20, 20);
                currentY+=1;
              }
            }
          }
        }
        ellipse(50, currentY, 20, 20);
      }
    }
  }
  if (currentY <0 || currentY>200) {
    reset();
  }
}

void reset() {
  if (currentScore > score) {
    score = currentScore;
  }
  bg = loadImage("bg.png");
  background(bg);
  stop();
  bg = loadImage("bg.png");
  for (int i=0; i<rectArray.length; i++) {
    rectArray[i] =null;
  }

  minim = new Minim(this);
  player = minim.loadFile("song.mp3", 256);
  player.play();
  player.loop();
  element =0;
  margin = 90;
  jumpCounter=0;
  //Player
  currentY=150;
  gameStart =false;
  currentScore=0;
  initCount =0;
  lastTime = millis();
}