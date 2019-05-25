color a, b, c, d, e;
float j;
void setup() {
  size(640, 360);
  noStroke();
  a = color(165, 167, 20);
  b = color(77, 86, 59);
  c = color(42, 106, 105);
  d = color(165, 89, 20);
  e = color(146, 150, 127);
}

void draw() {
  a = color(165 + mouseX % 90, 167, 20);
  b = color(77, (86+mouseY*j)%255, 59);
  c = color(42, 106+mouseX % 149, 105 + mouseY%50);
  d = color((165*j)%255, 89, 20+ mouseX%150);
  e = color((146+ mouseX)%255, (150+mouseY)%255, 127);
  drawBand(a, b, c, d, e, 0, width/128);
  drawBand(c, a, d, b, e, height/4, width/128);
  drawBand(e, b, d, c, a, height/2, width/128);
  drawBand(c, e, d, b, a, 3*height/4, width/128);
}

void drawBand(color v, color w, color x, color y, color z, int ypos, int barWidth) {
  int num = 5;
  color[] colorOrder = { v, w, x, y, z };
  for(int i = 0; i < width; i += barWidth*num) {
    for(int j = 0; j < num; j++) {
      fill(colorOrder[j]);
      rect(i+j*barWidth, ypos, barWidth, height/4);
    }
  }
}

void mouseWheel(MouseEvent event) {
  j = event.getCount();
  println(e);
}
