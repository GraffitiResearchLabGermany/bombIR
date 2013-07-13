// Nothing new here

PShader myShader;

void setup() {
  size(512, 512, P2D);
}


void draw() {
  
  myShader = loadShader("shader.glsl");
  myShader.set( "resolution", float(width), float(height) );
  myShader.set( "direction", 1.0, 0.0);
  
  background(255);
  
  shader(myShader);

  rect( 0, 0, width, height );  

  resetShader();
}
