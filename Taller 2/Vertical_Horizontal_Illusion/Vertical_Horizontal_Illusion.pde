void setup(){
  size(600,600);
  strokeWeight(5); 
}

void draw(){
  background(255);
  line(100,500,500,500);
  line(300,100,300,500);  
  if(mousePressed){
    circle(mouseX, mouseY, 400);
  }
}
