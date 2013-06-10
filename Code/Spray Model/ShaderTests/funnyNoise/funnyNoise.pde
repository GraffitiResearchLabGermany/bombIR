PShader sprayBrush;

void setup() {

  size(1000, 1000, P2D);

  sprayBrush = loadShader("shader.glsl");

  sprayBrush.set( "resolution", float(width), float(height) );
  sprayBrush.set( "refAngle", -1.0, 0.0 );
  sprayBrush.set( "dispersion", 0.5);

}


void draw() {

  background(255);

  shader(sprayBrush);

  rect( 0, 0, width, height );  

  resetShader();
}
