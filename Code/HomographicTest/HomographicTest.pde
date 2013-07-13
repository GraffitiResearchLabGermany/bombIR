
// Algorithm from http://forum.openframeworks.cc/index.php?&topic=509.0
// Based on Myler and Weeks (1993)

PVector[] corners;

WarpManager warper;

void setup() {
  size(800,600,P2D);
  
  warper = new WarpManager();
  
  corners = new PVector[4];
  
  /*
  // Hardcoded values for testing (from 0.0 to 1.0)
  corners[0] = new PVector( random(width/4) / width, random(height/4) /height );
  corners[1] = new PVector( width - random(width/4)/ width, random(height/4) /height );
  corners[2] = new PVector( width - random(width/4)/ width, height - random(height/4) /height );
  corners[3] = new PVector( random(width/4)/ width, height - random(height/4) /height );
  */


  // Hardcoded values for testing (from 0.0 to 1.0)
  corners[0] = new PVector( 0.21, 0.38 );
  corners[1] = new PVector( 0.86, 0.12 );
  corners[2] = new PVector( 0.91, 0.95 );
  corners[3] = new PVector( 0.07, 0.82 );


}

void draw() {
  
  background(0);
  
  // Source quad
  
  pushStyle();
  noFill();
  stroke(200,0,0);
  strokeWeight(10);
  rect(0,0,width,height);
  popStyle();
  
  pushStyle();
  noStroke();
  fill(200,0,0);
  ellipse(mouseX,mouseY,10,10);
  popStyle();
  
  
  // Target quad (warped)
  
  pushStyle();
  noFill();  
  stroke(0,200,0);
  strokeWeight(10);
  beginShape();
  for( int i = 0; i < corners.length; i++) {
    vertex( corners[i].x * width, corners[i].y * height );
  }
  endShape(CLOSE);
  popStyle();
  
  // Pass the distorted quad corners
  warper.setCorners(corners);
  
  // Get the warped coordinates
  PVector wPos = warper.warp(float(mouseX)/width, float(mouseY)/height);
  
  println("");
  println("mouseX = " + mouseX + " | mouseY = " + mouseY);
  println("wPos.x = " + wPos.x + " | wPos.y = " + wPos.y);
  println("");
  
  pushStyle();
  noStroke();
  fill(0,200,0);
  ellipse(wPos.x * width, wPos.y * height, 10, 10);
  popStyle();
  
  
}

class WarpManager {
  
  // This is the startx and endx of the source 
  // quad's top left corner and bottom right corner
  float sx = 0.0;
  float sy = 0.0;
  float ex = 1.0;
  float ey = 1.0;
  
  float a,b,c,d;
  float e,f,i,j;
  
  WarpManager() {
    // do stuff?
  }
  
  
  void setCorners(PVector[] corners) {
    // this is an array of four points
    // that describe the four corners
    // of the warped quad - 
    // they are ordered like: 
    //
    //  pt0      pt1
    //
    //  pt3      pt2
    
    float[] wx = new float[4];
    float[] wy = new float[4];
    

    
    //corners are in 0.0 - 1.0 range
    for(int i = 0; i < 4; i++){
      wx[i] = corners[i].x ;
      wy[i] = corners[i].y ;
    }

  
    //this is code from Myler and Weeks: 
    //calculates the warp coeffecients that describe 
    //the transformations between the src and dst quad
    
    a = (-wx[0] + wx[1]) / (ey-sy); //a
    b = (-wx[0] + wx[3]) / (ex-sx); //b
    c = (wx[0] - wx[1] + wx[2] - wx[3]) / ( (ey-sy)  * (ex-sx) ); //c
    d =  wx[0]; //d
    
    e = (-wy[0] + wy[1]) / (ex-sx); //e
    f = (-wy[0] + wy[3]) / (ey-sy); //f
    i =  (wy[0] - wy[1] + wy[2] - wy[3]) / ( (ey-sy)  * (ex-sx) ); //i
    j = wy[0]; //j
  }
  
  
  // Argument: sourceCoord (the original coordinates)
  // Returns: targetCoord (the wrapped coordinates)
  PVector warp(float sourceX, float sourceY) {
    
    float x = sourceX;
    float y = sourceY;
    
    // calculate the wrapped coordinates
    float X = a*x + b*y +c*x*y + d;
    float Y = e*x + f*y + i*x*y + j;
    
    println("float X = a*x + b*y +c*x*y + d;");
    println(X+" = " + a +"*"+x+" + "+ b+"*"+y+"+"+c+"*"+x+"*"+y+" + "+d+";");
    
    println("Y = e*x + f*y + i*x*y + j;");
    println(Y+" = " + e +"*"+x+" + "+ f+"*"+y+"+"+i+"*"+x+"*"+y+" + "+d+";");

    PVector targetCoord = new PVector(X,Y);
    
    return targetCoord;
  }
}


