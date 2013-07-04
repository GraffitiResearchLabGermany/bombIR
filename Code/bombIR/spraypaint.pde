
//-----------------------------------------------------------------------------------------
// SHADER / PAINT

PShader pointShader;

float weight = 100;

float depthOffset;
float offsetVel;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

void setupSpraypaint() {
  depthOffset = 0.0;
  offsetVel = 0.0005;
  
  sprayMap = loadImage("sprayMap.png");
  
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
  pointShader.set( "sprayMap", sprayMap );
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
  pointShader.set( "direction", -1.0, 0.0 );
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



//-----------------------------------------------------------------------------------------
// The Path object contains a list of points

class Path {
  
  ArrayList<Knot> pointList;       // raw point list
  
  Knot previousKnot;
  Knot currentKnot;
  
  float mag;
  float numSteps;
  float distMin = 1;
  float stepSize = 3;
  
  Path() {
  }

  Path(Knot startingPoint) {
    initialize(startingPoint);
  }
  
  Path(Knot startingPoint, float d) {
    stepSize = d;
    initialize(startingPoint);
  }
  
  void initialize(Knot k) {
    
    previousKnot = k;
    currentKnot  = k;
    
    if( null == pointList ) pointList = new ArrayList<Knot>();
    
    pointList.add(previousKnot);
    pointList.add(currentKnot);
  }
  
  void add(Knot p) {
  
    int size = pointList.size();

    previousKnot = pointList.get(size-1);
    currentKnot = p;
    
    // Compute the vector from previous to current knot
    PVector prevPos = previousKnot.getPos();
    PVector newPos  = currentKnot.getPos();
    PVector velocity = PVector.sub(newPos, prevPos);
 
    // How many points can we fit between the two last knots?
    float mag = velocity.mag();
    
    if( mag > stepSize ) {
      numSteps = mag/stepSize;
      for(int i=1; i<numSteps; i++ ) {
        PVector stepper = new PVector();
        PVector.mult(velocity, 1/numSteps*i, stepper);
        stepper.add(prevPos);
        Knot k = new Knot(stepper.x, stepper.y, previousKnot.getSize());
        p.setColor(color(0,255,0));
        pointList.add(k);
      }
    }
    else {
      p.setColor(color(255,0,0));
      pointList.add(p);
    }
    
  }
  
  void draw() {
    for(Knot p: pointList) {
      p.draw();
    }
  }
  
}


//-----------------------------------------------------------------------------------------
// Each point in the path object is a knot with it's own properties (color, size, angle, etc)

class Knot extends PVector {
  
  float size;
  float angle;    
  color tint;
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay

  boolean isDrawn = false;
  
  Knot(float posX, float posY, float weight) {
    super(posX, posY);
    size  = weight;
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
  
  float getSize() {
    return size;
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
