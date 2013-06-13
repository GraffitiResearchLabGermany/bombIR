class Knot extends PVector {
  
  float size;
  float angle;    
  color tint;
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay
  
  Knot(float posX, float posY) {
    super(posX, posY);
    size  = 70.0;
    angle = 0.0;
    tint = color(255,0,0);
    noiseDepth = random(1.0);
    timestamp  = millis();
  }
  
  Knot(float posX, float posY, float size, float angle, color tint, float noiseDepth, float timeStamp) {
    super(posX, posY);
    size = size;
    angle = angle;
    tint = tint;
    noiseDepth = noiseDepth;
    timestamp = timeStamp;
  }
  
  void setColor(color c) {
    tint = c;
  }
  
  PVector getPos() {
    return new PVector(x,y);
  }
  
  void draw() {
    
    float x = this.x;
    float y = this.y;

    pointShader.set( "weight", size );
    pointShader.set( "refAngle", -1.0, 0.0 );
    pointShader.set( "dispersion", 0.2 );
    pointShader.set( "depthOffset", noiseDepth );
    strokeWeight(size);
    
    shader(pointShader, POINTS);
    point(x,y);
    resetShader();
    
    if(debug) {
      pushMatrix();
        pushStyle();
          fill(tint);
          noStroke();
          translate(x,y);
          ellipse(0,0,5,5);
        popStyle();
      popMatrix();
    }
    
  }

}
