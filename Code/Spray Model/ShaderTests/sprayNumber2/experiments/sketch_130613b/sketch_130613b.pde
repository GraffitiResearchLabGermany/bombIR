
PVector v1;

void setup() {
  size(500, 500);
}

void draw() {
  background(150);
  v1 = new PVector(mouseX, mouseY);
  stroke(255,0,0);
  line(0,0,v1.x, v1.y);
  
  float steps = 5;
  
  for(int i=1; i<steps; i++ ) {
    PVector v2 = new PVector();
    println(1/steps*i);
    PVector.mult(v1, 1/steps*i, v2);
    //println(v2);
    noStroke();
    fill(0,255,0);
    ellipse(v2.x, v2.y, 5,5);
  }
}
