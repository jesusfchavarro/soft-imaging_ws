import processing.video.*;

Movie myMovie;
PShader shader;
int start,end, c;
boolean shaderActive = false;

float[][] conv0 = { { 0, 0, 0 },
                  { 0,  1, 0 },
                  { 0, 0, 0 } };

float[][] conv1 = { { -1, -1, -1 },
                     { -1,  9.5, -1 },
                     { -1, -1, -1 } }; 
                    
float[][] conv2 = { { 0, -1, 0 },
                  { -1,  4, -1 },
                  { 0, -1, 0 } }; 

float[][] conv3 = { { 0.11, 0.11, 0.11 },
                  { 0.11, 0.11, 0.11 },
                  { 0.11, 0.11, 0.11 } }; 

float[][] conv4 = { { -2, -1, 0 },
                  { -1, 1, 1 },
                  { 0, 1, 2 } }; 

float[][][] convs = {conv0, conv1, conv2, conv3, conv4};

void setup() {
  size(1280, 740, P3D);
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

void draw() {
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

float[] flatten(float[][] matrix){
    float[] s = {};
    for(int i=0; i<matrix.length; i++){
        s = concat(s,matrix[i]);
    }
    return s;
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
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

PImage convolution(PImage image,float[][] matrix, int matrixsize){
  PImage covImg = createImage(image.width, image.height, RGB);
  
  image.loadPixels();
  covImg.loadPixels();
  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++ ) {
      color c = convolution(x, y, matrix, matrixsize, image);
      int loc = x + y*image.width;
      covImg.pixels[loc] = c;
    }
  }
  updatePixels();
  return covImg;
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  if (key == 's')
    shaderActive = !shaderActive;
  if (key == 'd'){
    c = (c+1)%4;
    shader.set("convKernel", flatten(convs[c]));
  }
}