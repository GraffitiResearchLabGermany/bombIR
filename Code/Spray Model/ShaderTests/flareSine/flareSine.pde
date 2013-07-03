PShader myShader;


// Executed once
void setup() {
  size(640, 360, P2D);
 
  myShader = loadShader("shader.glsl");
  myShader.set("iResolution", (float)width, (float)height);
  
}


// Executed every frame
void draw() {
  
  myShader.set("iGlobalTime", millis()/1000.0);

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // We draw the output of the shader onto a rectangle
  // that covers the whole window. In that precise case
  // each fragment will be drawn onto one pixel. However,
  // keep in mind that the analogy pixel / fragment is 
  // only here for convenience and won't always hold true.
  rect(0, 0, width, height);  
  
}
