import java.awt.Point;
import java.awt.geom.Point2D;

import javax.media.jai.PerspectiveTransform; // http://download.java.net/media/jai/javadoc/1.1.3/jai-apidocs/javax/media/jai/PerspectiveTransform.html
import javax.media.jai.WarpPerspective; // http://download.java.net/media/jai/javadoc/1.1.3/jai-apidocs/javax/media/jai/WarpPerspective.html


PVector[] corners;

// Corners enum 
final int TL = 0; // top left
final int TR = 1; // top right
final int BL = 2; // bottom left
final int BR = 3; // bottom right

WarpPerspective warpPerspective;
PerspectiveTransform transform;

void setup() {
  size(800,600,P2D);
  
  corners = new PVector[4];
  

  // Hardcoded values for testing (0 to width, 0 to height)
  corners[0] = new PVector( random(width/4) , random(height/4) );
  corners[1] = new PVector( width - random(width/4), random(height/4) );
  corners[2] = new PVector( width - random(width/4), height - random(height/4) );
  corners[3] = new PVector( random(width/4), height - random(height/4) );


  /*
  // Hardcoded values for testing (from 0.0 to 1.0)
  corners[0] = new PVector( 0.21, 0.38 );
  corners[1] = new PVector( 0.86, 0.12 );
  corners[2] = new PVector( 0.91, 0.95 );
  corners[3] = new PVector( 0.07, 0.82 );
  */


}

void draw() {
  
  background(0);
  
  // Source quad (warped tracker image)
  
  pushStyle();
  noFill();  
  stroke(200,0,0);
  strokeWeight(10);
  beginShape();
  for( int i = 0; i < corners.length; i++) {
    vertex( corners[i].x , corners[i].y );
  }
  endShape(CLOSE);
  popStyle();
  
  
  pushStyle();
  noStroke();
  fill(200,0,0);
  ellipse(mouseX, mouseY, 10, 10);
  popStyle();
  
  // Setup the transformation based on the current position of the corners
  transform = makeQuadToView(corners);
  
  // Get the warped coordinates
  PVector warpPos = warp(transform, float(mouseX), float(mouseY));
  
  // Target quad (screen)
  
  pushStyle();
  noFill();
  stroke(0,200,0);
  strokeWeight(10);
  rect(0,0,width,height);
  popStyle();
  
  pushStyle();
  noStroke();
  fill(0,200,0);
  ellipse(warpPos.x, warpPos.y,10,10);
  popStyle();
  
  
  println("");
  println("mouseX = " + mouseX + " | mouseY = " + mouseY);
  println("warpPos.x = " + warpPos.x + " | warpPos.y = " + warpPos.y);
  println("");
  
  
}


PerspectiveTransform makeQuadToSquare(PVector[] quadCorners) {
  // Creates a PerspectiveTransform that maps an arbitrary quadrilateral onto the unit square.
  PerspectiveTransform transform = PerspectiveTransform.getQuadToSquare (
      quadCorners[TL].x, quadCorners[TL].y, 
      quadCorners[TR].x, quadCorners[TR].y, 
      quadCorners[BR].x, quadCorners[BR].y, 
      quadCorners[BL].x, quadCorners[BL].y
  );
  
  return transform;
}

PerspectiveTransform makeQuadToView(PVector[] quadCorners) {
  // Creates a PerspectiveTransform that maps an arbitrary quadrilateral onto the unit square.
  PerspectiveTransform transform = PerspectiveTransform.getQuadToQuad (
  
      quadCorners[TL].x, quadCorners[TL].y, 
      quadCorners[TR].x, quadCorners[TR].y, 
      quadCorners[BR].x, quadCorners[BR].y, 
      quadCorners[BL].x, quadCorners[BL].y, // from source
      
      0, 0,
      width, 0,
      width, height,
      0, height // to destination (here, the viewport)
  );
  
  return transform;  
  
}


PVector warp(PerspectiveTransform transform, float x, float y) {
  
  // A description of a perspective (projective) warp.
  WarpPerspective warpPerspective = new WarpPerspective(transform);

  // Computes the source point corresponding to the supplied point.
  Point2D point = warpPerspective.mapDestPoint(new Point((int) x, (int) y));
   
  float destX = (float) point.getX();
  float destY = 1.0 - (float) point.getY();
  
  PVector destCoord = new PVector( destX, destY );
  
  return destCoord;
  
}


