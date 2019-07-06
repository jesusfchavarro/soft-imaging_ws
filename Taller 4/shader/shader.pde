PImage img;
PShader shader,shader1,shader2,shader3;
int start,end;

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

void setup() {
  size(1250, 650, P2D);
  textSize(15);
  fill(0,0,0);

  img = loadImage("media/image1.jpg");

  //img.resize(300,300);

  shader = loadShader("convolution.glsl");
  println("img.pixels.length: "+img.pixels.length);

}

void draw() {
  background(200);
  int s = 0;
  start = millis();
  s += soft_conv(img, conv0, 10, 20);
  s += soft_conv(img, conv1, 320, 20); 
  s += soft_conv(img, conv2, 630, 20); 
  s += soft_conv(img, conv4, 940, 20); 
  end = millis();
  text("time: "+(end-start) + ".  sum time:" + s, 10, 15);

  s=0;
  start = millis();
  s += shader_conv(img, conv0, 10, 340);
  s += shader_conv(img, conv1, 320, 340); 
  s += shader_conv(img, conv2, 630, 340); 
  s += shader_conv(img, conv4, 940, 340); 
  end = millis();
  text("time: "+(end-start) + ".  sum time:" + s, 10, 335);
}

int soft_conv(PImage original, float[][] conv, int x,int y){
  PGraphics pg = createGraphics(300, 300);
  start = millis();
  PImage c = convolution(original,conv,3);
  
  c.resize(300,300);
  pg.beginDraw();
  pg.image(c,0,0);
  end = millis();

  pg.textSize(20);
  pg.fill(100,100,100);
  pg.text("time: "+(end-start), 10, 25);
  pg.endDraw();
  image(pg, x, y); 

  return end-start;
}

int shader_conv(PImage original, float[][] conv, int x,int y){
  PGraphics pg = createGraphics(original.width, original.height, P2D);  
  shader.set("texture", pg);
  start = millis();
  shader.set("convKernel", flatten(conv));

  pg.beginDraw();
  pg.shader(shader);
  pg.image(original,0,0); 
  pg.resetShader();
  end = millis();

  pg.setSize(300,300);
  pg.endDraw();
  image(pg, x, y); 
  textSize(20);
  fill(60,60,60);
  text("time: "+(end-start), x+10, y+25);

  return end-start;
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
