
//-----------------------------------------------------------------------------------------
// SHADER / PAINT

PShader pointShader;
Path s;

float weight = 100;

float depthOffset;
float offsetVel;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

// Spray renderers
SprayManager sprayManagerLeft; // paint screen (left)
SprayManager sprayManagerRight;  // wall screen (right)


void setupSpraypaint() {
  
  depthOffset = 0.0;
  offsetVel = 0.0005;
  
  sprayMap = loadImage("sprayMap.png");
  
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
  pointShader.set( "sprayMap", sprayMap );
  
  sprayManagerLeft = new SprayManager();
  sprayManagerRight  = new SprayManager();
  
}


void spray() {
  // Setup the Shader
  ColorSlot activeCS = cs.getColorSlot(activeColorSlot);
  
  //paintscreen.shader(pointShader, POINTS);
  //wallscreen.shader(pointShader, POINTS);
  
  depthOffset += offsetVel;

  //use the psmove trigger to change the weight of the spraypaint
  //pointShader.set( "weight", weight+trigger/5);
  //pointShader.set( "direction", -1.0, 0.0 );
  //pointShader.set( "weight", weight + random(0,20));
  //pointShader.set( "dispersion", 0.2 );
  //pointShader.set( "depthOffset", depthOffset );
  //pointShader.set( "red", activeCS.getRed()/255);
  //pointShader.set( "green", activeCS.getGreen()/255);
  //pointShader.set( "blue", activeCS.getBlue()/255);
  //paintscreen.strokeWeight(weight+trigger/5);
  
  color selectedColor = color(activeCS.getRed(), activeCS.getGreen(), activeCS.getBlue());
  
  sprayManagerLeft.setWeight(weight + random(0,20));
  sprayManagerLeft.setColor(selectedColor);
 
  sprayManagerRight.setWeight(weight + random(0,20));
  sprayManagerRight.setColor(selectedColor); 

  // spray when controller trigger is pressed
  if (moveConnected == true && clicked == true) {
    if(clickedEvent) { 
      sprayManagerLeft.newStroke(blobX, blobY, weight);
      sprayManagerRight.newStroke(blobX, blobY, weight);
      clickedEvent = false;
    } else { 
      sprayManagerLeft.newKnot(blobX, blobY, weight);
      sprayManagerRight.newKnot(blobX, blobY, weight);
    }
  }
  
  // if no controller present, spray on mouse click
  else if(moveConnected == false && mousePressed == true) {
    if(clickedEvent) {
      sprayManagerLeft.newStroke(mouseX, mouseY, weight);
      sprayManagerRight.newStroke(mouseX, mouseY, weight);
      clickedEvent = false;
    } else {
      sprayManagerLeft.newKnot(mouseX, mouseY, weight);
      sprayManagerRight.newKnot(mouseX, mouseY, weight);
    }
  }
  
  sprayManagerLeft.draw(paintscreen);
  sprayManagerRight.draw(wallscreen);
  
}


//-----------------------------------------------------------------------------------------
// The Spray Manager creates, updates, draws and deletes strokes


class SprayManager {
 
 ArrayList<Path> strokeList;
 
 color col;
 float size;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
   col = color(0);
 }
 
 
 // Draw newly added points 
 // NOTE: points are only drawn once so you should not redraw the background
 void draw(PGraphics buffer) {
   for(Path p: strokeList) {
     p.draw(buffer);
   }
 }
 
 
 // Clear the screen with a solid color
 
 void reset( PGraphics targetBuffer, color background ) {
   targetBuffer.beginDraw();
   targetBuffer.background(background);
   targetBuffer.endDraw();
   clearAll();
 }
 
 
 // Clear the screen with an image buffer
 
 void reset( PGraphics targetBuffer, PGraphics background ) {
   targetBuffer.beginDraw();
   targetBuffer.image(background,0,0);
   targetBuffer.endDraw();
   clearAll();
 }
 
 
 // Clear the screen with an image
 
 void reset( PGraphics targetBuffer, PImage background ) {
   targetBuffer.beginDraw();
   targetBuffer.image(background,0,0);
   targetBuffer.endDraw();
   clearAll();
 }
 
 // Delete all the strokes
 void clearAll() {
   
   for(Path p: strokeList) {
     p.clear();
   }
   
   strokeList.clear();
 }
 
 void newStroke(float x, float y, float weight) {
   
     Knot startingKnot = new Knot(x, y, weight, col);
     Path p = new Path(startingKnot);
     strokeList.add(p);
   
 }
 
 // Add a point the the current path
 void newKnot(float x, float y, float weight) {
   
   Knot newKnot = new Knot(x, y, weight, col);
   
   Path activePath = getActivePath();
   activePath.add(newKnot);
   
 }
 
 // Return the path beeing drawn at the moment
 Path getActivePath() {
   return strokeList.get( strokeList.size() - 1 );
 }
 
 // Set the size of the spray
 void setWeight(float weight) {
   size = weight;
 }
 
 // Set the color of the spray
 void setColor(color tint) {
   col = tint;
 }
 
 color getColor() {
   return col;
 }

}


//-----------------------------------------------------------------------------------------
// The Path object contains a list of knots (points)



// The Path object contains a list of points

class Path {
  
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
  
  
  void add(Knot k) {
      
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
    PVector prevPos  = previousKnot.getPos();
    PVector newPos   = currentKnot.getPos();
    PVector velocity = PVector.sub(newPos, prevPos);
 
    // How many points can we fit between the two last knots?
    float mag = velocity.mag();
    
    // Create intermediate knots and pass them interpolated parameters
    if( mag > stepSize ) {
      
      numSteps = mag/stepSize;
      for(int i=1; i<numSteps; i++ ) {
        
        float interpolatedX = lerp ( previousKnot.x,  currentKnot.x,  i/numSteps );
        float interpolatedY = lerp ( previousKnot.y,  currentKnot.y,  i/numSteps );
        
        float interpolatedSize  = lerp      ( previousKnot.getSize(),  currentKnot.getSize(),  i/numSteps );
        color interpolatedColor = lerpColor ( previousKnot.getColor(), currentKnot.getColor(), i/numSteps );
        
        Knot stepKnot = new Knot(interpolatedX, interpolatedY, interpolatedSize, interpolatedColor);
        
        //if(previousKnot.getBuffer() == paintscreen) println("paintScreen");
        //if(previousKnot.getBuffer() == wallscreen) println("wallScreen");
        
        pointList.add(stepKnot);
        
      }
    }
    else {
      pointList.add(currentKnot);
    }
    
  }
  
  
  void draw(PGraphics targetBuffer) {
    for(Knot p: pointList) {
      p.draw(targetBuffer);
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
  color col;
  float angle;
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay

  boolean isDrawn = false;
  
  Knot(float x, float y, float weight, color tint) {
    super(x, y);
    size  = weight;
    col   = tint;
    angle = 0.0;
    noiseDepth = random(1.0);
    timestamp  = millis();
  }
  
  /*
  Knot(float x, float y, float size, float angle, float noiseDepth, float timeStamp) {
    super(x, y);
    size = size;
    angle = angle;
    noiseDepth = noiseDepth;
    timestamp = timeStamp;
  }
  */
  
  PVector getPos() {
    return new PVector(x,y);
  }
  
  float getSize() {
    return size;
  }
  
  color getColor() {
    return col; 
  }
  
  void draw(PGraphics targetBuffer) {
    
    float x = this.x;
    float y = this.y;
    
    PVector dir = new PVector(x, y);
    dir.normalize();

    if(!isDrawn) {
      
      pointShader.set( "weight", size );
      pointShader.set( "direction", dir.x, dir.y );
      pointShader.set( "rotation", random(0.0,1.0), random(0.0,1.0) );
      pointShader.set( "scale", 0.3 ); 
      pointShader.set( "soften", 1.0 ); // towards 0.0 for harder brush, towards 2.0 for lighter brush
      pointShader.set( "depthOffset", noiseDepth );
      
      // Draw in the buffer (if one was defined) or directly on the viewport
      if (null!=targetBuffer)  {
        targetBuffer.pushStyle();
        targetBuffer.shader(pointShader, POINTS);
        targetBuffer.strokeWeight(size);
        targetBuffer.stroke(col);
        targetBuffer.point(x,y);
        targetBuffer.popStyle();
        
        targetBuffer.resetShader();
        
        if(printDebug) {
          targetBuffer.pushStyle();
          targetBuffer.noStroke();
          targetBuffer.fill(255,0,0);
          targetBuffer.ellipse(x,y,3,3);
          targetBuffer.popStyle();
        }
      }
      //else                      point(x,y);
      
      //targetBuffer.resetShader();
      
      isDrawn = true;
    }
    
  }

}
