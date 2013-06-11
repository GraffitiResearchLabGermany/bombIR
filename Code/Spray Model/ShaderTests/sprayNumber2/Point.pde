class Point extends PVector {
  
  float size;
  float angle;      
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay
  
  Point(float x, float y, float s, float a, float n, float t) {
    super(x, y);
    size = s;
    angle = a;
    noiseDepth = n;
    timestamp = t;
  }
  
}
