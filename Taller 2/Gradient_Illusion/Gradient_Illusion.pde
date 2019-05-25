float bx=225;
float by=100;
int boxSize = 50;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0; 

void backgroundColor(){
  for(float i=0; i<510; i++){
    stroke(i/2);
    line(i,0,i,200);
  }
  noStroke();
  fill(120);
  rect(10,10,50,50);
  rect(450,10,50,50);
}

void setup(){
  size(510,200);  
  backgroundColor();
}

void draw(){
  backgroundColor();
  overBox = mouseX > bx-boxSize && mouseX < bx+boxSize && 
      mouseY > by-boxSize && mouseY < by+boxSize;  

  rect(bx, by, boxSize, boxSize);   
}


void mousePressed() {
  if(overBox) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by; 

}

void mouseDragged() {
  if(locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset; 
  }
}

void mouseReleased() {
  locked = false;
}
