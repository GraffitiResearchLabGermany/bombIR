
PVector v1;
float mag;
float stepSize = 20;
float numSteps = 5;

void setup() {
  size(500, 500);
}

void draw() {
  background(150);
  v1 = new PVector(mouseX, mouseY);
  mag = v1.mag();
  stroke(255,0,0);
  line(0,0,v1.x, v1.y);
  
  numSteps = mag/stepSize;
  
  for(int i=1; i<numSteps; i++ ) {
    PVector v2 = new PVector();
    println("numSteps = "+numSteps);
    PVector.mult(v1, 1/numSteps*i, v2);
    noStroke();
    fill(0,255,0);
    ellipse(v2.x, v2.y, 5,5);
  }
}
