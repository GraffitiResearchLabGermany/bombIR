// Nothing new here

PShader sprayBrush;

void setup() {

  size(512, 512, P2D);

  sprayBrush = loadShader("shader.glsl");

  sprayBrush.set( "resolution", float(width), float(height) );

}


void draw() {

  background(255);
  
  sprayBrush.set( "mouse", float(mouseX), float(mouseY) );

  shader(sprayBrush);

  rect( 0, 0, width, height );  

  resetShader();

  // We don't need animation (for now)
  noLoop();
}