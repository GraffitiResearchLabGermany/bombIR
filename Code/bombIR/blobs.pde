/**
 * BLOB DETECTION
 */

/**
 * x coordinate of the blob
 */ 
float blobX; 

/**
 * y coordinate of the blob
 */
float blobY;

/**
 * size of the blob
 */
float blobSize;

// OPTIMIZE: implement a Tracker class to abstract the blob code

void drawBlobsAndEdges(boolean drawEdges, boolean drawRects) {  
  Blob b;
  EdgeVertex eA, eB;

  // Register the current crop area
  float top    = TopBorder;
  float bottom = BottomBorder;
  float right  = RightBorder;
  float left   = LeftBorder;

  // Register the size limits
  float minSize = blobMin;
  float maxSize = blobMax;


  for (int n = 0 ; n < ct.getBlobDetection().getBlobNb() ; n++) {
    b = ct.getBlobDetection().getBlob(n);

    logger.fine("There Are " + ct.getBlobDetection().getBlobNb() + " Blobs Detected...");
    if (b!= null) {

      // Is the blob valid?
      boolean isValidBlob = true;
      if ( isInside( b, left, right, top, bottom ) == false ) { 
        isValidBlob = false;
      }
      else if ( isRightSize( b, minSize, maxSize) == false ) {
        isValidBlob = false;
      }

      if (isValidBlob) {
        // Edges
        if (drawEdges) {               
          noFill();
          strokeWeight(2);
          stroke(0, 0, 255);
          beginShape();
          for (int m = 0; m < b.getEdgeNb(); m++) {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            if (eA != null && eB != null) {
              vertex(eA.x * captureWidth, eA.y * captureHeight - captureOffsetY); // keep the 4:3 ratio and positionning of the capture image
            }
          }
          endShape(CLOSE); 

          // Return Valid Blobs
          //blobX = (b.xMin * firstWindowWidth);

          //blobX = map(blobX, 0, firstWindowWidth, LeftBorder, RightBorder - LeftBorder);

          //float mult = firstWindowWidth / ct.getWidth(); // vertical stretch
          //blobY = (b.yMin * windowHeight * mult );

          //blobY = map(blobY, 0, windowHeight, TopBorder, BottomBorder - TopBorder);

          //println("BX: " + blobX + "  BY: " + blobY);
        }

        if (drawRects) {
          strokeWeight(1);
          noFill();
          stroke(255, 0, 0);
          rectMode(CORNER);
          rect(b.xMin * firstWindowWidth, b.yMin * windowHeight, b.w * firstWindowWidth, b.h * windowHeight);
        }
      }
    } // null
  } // for
}

/**
 * Set the mapped x/y coordinates to blobX and blobY
 *
 */
void updateCurrentBlob() {
  
  // Register the current crop area
  float top    = TopBorder;
  float bottom = BottomBorder;
  float right  = RightBorder;
  float left   = LeftBorder;

  // Register the size limits
  float minSize = blobMin;
  float maxSize = blobMax;
  
  int blobNb = ct.getBlobDetection().getBlobNb();
  
  //we have at least one blob  
  if (blobNb >= 1) {
  
  boolean blobFound = false;
  
    // Get the first valid blob in the list
    for (int n = 0 ; n < blobNb ; n++) {
      
      // When a valid blob has been found we stop 
      // searching for other blob candidates
      if( blobFound == true ) break;
      
      Blob b = ct.getBlobDetection().getBlob(n);
      
      // Is the blob valid?
      boolean isValidBlob = true;
      if ( isInside( b, left, right, top, bottom ) == false ) { 
        isValidBlob = false;
      }
      else if ( isRightSize( b, minSize, maxSize) == false ) {
        isValidBlob = false;
      }
  
      if( isValidBlob ) {
        blobFound = true;
          
        float xBlobUnit = b.x;
        float yBlobUnit = b.y;
    
        // Flip the X axis (when not using the rear projection screen)
        if ( mirrorX == true ) xBlobUnit = 1.0 - xBlobUnit;
    
        // 16:9 Y axis correction
        if ( ratio == 1) {
          yBlobUnit = ( yBlobUnit * 1.33333 ) - 0.166666;
        }
    
        // Map the blob coordinates from unit square to the cropping area
        blobX = map( xBlobUnit, 0.0, 1.0, RightBorder - LeftBorder, LeftBorder);
        blobY = map( yBlobUnit, 0.0, 1.0, TopBorder, BottomBorder - TopBorder);
    
        // Adjust tracking
        blobX = blobX - trackingOffsetX;
        blobY = blobY - trackingOffsetY;
    
        // Let's just average the two dimensions of the blob (we just need an order of magnitude).
        blobSize = ( b.w + b.h ) / 2.0;
    
      } // isValidBlob
    } // for
  } 
  else {
    logger.fine("No Blobs detected");
  }
}

// Test if the given blob is within the specified boundaries
boolean isInside( Blob blob, float left, float right, float top, float bottom ) {

  if ( blob.x * firstWindowWidth < left   ) return false; 
  if ( blob.x * firstWindowWidth > right  ) return false;
  if ( blob.y * windowHeight     < top    ) return false; 
  if ( blob.y * windowHeight     > bottom ) return false; 

  return true;
}

// Test if the given blob is within specified size limitations
boolean isRightSize( Blob blob, float min, float max ) {

  if (blob.w < min) return false;  
  if (blob.w > max) return false;

  return true;
}


// -------------------------------- //

