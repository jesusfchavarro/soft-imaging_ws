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

public class shaderVideo extends PApplet {



Movie myMovie;
PShader shader;
int start,end, c;
boolean shaderActive = false;

float[][] conv0 = { { 0, 0, 0 },
                  { 0,  1, 0 },
                  { 0, 0, 0 } };

float[][] conv1 = { { -1, -1, -1 },
                     { -1,  9.5f, -1 },
                     { -1, -1, -1 } }; 
                    
float[][] conv2 = { { 0, -1, 0 },
                  { -1,  4, -1 },
                  { 0, -1, 0 } }; 

float[][] conv3 = { { 0.11f, 0.11f, 0.11f },
                  { 0.11f, 0.11f, 0.11f },
                  { 0.11f, 0.11f, 0.11f } }; 

float[][] conv4 = { { -2, -1, 0 },
                  { -1, 1, 1 },
                  { 0, 1, 2 } }; 

float[][][] convs = {conv0, conv1, conv2, conv3, conv4};

public void setup() {
  
  textSize(15);
  fill(0,0,0);

  myMovie = new Movie(this, "media/video.mp4");
  myMovie.loop();
  myMovie.play();

  shader = loadShader("convolution.glsl");
  shader.set("convKernel", flatten(convs[2]));
  println("myMovie.pixels.length: "+myMovie.pixels.length);
  println("myMovie.width: "+myMovie.width);
  println("myMovie.height: "+myMovie.height);

}

public void draw() {
  background(200);
  start = millis();
  if(shaderActive){
    shader(shader);      
    image(myMovie, 0, 20);
    resetShader();
  }else{
    image(convolution(myMovie,convs[c],3), 0, 20);
  }
  end = millis();
  text("time: "+(end-start) + ".  frameRate:" + frameRate, 10, 15);
  println("time: "+(end-start) + ".  frameRate:" + frameRate);
}

public float[] flatten(float[][] matrix){
    float[] s = {};
    for(int i=0; i<matrix.length; i++){
        s = concat(s,matrix[i]);
    }
    return s;
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

public void movieEvent(Movie m) {
  m.read();
}

public void keyPressed() {
  if (key == 's')
    shaderActive = !shaderActive;
  if (key == 'd'){
    c = (c+1)%4;
    shader.set("convKernel", flatten(convs[c]));
  }
}
  public void settings() {  size(1280, 740, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "shaderVideo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
