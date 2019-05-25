
void drawLines(int x){
  strokeWeight(10);
  for(int i=-100; i<520; i+=20){
    stroke(0,0,255);
    line(0, i+x, 500, i+x);
    stroke(255,255,0);
    line(0, i+x+10, 500, i+x+10);
  }
}

void setup() {
  size(500,500, P3D);
  strokeWeight(10);
  strokeCap(SQUARE);
}

void draw() {
  drawLines(mouseY/5);
  stroke(0,255,0);
  for(int i=10; i<500; i+=20){
    line(100, i, 200, i);
    line(300, i+10, 400, i+10);
  }
}
