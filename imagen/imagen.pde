PGraphics pg,pg2,pg3;
PImage img;
PImage img2;
HScrollbar hs;

int[] histogram = new int[256];
int COLOR_FILTER = 5;

void setup() {
  size(790, 270);
  pg = createGraphics(250, 250);
  pg2 = createGraphics(250, 250);
  pg3 = createGraphics(250, 250);

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
