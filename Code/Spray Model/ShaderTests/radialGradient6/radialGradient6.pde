PShader sprayBrush;

boolean debug = false;

float depthOffset;
float offsetVel;

// Spray density distribution expressed in grayscale
PImage sprayMap;

void setup() {

  size(800, 800, P2D);
  //size(displayWidth, displayHeight, P2D);
  
  background(0);
  
  sprayMap = loadImage("sprayMap.png");
  
  depthOffset = 0.0;
  offsetVel = 0.0005;

  /*
  sprayBrush = loadShader("shader.glsl");

  sprayBrush.set( "resolution", float(width), float(height) );
  sprayBrush.set( "refAngle", -1.0, 0.0 );
  sprayBrush.set( "dispersion", 0.5 );
  sprayBrush.set( "sprayMap", sprayMap );
  */

}


void draw() {

  //background(0);
  
  //depthOffset += offsetVel;
  
  
  
  sprayBrush = loadShader("shader.glsl");
  
  float t = radians(frameCount*0.95);

  sprayBrush.set( "resolution", float(width), float(height) );
  sprayBrush.set( "depthAngle", random(1.0), random(1.0) );
  sprayBrush.set( "direction", cos(t), sin(t) );
  sprayBrush.set( "scale", 0.5 );
  sprayBrush.set( "soften", 1.4 ); // towards 0.0 for harder brush, towards 2.0 for lighter brush
  sprayBrush.set( "sprayMap", sprayMap );
  
  sprayBrush.set( "depthOffset", random(0,1) );

  shader(sprayBrush);  

  rect( 0, 0, width, height );  

  resetShader();
}

void keyPressed() {
  if (key == 'd' || key == 'D') {
    debug = !debug;
  }
  else if (key == 'r' || key == 'R') {
    background(0);
  }
}

