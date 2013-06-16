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
  if (mousePressed) {
    
    
    paintscreen.shader(pointShader, POINTS);
    
    depthOffset += offsetVel;
    
    pointShader.set( "weight", weight+random(0,20));
    pointShader.set( "refAngle", -1.0, 0.0 );
    pointShader.set( "dispersion", 0.2 );
    pointShader.set( "depthOffset", depthOffset );
    pointShader.set( "red", colorSlots[activeColorSlot].getRed()/255);
    pointShader.set( "green", colorSlots[activeColorSlot].getGreen()/255);
    pointShader.set( "blue", colorSlots[activeColorSlot].getBlue()/255);
    paintscreen.strokeWeight(weight+random(0,20));
    
    paintscreen.stroke(random(255), random(255), random(255));  
    paintscreen.point(mouseX, mouseY);
  }
}
