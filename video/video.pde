import processing.video.*;

//Movie myMovie;
Capture myMovie;

PGraphics pg,pg2,pg3;
PImage img;
PImage img2;
HScrollbar hs;

int[] histogram;
int COLOR_FILTER = 6;

void setup() {
  size(790, 270);
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

void draw() {
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
      pg3.line(i,250,i,250-int(map(histogram[i], 0, histMax, 0, 250)));
    }
    pg3.endDraw();
    image(pg3, 530, 10); 
  
    hs.update();
    hs.display();
  }
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
  return s>=min && s<=max ? filterColor(c,i) : color(255);
}
