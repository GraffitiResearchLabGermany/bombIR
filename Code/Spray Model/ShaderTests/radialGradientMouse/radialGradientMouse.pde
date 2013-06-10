PShader sprayBrush;

boolean debug = false;

float depthOffset;
float offsetVel;

void setup() {

  size(800, 800, P2D);
  //size(displayWidth, displayHeight, P2D);
  
  depthOffset = 0.0;
  offsetVel = 0.0005;

  sprayBrush = loadShader("shader.glsl");

  sprayBrush.set( "resolution", float(width), float(height) );
  sprayBrush.set( "refAngle", -1.0, 0.0 );
  sprayBrush.set( "dispersion", 0.5 );

}


void draw() {

  background(0);
  
  depthOffset += offsetVel;
  
  sprayBrush.set( "depthOffset", depthOffset );

  shader(sprayBrush);  

  rect( 0, 0, width, height );  

  resetShader();
}

void keyPressed() {
  if (key == 'd' || key == 'D') {
    debug = !debug;
  }
}

