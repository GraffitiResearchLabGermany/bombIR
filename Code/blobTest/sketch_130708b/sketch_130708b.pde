
void setup() {
  size(displayWidth, displayHeight, P2D);
  noCursor();
}

void draw(){
  
  background(0);
  float animate = abs(sin(radians(frameCount)) * 0.1 + 0.2);
  noStroke();
  fill(255);
  ellipse(mouseX, mouseY, height*animate, height*animate);
}
