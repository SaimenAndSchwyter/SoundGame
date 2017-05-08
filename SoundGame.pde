import ddf.minim.*;

AudioPlayer player;
Minim minim;
int element =0;
int margin = 45;

Rect[] rectArray = new Rect[24];
void setup(){
  size(1024, 200, P2D);

  minim = new Minim(this);
  player = minim.loadFile("song.mp3", 256);
  player.play();
  player.loop();
}

void draw(){
   int lowTot = 0;
  for (int i = 0; i < player.left.size()/3.0; i+=5){
    lowTot+= (abs(player.left.get(i)) * 50 );
  }
  drawRect(element,lowTot);
  println(lowTot);

  element++;
    if(element >=rectArray.length){
    element =0;}
}

void stop(){
  player.close();
  minim.stop(); 
  super.stop();
}
public class Rect{
int x;
int y;
 public Rect(int i,int y){
  this.x = width+(i * margin);
  this.y = height - (y%200) - 20;
 
}

}
void drawRect(int i, int y){
    noStroke();
  stroke(255);
if(i<rectArray.length){
if(rectArray[i] == null){
      rectArray[i] = new Rect(i,y);
      rect(rectArray[i].x,(rectArray[i].y),20,20);
      if(i == rectArray.length-1){
      margin=0;}
    }else{
      if(rectArray[i].x<=0){
        rectArray[i] = null;
      }
      
         
  clear();
      for(int j=0;j<rectArray.length;j++){
        if(rectArray[j] != null){
      rectArray[j].x --;
      rect(rectArray[j].x,(rectArray[j].y),20,20);}
        } 
    
    }
}}