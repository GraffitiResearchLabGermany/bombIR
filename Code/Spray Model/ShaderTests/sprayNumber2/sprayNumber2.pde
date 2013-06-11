// http://glsl.heroku.com/e#4633.5

PShader pointShader;

float weight;

float depthOffset;
float offsetVel;

PVector sprayPos;

void setup() {
  //size(640, 360, P3D);
  size(displayWidth, displayHeight, P3D);
  frameRate(120);
  
  sprayPos = new PVector(mouseX,mouseY);
  
  depthOffset = 0.0;
  offsetVel = 0.0005;
  
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  
  strokeCap(SQUARE);
  background(0);  
}

void draw() {
  if (mousePressed) {
    shader(pointShader, POINTS);

    depthOffset += offsetVel;
    
    float w = random(80, 100);
    pointShader.set( "weight", w );
    pointShader.set( "refAngle", -1.0, 0.0 );
    pointShader.set( "dispersion", 0.2 );
    pointShader.set( "depthOffset", depthOffset );
    strokeWeight(w);
    
    stroke(random(255), random(255), random(255));      
    point(mouseX, mouseY);
  }
}
