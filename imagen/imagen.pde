PGraphics pg,pg2,pg3,pg4,pg5,pg6;
PImage img, img2, img3, img4, img5;
HScrollbar hs;

int[] histogram = new int[256];
int COLOR_FILTER = 1;

float[][] conv1 = { { -1, -1, -1 },
                     { -1,  9, -1 },
                     { -1, -1, -1 } }; 
                    
float[][] conv2 = { { 0, 1, 0 },
                  { 1,  -4, 1 },
                  { 0, 1, 0 } }; 

float[][] conv3 = { { 0.11, 0.11, 0.11 },
                  { 0.11, 0.11, 0.11 },
                  { 0.11, 0.11, 0.11 } }; 


void setup() {
  size(790, 530);
  pg = createGraphics(250, 250);
  pg2 = createGraphics(250, 250);
  pg3 = createGraphics(250, 250);
  pg4 = createGraphics(250, 250);
  pg5 = createGraphics(250, 250);
  pg6 = createGraphics(250, 250);

  img = loadImage("image.jpg");
  img.resize(250,250);
  img2 = createImage(img.width, img.height, RGB);
  

  float c;
  img.loadPixels();

  img2.loadPixels();
  for (int i = 0; i < img.pixels.length; i += 1) { 
    c = toGray(img.pixels[i],COLOR_FILTER);
    img2.pixels[i] = color(c); 
    histogram[(int)c]++;
  }
  img2.updatePixels();

  pg.beginDraw();
  pg.image(img,0,0);
  pg.endDraw();
  image(pg, 10, 10); 

  pg2.beginDraw();
  pg2.image(img2,0,0);
  pg2.endDraw();
  image(pg2, 270, 10); 

  hs = new HScrollbar(530, 255, 250, 10);
  

  img3 = convolution(img,conv1,3);

  pg4.beginDraw();
  pg4.image(img3,0,0);
  pg4.endDraw();
  image(pg4, 10, 270); 

  img4 = convolution(img,conv2,3);

  pg5.beginDraw();
  pg5.image(img4,0,0);
  pg5.endDraw();
  image(pg5, 270, 270); 


  img5 = convolution(img,conv3,3);

  pg6.beginDraw();
  pg6.image(img5,0,0);
  pg6.endDraw();
  image(pg6, 530, 270); 

}

void draw() {

  pg3.beginDraw();
  pg3.noStroke();
  pg3.fill(110);
  pg3.rect(0,0,255,250);
  pg3.stroke(255);
  int histMax = max(histogram);
  for(int i=0; i<histogram.length; i++){
    pg3.line(i,250,i,250-int(map(histogram[i], 0, histMax, 0, 250)));
  }
  pg3.endDraw();
  image(pg3, 530, 10); 

  hs.update();
  hs.display();

  img2.loadPixels();
  for (int i = 0; i < img.pixels.length; i += 1) { 
    img2.pixels[i] = filter(img.pixels[i],COLOR_FILTER,hs.getPos(),hs.getPos2()); 
  }
  img2.updatePixels();
   pg2.beginDraw();
  pg2.image(img2,0,0);
  pg2.endDraw();
  image(pg2, 270, 10); 
}

float toGray(color c,int i){
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

color filterColor(color c,int i){
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


color filter(color c,int i,float min, float max){
  float s = toGray(c,i);
  return s>min && s<max ? filterColor(c,i) : color(255);
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