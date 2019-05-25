int constrainLen(int x){
  return constrain(x,600,600);
}

void drawCircles(int x, int y, int l,int n){
  noFill();
  int p = l/n;
  for(int i=0; i<n; i++){
    circle(x,y,l-p*i);
  }
}

void setup(){
  size(600,600); 
  
}

void draw(){
  background(220);
  strokeWeight(3);
  for(int i=0; i<6;i++){
    stroke(255,0,0);
    line(200*i+100,0,0,200*i+100);
    line(500-200*i,0,600,100+200*i);
  }
  strokeWeight(1);
  stroke(0);
  if (mousePressed != true) {
    for(int i=0;i<3;i++){
      drawCircles(100,100+i*200,200,8);
      drawCircles(300,100+i*200,200,8);
      drawCircles(500,100+i*200,200,8);
    }
  }
}
