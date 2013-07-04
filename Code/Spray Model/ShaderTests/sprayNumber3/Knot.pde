class Knot extends PVector {
  
  float size;
  float angle;    
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay
  PGraphics targetBuffer;

  boolean isDrawn = false;
  
  Knot(float x, float y, float weight) {
    super(x, y);
    size  = weight;
    angle = 0.0;
    noiseDepth = random(1.0);
    timestamp  = millis();
  }
  
  Knot(float x, float y, float size, float angle, float noiseDepth, float timeStamp) {
    super(x, y);
    size = size;
    angle = angle;
    noiseDepth = noiseDepth;
    timestamp = timeStamp;
  }
  
  PVector getPos() {
    return new PVector(x,y);
  }
  
  float getSize() {
    return size;
  }
  
  void setBuffer(PGraphics target) {
    targetBuffer = target;
  }
  
  void draw() {
    
    float x = this.x;
    float y = this.y;
    
    PVector dir = new PVector(x, y);
    dir.normalize();

    if(!isDrawn) {
      pointShader.set( "weight", size );
      pointShader.set( "direction", dir.x, dir.y );
      pointShader.set( "rotation", random(0.0,1.0), random(0.0,1.0) );
      pointShader.set( "scale", 0.5 ); 
      pointShader.set( "soften", 1.0 ); // towards 0.0 for harder brush, towards 2.0 for lighter brush
      pointShader.set( "depthOffset", noiseDepth );
      strokeWeight(size);
      
      shader(pointShader, POINTS);
      
      // Draw in the buffer (if one was defined) or directly on the viewport
      if (null!=targetBuffer)  targetBuffer.point(x,y);
      else                      point(x,y);
      
      resetShader();
      
      isDrawn = true;
    }
    
    if(debug) {
      pushMatrix();
        pushStyle();
          fill(255,0,0);
          noStroke();
          translate(x,y);
          ellipse(0,0,5,5);
        popStyle();
      popMatrix();
    }
    
  }

}
