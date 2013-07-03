
//-----------------------------------------------------------------------------------------
// SHADER / PAINT

PShader pointShader;

float weight = 100;

float depthOffset;
float offsetVel;

void setupSpraypaint() {
  depthOffset = 0.0;
  offsetVel = 0.0005;
  
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  
  paintscreen.strokeCap(SQUARE);
}

void spray() {
  // Setup the Shader
  ColorSlot activeCS = cs.getColorSlot(activeColorSlot);
  paintscreen.shader(pointShader, POINTS);
  
  depthOffset += offsetVel;

  //use the psmove trigger to change the weight of the spraypaint
  //pointShader.set( "weight", weight+trigger/5);
  pointShader.set( "refAngle", -1.0, 0.0 );
  pointShader.set( "weight", weight + random(0,20));
  pointShader.set( "dispersion", 0.2 );
  pointShader.set( "depthOffset", depthOffset );
  pointShader.set( "red", activeCS.getRed()/255);
  pointShader.set( "green", activeCS.getGreen()/255);
  pointShader.set( "blue", activeCS.getBlue()/255);
  //paintscreen.strokeWeight(weight+trigger/5);
  paintscreen.strokeWeight(weight + random(0,20));
  paintscreen.stroke(random(255), random(255), random(255)); 

  // spray when controller trigger is pressed
  if (moveConnected == true && clicked == true) {
    paintscreen.point(blobX, blobY);  
  }
  // if no controller present, spray on mouse click
  else if(moveConnected == false && mousePressed == true) {
    paintscreen.point(mouseX, mouseY);    
  }
  
}
