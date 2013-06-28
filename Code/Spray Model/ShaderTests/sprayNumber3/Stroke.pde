
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
        Knot k = new Knot(stepper.x, stepper.y);
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
