class Knot extends PVector {
  
  float size;
  float angle;    
  color tint;
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay

  boolean isDrawn = false;
  
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
    
    PVector dir = new PVector(x, y);
    dir.normalize();

    if(!isDrawn) {
      sprayBrush.set( "weight", size );
      sprayBrush.set( "direction", dir.x, dir.y );
      sprayBrush.set( "rotation", random(0.0,1.0), random(0.0,1.0) );
      sprayBrush.set( "scale", 0.5 ); 
      sprayBrush.set( "soften", 1.0 ); // towards 0.0 for harder brush, towards 2.0 for lighter brush
      sprayBrush.set( "depthOffset", noiseDepth );
      strokeWeight(size);
      
      shader(sprayBrush, POINTS);
      point(x,y);
      resetShader();
      
      isDrawn = true;
    }
    
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
