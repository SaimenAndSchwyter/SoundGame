import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SoundGame extends PApplet {

 //<>//

AudioPlayer player;
Minim minim;
int element =0;
int margin = 90;
PImage bg;
int jumpCounter=0;
//Player
int currentY=150;
boolean gameStart =false;

Rect[] rectArray = new Rect[12];
public void setup() {
  
  reset();
}

public void draw() {


  int lowTot = 0;
  for (int i = 0; i < player.left.size()/3.0f; i+=5) {
    lowTot+= (abs(player.left.get(i)) * 50 );
  }
  drawRect(element, lowTot);
  println(lowTot);

  element++;
  if (element >=rectArray.length) {
    element =0;
  }
}

public void stop() {
  try {
    player.close();
    minim.stop(); 
    super.stop();
  }
  catch(Exception err) {
  }
}

public void jump() {
  jumpLoop(20);
  rejumpLoop(20);
}

public void jumpLoop(int eHeight) {
  for (int i=0; i<=eHeight; i++) {
    fill(0xff11aaff);
    ellipse(50, currentY+i, 20, 20);
  }
  currentY+=eHeight;
}
public void rejumpLoop(int eHeight) {
  for (int i=eHeight; i<=0; i--) {
    fill(0xff11aaff);
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
public void drawRect(int i, int y) {
  noStroke();
  stroke(255);
  fill(0xff9b3611);
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
      //Air
      fill(0xffd4e3fc);
      stroke(0xffd4e3fc);
      int wolken = width/40;
      for (int g=0; g<=wolken; g++) {
        ellipse((g*40)+20, 0, 40, 40);
      }
      fill(0xffffa100);
      for (int j=0; j<rectArray.length; j++) {
        if (rectArray[j] != null) {
          rectArray[j].x --;
          rect(rectArray[j].x, (rectArray[j].y), 20, 20);
        }

        if (keyPressed) {
          if (jumpCounter%40 ==0) {
            fill(0xffffa100);
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
  if (currentY <0 || currentY>200) {
    reset();
  }
}

public void reset() {
  bg = loadImage("bg.png");
  stop();
  for (int i=0; i<10; i++) {
    textSize(32);
    fill(0xff11aaff);
    textAlign(CENTER, CENTER);
    text("Game starts in "+i+"s", width, 200);
    delay(1000);
  }
  clear();
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
}
  public void settings() {  size(1024, 200, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SoundGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
