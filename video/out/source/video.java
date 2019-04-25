import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class video extends PApplet {



//Movie myMovie;
Capture myMovie;

PGraphics pg,pg2,pg3;
PImage img;
PImage img2;
HScrollbar hs;

int[] histogram;
int COLOR_FILTER = 6;

public void setup() {
  
  pg = createGraphics(250, 250);
  pg2 = createGraphics(250, 250);
  pg3 = createGraphics(250, 250);

  //myMovie = new Movie(this, "movie.ogg");
  //myMovie.loop();

  myMovie = new Capture(this, 250, 250,10); 
  myMovie.start();
  
  while(!myMovie.available()){
    delay(10);
  }
  myMovie.read();
  println(myMovie.width);
  println(myMovie.height);
  img2 = createImage(myMovie.width, myMovie.height, RGB);
  
  hs = new HScrollbar(530, 255, 250, 10);

}

public void draw() {
  if (myMovie.available()) {    
    myMovie.read();
    myMovie.loadPixels();
    img2.loadPixels();
    float c;
    histogram = new int[256];
    for (int i = 0; i < myMovie.pixels.length; i += 1) { 
      c = toGray(myMovie.pixels[i],COLOR_FILTER);
      img2.pixels[i] = filter(myMovie.pixels[i],COLOR_FILTER,hs.getPos(),hs.getPos2());; 
      
      histogram[(int)c]++;
    }
    myMovie.updatePixels();
    img2.updatePixels();
    
    pg.beginDraw();
    pg.image(myMovie,-90,-20);
    pg.endDraw();
    image(pg, 10, 10);
    
    pg2.beginDraw();
    pg2.image(img2,-90,-20);
    pg2.endDraw();
    image(pg2, 270, 10); 
    
    pg3.beginDraw();
    pg3.noStroke();
    pg3.fill(110);
    pg3.rect(0,0,255,250);
    pg3.stroke(255);
    int histMax = max(histogram);
    for(int i=0; i<histogram.length; i++){
      pg3.line(i,250,i,250-PApplet.parseInt(map(histogram[i], 0, histMax, 0, 250)));
    }
    pg3.endDraw();
    image(pg3, 530, 10); 
  
    hs.update();
    hs.display();
  }
}

public float toGray(int c,int i){
  switch (i){
    case 1: return (red(c) + green(c) + blue(c))/3;
    case 2: return brightness(c);
    case 3: return (saturation(c) + brightness(c) + hue(c))/3;
    case 4: return red(c);
    case 5: return green(c);
    case 6: return blue(c);
    default: return brightness(c);
  }
}

public int filterColor(int c,int i){
  switch (i){
    case 1: return color((red(c) + green(c) + blue(c))/3);
    case 2: return color(brightness(c));
    case 3: return color((saturation(c) + brightness(c) + hue(c))/3);
    case 4: return color(red(c),0,0);
    case 5: return color(0,green(c),0);
    case 6: return color(0,0,blue(c));
    default: return color(brightness(c));
  }
}


public int filter(int c,int i,float min, float max){
  float s = toGray(c,i);
  return s>=min && s<=max ? filterColor(c,i) : color(255);
}
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, spos2;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  boolean locked,locked2;
  boolean over,over2;

  HScrollbar (float xp, float yp, int sw, int sh) {
    swidth = sw;
    sheight = sh;
    xpos = xp;
    ypos = yp;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;

    spos = sposMin;
    spos2 = sposMax;

  }

  public void update() {
    over = overEvent(spos,ypos);
    float m = constrain(mouseX-sheight/2, sposMin, sposMax);
    locked = mousePressed && (over || locked);
    if (locked && !locked2 && m+sheight/2 < spos2) {
      spos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }

    over2 = overEvent(spos2,ypos);
    locked2 = mousePressed && (over2 || locked2);
    if (locked2 && !locked && m-sheight/2 > spos) {
      spos2 = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
  }

  public float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  public boolean overEvent(float x, float y) {
    if (mouseX > x && mouseX < x+sheight &&
       mouseY > y && mouseY < y+sheight) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {
    noStroke();
    fill(250);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0);
    } else {
      fill(102);
    }
    rect(spos, ypos, sheight, sheight);
    rect(spos2, ypos, sheight, sheight);
  }

  public float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos-xpos;
  }

  public float getPos2() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos2-xpos+15;
  }
}
  public void settings() {  size(790, 270); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "video" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
