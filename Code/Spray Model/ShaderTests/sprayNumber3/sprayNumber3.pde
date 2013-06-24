// http://glsl.heroku.com/e#4633.5

boolean debug = false;

PShader sprayBrush;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

float weight;

float depthOffset;
float offsetVel;

Path s;

void setup() {
  //size(640, 360, P3D);
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  
  sprayMap = loadImage("sprayMap.png");
  
  depthOffset = 0.0;
  offsetVel = 0.0005;

  sprayBrush = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  sprayBrush.set( "sprayMap", sprayMap );

  strokeCap(SQUARE);
  background(0);  
}

void draw() {

  if (mousePressed) {
    if(null!=s) s.add( new Knot(mouseX, mouseY) );
  }
  if( null != s ) s.draw();
}

void mousePressed() {
  Knot mousePos = new Knot(mouseX, mouseY);
  s = new Path(mousePos, 10);
}
