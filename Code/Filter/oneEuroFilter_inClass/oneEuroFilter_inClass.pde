
oneEuroFilter filter;

void setup() {
  size(500,500);
  frameRate(60);
  filter = new oneEuroFilter();
}


void draw() {
  
  background(150);
  
  noFill();
  
  // draw ellipse at actual position
  //stroke(100, 100, 100);
  //ellipse(mouseX, mouseY, 10, 10);
  
  float noiseX = mouseX + random(-10,+10);
  float noiseY = mouseY + random(-10,+10);
  
  PVector noisePos = new PVector(noiseX, noiseY);
  
  println("");
  println("noisePos = " + noisePos);
  
  pushMatrix();
  // draw ellipse at noisy position
  stroke(255, 0, 0);
  ellipse(noiseX, noiseY, 15, 15);
  popMatrix();
  
  PVector filteredPos = filter.getFilteredValues(noiseX/width, noiseY/height);
  
  println("filteredPos = " + filteredPos);
  
  pushMatrix();
  // draw ellipse at noisy position
  stroke(0, 255, 0);
  ellipse(filteredPos.x * width, filteredPos.y * height, 20, 20);
  popMatrix();
  
}


