
//-----------------------------------------------------------------------------------------
// SHADER / PAINT


//-----------------------------------------------------------------------------------------
// The Spray Manager creates, updates, draws and deletes strokes


class SprayManager { 
 
  ArrayList<Path> strokeList;
   
  PShader pointShader;
  Path s;
  
  float depthOffset;
  float offsetVel;
  
  // Spray density distribution expressed in grayscale gradient
  PImage sprayMap;
 
   color col;
   float weight = brushSize;
 
 //boolean clickEv;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
   col = color(0);
 }
 
 void setup() {
    
    depthOffset = 0.0;
    offsetVel = 0.0005;
    
    // brushMap is set in settings.properties
    sprayMap = loadImage(brushMap);
    
    pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
    pointShader.set( "sprayMap", sprayMap );
    
  }

  void initSpray() {
  //if(printDebug) println("void initSpray() {");
  
      Path newStroke = new Path();
      logger.fine("Path newStroke = new Path();");
      
      logger.fine("strokeList.size()"+strokeList.size());
      
      strokeList.add(newStroke);
      logger.fine("strokeList.add(newStroke);");
      
      logger.fine("strokeList.size()"+strokeList.size());
      
  }
  
  // Remove from the bottom of the stroke list if it becomes too long
  void limitStrokes(int maxStrokes) {
    
    logger.fine("strokeList.size() = " + strokeList.size());
    
    if( maxStrokes >= 2 ) {
      if( strokeList.size() > maxStrokes ) {
        strokeList.remove(0);
        logger.fine(", removing a stroke from index O.");
      }
    } else {
        logger.severe("maxStrokes can't be inferior to 2");
    }
  }
  
  void spray(PGraphics targetBuffer) {

    
    
    depthOffset += offsetVel;
    
    
    // OPTIMIZE: move outside of the class. This should be passed to the object.
    ColorSlot activeCS = cs.getColorSlot(activeColorSlot);
    color selectedColor = color(activeCS.getRed(), activeCS.getGreen(), activeCS.getBlue());
    
    //this.setWeight(weight);
    this.setColor(selectedColor);
    
    if( clicked == true ) {
      
      Path stroke = getActiveStroke();
  
  
      // OPTIMIZE: manage the different coordinates (mouse  
      // or controller) outside of the SprayManager class.
      
      // spray when controller trigger is pressed
      if ( moveConnected == true && alwaysUseMouse == false ) {
          Knot k = new Knot(firstWindowWidth - blobX, blobY, weight, col);
          stroke.add(k);
      }
      
      // if no controller present or we chose to use mouse by default, spray on mouse click
      else  {
          Knot k = new Knot(mouseX, mouseY, weight, col);
          stroke.add(k);
      }
      
      // IMPLEMENT: Remove from the bottom of the Knot list if it becomes to large
    
    }
    
    
    this.draw(targetBuffer);
    
  }
 
 
 // Draw newly added points 
 // NOTE: points are only drawn once so you should not redraw the background
 void draw(PGraphics buffer) {
   for(Path p: strokeList) {
     p.draw(buffer, pointShader);
   }
 }
 
 
 // Show an indicator for the brushSize
 void showSize(PGraphics buffer) {
   buffer.pushStyle();
   buffer.noFill();
   buffer.strokeWeight(1);
   buffer.stroke(20, 20, 20, 100);
   
   // OPTIMIZE: manage the different coordinates (mouse  
   // or controller) outside of the SprayManager class.
   
   if ( moveConnected == true && alwaysUseMouse == false ) {
     buffer.ellipse(blobX, blobY, weight, weight);
   } else {
     buffer.ellipse(mouseX, mouseY, weight, weight);
   }
   
   
   
   buffer.popStyle();
 }
 
 
 // Clear the screen with a solid color
 
 void reset( PGraphics targetBuffer, color background ) {
   
   targetBuffer.beginDraw();
   targetBuffer.background(background);
   targetBuffer.endDraw();
   clearAll();
   
 }
 
 
 // Clear the screen with a frame buffer (PGraphics)
 
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
 
 /*
 void newStroke(float x, float y, float weight) {
 if(printDebug) println("void newStroke(float x, float y, float weight) {");
   
     Knot startingKnot = new Knot(x, y, weight, col);
     if(printDebug) println("Knot startingKnot = new Knot(x, y, weight, col);");
     
     Path stroke = new Path();
     if(printDebug) println("Path stroke = new Path();");
     
     stroke.add(startingKnot);
     if(printDebug) println("stroke.add(startingKnot);");
     
     strokeList.add(stroke);
     if(printDebug) println("strokeList.add(stroke);");
   
 }
 */
 
 /*
 // Add a point the the current path
 void newKnot(float x, float y, float weight) { 
 if(printDebug) println("void newKnot(float x, float y, float weight) {");
 
   Knot newKnot = new Knot(x, y, weight, col);
   if(printDebug) println("Knot newKnot = new Knot(x, y, weight, col);");
   
   //activeStroke.add(newKnot);
   //if(printDebug) println("activeStroke.add(newKnot);");
   
 }
 */
 
 // Return the path beeing drawn at the moment
 Path getActiveStroke() {
   logger.finest("Path getActiveStroke() {");
   
   logger.finest("(strokeList.size() - 1) = "+(strokeList.size() - 1)); 
   
   Path activeStroke = strokeList.get( strokeList.size() - 1 );
   logger.finest("Path p = strokeList.get( strokeList.size() - 1 ); ["+ (strokeList.size() - 1) +"]");
   
   return activeStroke;
 }
 
 // Set the size of the spray (overwrite the value from setting.properties)
 void setWeight(float size) {
   weight = size;
   brushSize = size; // 
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
    pointList = new ArrayList<Knot>();
  }
  
  /*
  // When the first knot is added, we want to create the list
  void createList(Knot k) {
    
    previousKnot = k;
    currentKnot  = k;
    
    if( null == pointList ) pointList = new ArrayList<Knot>();
    
    pointList.add(previousKnot);
    pointList.add(currentKnot);
  }
  */
  
  // Add a new knot and all knots between it and 
  // the previous knot, based on the defined step size
  void add(Knot k) {
    
    currentKnot = k;
    logger.finest("currentKnot = k;");
    
    int size = pointList.size();
    logger.finest("int size = pointList.size();");
    
    if(size == 0) { 
      logger.finest("if(size == 0) { ");
    
      pointList.add(currentKnot); 
      logger.finest("pointList.add(currentKnot);");
      
    } else if( size > 0 ) {
      
      /*
      int prev = ( size-1 < 0 ) ? 0 : size-1; // filter negative values
      if(printDebug) println("int prev = ( size-1 < 0 ) ? 0 : size-1; ["+prev+"]");
      */
      
      previousKnot = pointList.get( size-1 );
      logger.finest("previousKnot = pointList.get( prev );");
      
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
    
  }
  
  
  void draw(PGraphics targetBuffer, PShader pointShader) {
    for(Knot p: pointList) {
      p.draw(targetBuffer, pointShader);
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
  
  Knot(float x, float y, float s, color tint) {
    super(x, y);
    size  = s;
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
  
  void draw(PGraphics targetBuffer, PShader pointShader) {
    
    float x = this.x;
    float y = this.y;
    
    PVector dir = new PVector(x, y);
    dir.normalize();

    if(!isDrawn) {
      
      pointShader.set( "weight", brushSize ); // set in settings.properties
      pointShader.set( "direction", dir.x, dir.y );
      pointShader.set( "rotation", random(0.0,1.0), random(0.0,1.0) );
      pointShader.set( "scale", 0.3 );
      pointShader.set( "soften", brushSoften ); // set in settings.properties
      pointShader.set( "depthOffset", noiseDepth );
      
      // Draw in the buffer (if one was defined) or directly on the viewport
      if (null!=targetBuffer)  {
        targetBuffer.pushStyle();
        targetBuffer.shader(pointShader, POINTS);
        targetBuffer.strokeWeight(brushSize); // set in settings.properties
        targetBuffer.stroke(col);
        targetBuffer.point(x,y);
        targetBuffer.popStyle();
        
        targetBuffer.resetShader();
        
        /*
        if(printDebug) {
          targetBuffer.pushStyle();
          targetBuffer.noStroke();
          targetBuffer.fill(255,0,0);
          targetBuffer.ellipse(x,y,3,3);
          targetBuffer.popStyle();
        }
        */
      }
      //else                      point(x,y);
      
      //targetBuffer.resetShader();
      
      isDrawn = true;
    }
    
  }

}
