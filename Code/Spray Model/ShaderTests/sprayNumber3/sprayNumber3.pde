// http://glsl.heroku.com/e#4633.5

boolean debug = false;

SprayManager sprayCan;

PShader pointShader;

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
  
  sprayCan = new SprayManager();

  sprayMap = loadImage("sprayMap.png");

  depthOffset = 0.0;
  offsetVel = 0.0005;

  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  pointShader.set( "sprayMap", sprayMap );

  strokeCap(SQUARE);
  background(0);
}

void draw() {

  weight = sin(radians(frameCount)) * 100.0;
  pointShader.set( "weight", weight );
  strokeWeight(weight);
  stroke(100, 255, 150);  
  println(weight);

  if (mousePressed) {
    if ( null!= sprayCan ) 
      sprayCan.newKnot( mouseX, mouseY, weight );
  }
  
  if ( null != sprayCan ) sprayCan.draw();
}

void mousePressed() {
  sprayCan.newStroke(mouseX, mouseY, weight);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    background(0);
  }
}

