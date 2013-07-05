
//-----------------------------------------------------------------------------------------
// SHADER / PAINT

PShader pointShader;
Path s;

float weight = 100;

float depthOffset;
float offsetVel;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

SprayManager sprayCan;

void setupSpraypaint() {
  
  depthOffset = 0.0;
  offsetVel = 0.0005;
  
  sprayMap = loadImage("sprayMap.png");
  
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
  pointShader.set( "sprayMap", sprayMap );
  //pointShader.set("sharpness", 0.9);
  
  paintscreen.strokeCap(SQUARE);
  
  sprayCan = new SprayManager(paintscreen);
  
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
    if(printDebug) println("inside write");
    if(clickedEvent) { 
      if(printDebug) println("writing started");
      sprayCan.newStroke(blobX, blobY, weight);
      clickedEvent = false;
    } else { 
      if(printDebug) println("spray writing now");
      sprayCan.newKnot(blobX, blobY, weight);
    }
  }
  
  // if no controller present, spray on mouse click
  else if(moveConnected == false && mousePressed == true) {
    if(clickedEvent) {
      sprayCan.newStroke(mouseX, mouseY, weight);
      clickedEvent = false;
    } else {
      sprayCan.newKnot(mouseX, mouseY, weight);
    }
  }
  
  sprayCan.draw();
  
}

//-----------------------------------------------------------------------------------------
// The Spray Manager creates, updates, draws and deletes strokes

class SprayManager {
 
 ArrayList<Path> strokeList;
 PGraphics targetBuffer;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
 }
  
 SprayManager(PGraphics buffer) {
   targetBuffer = buffer;
   strokeList = new ArrayList<Path>();
 }
 
 // Draw newly added points
 void draw() {
   for(Path p: strokeList) {
     p.draw();
   }
 }
 
 // Clear the strokes
 void clearAll() {
   
   for(Path p: strokeList) {
     p.clear();
   }
   
   strokeList.clear();
 }
 
 void newStroke(float x, float y, float weight) {
   
   Knot startingKnot = new Knot(x, y, weight);
   
   Path p = new Path(startingKnot);

   if (null!=targetBuffer)  
     p.setBuffer(targetBuffer);
 
   strokeList.add(p);
   
 }
 
 void newKnot(float x, float y, float weight) {
   
   Knot newKnot = new Knot(x, y, weight);
   
   Path activePath = getActivePath();
   activePath.add(newKnot);
   
 }
 
 Path getActivePath() {
   return strokeList.get( strokeList.size() - 1 );
 }

}


//-----------------------------------------------------------------------------------------
// The Path object contains a list of points

class Path {
  
  PGraphics targetBuffer;
  
  ArrayList<Knot> pointList;       // raw point list
  
  Knot previousKnot;
  Knot currentKnot;
  
  float mag;
  float numSteps;
  float distMin = 0;
  float stepSize = 1;
  
  Path() {
  }

  Path(Knot startingPoint) {
    add(startingPoint);
  }
  
  
  Path(Knot startingPoint, float d) {
    stepSize = d;
    add(startingPoint);
  }
  
  
  void setBuffer(PGraphics target) {
    targetBuffer = target;
  }
  
  
  void add(Knot k) {
    
    if( null != targetBuffer) 
      k.setBuffer(targetBuffer);
      
    if( null == pointList ) {
      createList(k);
    }
    else {
      newKnot(k);
    }
    
  }
  
  
  // When the first knot is added, we want to create the list
  void createList(Knot k) {
    
    previousKnot = k;
    currentKnot  = k;
    
    if( null == pointList ) pointList = new ArrayList<Knot>();
    
    pointList.add(previousKnot);
    pointList.add(currentKnot);
  }
  
  
  // Add a new knot and all knots between it and 
  // the previous knot, based on the defined step size
  void newKnot(Knot k) {
    
    int size = pointList.size();

    previousKnot = pointList.get(size-1);
    currentKnot = k;
    
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
        Knot stepKnot = new Knot(stepper.x, stepper.y, previousKnot.getSize());
        pointList.add(stepKnot);
      }
    }
    else {
      pointList.add(k);
    }
    
  }
  
  
  void draw() {
    for(Knot p: pointList) {
      p.draw();
    }
  }
  
  
  void clear() {
    pointList.clear();
  }
  
}


//-----------------------------------------------------------------------------------------
// Each point in the path object is a knot with it's own properties (color, size, angle, etc)

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
