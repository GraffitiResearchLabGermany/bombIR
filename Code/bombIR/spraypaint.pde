PShader pointShader;

float weight;

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
    
    float w = random(60, 80);
    pointShader.set( "weight", w );
    pointShader.set( "refAngle", -1.0, 0.0 );
    pointShader.set( "dispersion", 0.2 );
    pointShader.set( "depthOffset", depthOffset );
    paintscreen.strokeWeight(w);
    
    paintscreen.stroke(random(255), random(255), random(255));  
    paintscreen.point(mouseX, mouseY);
  }
}
