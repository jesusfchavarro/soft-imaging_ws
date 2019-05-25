PImage bg;
void drawLinesY(int y, int sw, int gap){
  strokeWeight(sw);
  stroke(0);
  int w = sw + gap;
  for(int i=-100; i<520; i+=w){
    line(0, i+w+y, 500, i+w+y);
  }
}

void drawLinesX(int x, int sw, int gap){
  strokeWeight(sw);
  stroke(0);
  int w = sw + gap;
  for(int i=-0; i<700; i+=w){
    line(i+w+x, 0, i+w+x, 280);
  }
}

void setup() {
  size(684,280);
  strokeWeight(10);
  strokeCap(SQUARE);
  bg = loadImage("animation.png");
}

void draw() {
  background(bg);
  drawLinesX(mouseX,10,2);
  stroke(0,255,0);
}
