
// The Stroke object contains a list of points

class Stroke {
  
  ArrayList<Point> pointList;       // raw point list
  ArrayList<Point> pointsExtrap;  // extrapolated point list along a curve
  
  float distMax;

  Stroke() {
    initialize();
  }
  
  Stroke(float d) {
    distMax = d;
    initialize();
  }

  Stroke(ArrayList<Point> p) {
    pointList = p;
    initialize();
  }

  Stroke(ArrayList<Point> p, float d) {
    pointList   = p;
    distMax = d;
    initialize();
  }
  
  void initialize() {
    if(null == pointList   ) pointList    = new ArrayList<Point>();
    if(null == pointsExtrap) pointsExtrap = new ArrayList<Point>();
  }
  
  void update(Point p) {
    pointList.add(p);
    extrapolate();
  }
  
  // Fill in the gaps in the stroke, based
  // on a maximum distance between points
  void extrapolate() {
    // draw a curve based on the last 4 points
    // get points on the curve
    // update pointsExtrap
  }
  
  
}
