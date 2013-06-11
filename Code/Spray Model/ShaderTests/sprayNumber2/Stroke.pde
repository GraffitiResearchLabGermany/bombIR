
// The Stroke object contains a list of points

class Stroke {
  
  ArrayList<Point> curve;       // raw point list
  ArrayList<Point> curveExtrap; // extrapolated point list
  ArrayList<Point> curveSmooth; // smoothed point list
  
  float distMax;

  Stroke() {
    initialize();
  }
  
  Stroke(float d) {
    distMax = d;
    initialize();
  }

  Stroke(ArrayList<Point> p) {
    curve = p;
    initialize();
  }

  Stroke(ArrayList<Point> p, float d) {
    curve   = p;
    distMax = d;
    initialize();
  }
  
  void initialize() {
    if(null == curve      ) curve       = new ArrayList<Point>();
    if(null == curveExtrap) curveExtrap = new ArrayList<Point>();
    if(null == curveSmooth) curveSmooth = new ArrayList<Point>();
  }
  
  void update(PVector p) {
    
  }
  
  // Remove jitter
  void smooth(int level) {
  }
  
  // Fill in the gaps in the stroke, based
  // on a maximum distance between points
  void extrapolate() {
    // draw a curve based on the last 4 points
    // get points on the curve
    // update curveExtrap
  }
  
  
}
