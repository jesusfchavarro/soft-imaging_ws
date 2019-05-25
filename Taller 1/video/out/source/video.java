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



Movie myMovie;
//Capture myMovie;

PGraphics pg,pg2,pg3,pg4,pg5,pg6;
PImage img, img2, img3, img4, img5;
HScrollbar hs;

int[] histogram;
int COLOR_FILTER = 2;

float[][] conv1 = { { -1, -1, -1 },
                     { -1,  9, -1 },
                     { -1, -1, -1 } }; 
                    
float[][] conv2 = { { 0, 1, 0 },
                  { 1,  -4, 1 },
                  { 0, 1, 0 } }; 

float[][] conv3 = { { 0.11f, 0.11f, 0.11f },
                  { 0.11f, 0.11f, 0.11f },
                  { 0.11f, 0.11f, 0.11f } }; 


public void setup() {
  
  pg = createGraphics(250, 250);
  pg2 = createGraphics(250, 250);
  pg3 = createGraphics(250, 250);
  pg4 = createGraphics(250, 250);
  pg5 = createGraphics(250, 250);
  pg6 = createGraphics(250, 250);

  myMovie = new Movie(this, "movie.ogg");
  myMovie.loop();

  //myMovie = new Capture(this, 250, 250,10); 
  //myMovie.start();
  
  while(!myMovie.available()){
    delay(10);
  }
  myMovie.read();
  img2 = createImage(myMovie.width, myMovie.height, RGB);
  
  hs = new HScrollbar(530, 255, 250, 10);

}

public void draw() {
  println(frameRate);
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
    img2.updatePixels();
    
    pg.beginDraw();
    pg.image(myMovie,0,0);
    pg.endDraw();
    image(pg, 10, 10);
    
    pg2.beginDraw();
    pg2.image(img2,0,0);
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
    
    img3 = convolution(myMovie,conv1,3);

    pg4.beginDraw();
    pg4.image(img3,0,0);
    pg4.endDraw();
    image(pg4, 10, 270); 

    img4 = convolution(myMovie,conv2,3);

    pg5.beginDraw();
    pg5.image(img4,0,0);
    pg5.endDraw();
    image(pg5, 270, 270); 


    img5 = convolution(myMovie,conv3,3);

    pg6.beginDraw();
    pg6.image(img5,0,0);
    pg6.endDraw();
    image(pg6, 530, 270); 
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

public int convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0f;
  float gtotal = 0.0f;
  float btotal = 0.0f;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

public PImage convolution(PImage image,float[][] matrix, int matrixsize){
  PImage covImg = createImage(image.width, image.height, RGB);
  
  image.loadPixels();
  covImg.loadPixels();
  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++ ) {
      int c = convolution(x, y, matrix, matrixsize, image);
      int loc = x + y*image.width;
      covImg.pixels[loc] = c;
    }
  }
  updatePixels();
  return covImg;
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
  public void settings() {  size(790, 530); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "video" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
