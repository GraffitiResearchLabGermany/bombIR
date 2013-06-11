// Example by Amnon Owed
// https://forum.processing.org/topic/how-to-find-points-on-a-curve-and-display-them

int currentCurvePoint;
PVector[] vecs = {
  new PVector(84, 91), // control point
  new PVector(84, 91),
  new PVector(68, 19),
  new PVector(21, 17),
  new PVector(32, 100),
  new PVector(32, 100) // control point
};
 
void setup() {
  size(200, 200);
  smooth();
}
 
void draw() {
  background(255);
  translate(50, 50);
  vecs[3].set(mouseX-50, mouseY-50, 0);
  drawShape();
  drawPoints();
  if (frameCount % 20 == 0) { currentCurvePoint++; }
  drawCurvePoint(currentCurvePoint % (vecs.length-3));
}
 
void drawShape() {
  noFill();
  stroke(0);
  beginShape();
  for (int i=0; i<vecs.length; i++) {
    curveVertex(vecs[i].x, vecs[i].y);
  }
  endShape();
}
 
void drawPoints() {
  noStroke();
  fill(255, 0, 0);
  for (int i=1; i<vecs.length-1; i++) {
    ellipse(vecs[i].x, vecs[i].y, 5, 5);
  }
}
 
void drawCurvePoint(int num) {
  noStroke();
  fill(0, 0, 255);
  float t = (frameCount % 20)/20.0;
  float x = curvePoint(vecs[num].x, vecs[num+1].x, vecs[num+2].x, vecs[num+3].x, t);
  float y = curvePoint(vecs[num].y, vecs[num+1].y, vecs[num+2].y, vecs[num+3].y, t);
  ellipse(x, y, 15, 15);
}

