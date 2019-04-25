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

  void update() {
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

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent(float x, float y) {
    if (mouseX > x && mouseX < x+sheight &&
       mouseY > y && mouseY < y+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
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

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos-xpos;
  }

  float getPos2() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos2-xpos+15;
  }
}
