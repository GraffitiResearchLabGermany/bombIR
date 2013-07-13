PShader myShader;

// Mouse clicks
float left = 0.0, right = 0.0;


void setup() {
  //size(640, 360, P2D);
  size(640, 640, P2D);    
}


void draw() {
  myShader = loadShader("shader.glsl");
  myShader.set("iResolution", float(width), float(height));
  myShader.set("iGlobalTime", millis()/1000.0);
  
  if(mousePressed) {
    
    if(mouseButton == LEFT) left = 1.0;
    else left = 0.0;
    if(mouseButton == RIGHT) right = 1.0;
    else right = 0.0;
    
    myShader.set("iMouse", float(mouseX), float(mouseY), left, right);
  }

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // We draw the output of the shader onto a rectangle
  // that covers the whole window. In that precise case
  // each fragment will be drawn onto one pixel. However,
  // keep in mind that the analogy pixel / fragment is 
  // only here for convenience and won't always hold true.
  rect(0, 0, width, height);  
  
}
