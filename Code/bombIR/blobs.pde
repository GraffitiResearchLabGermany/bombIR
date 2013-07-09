
//-----------------------------------------------------------------------------------------
// BLOB DETECTION

float blobMin = 0.025;      
float blobMax = 0.15;
float blobThresh = 0.5;
float blobX, blobY;
float blobSize;

void drawBlobsAndEdges(boolean drawEdges, boolean drawRects) {  
  Blob b;
  EdgeVertex eA,eB;


  for (int n = 0 ; n < ct.getBlobDetection().getBlobNb() ; n++) {
    b = ct.getBlobDetection().getBlob(n);
    println("There Are " + ct.getBlobDetection().getBlobNb() + " Blobs Detected...");
    if (b!= null) {
        
      // Edges
      if (drawEdges) {
         // If Blobs Are Within Crop Area
        if(b.xMin * firstWindowWidth > LeftBorder && b.xMin * firstWindowWidth < RightBorder && b.yMin * windowHeight > TopBorder && b.yMin * windowHeight < BottomBorder) {    
          // If The Blob Is Over A Certain Size
          if(b.w > blobMin && b.w < blobMax) {
            
            noFill();
            strokeWeight(2);
            stroke(0, 0, 255);
            beginShape();
              for (int m = 0; m < b.getEdgeNb(); m++) {
                eA = b.getEdgeVertexA(m);
                eB = b.getEdgeVertexB(m);
                  if (eA != null && eB != null) {
                    vertex(eA.x * firstWindowWidth, eA.y * windowHeight);
                  }
              }
            endShape(CLOSE); 
            
            // Return Valid Blobs
            blobX = (b.xMin * firstWindowWidth);
            //blobX = map(blobX, 0, firstWindowWidth, LeftBorder, RightBorder - LeftBorder);
            blobY = (b.yMin * windowHeight);
            //blobY = map(blobY, 0, windowHeight, TopBorder, BottomBorder - TopBorder);

            //println("BX: " + blobX + "  BY: " + blobY); 
            
          }
        }   
      }     
      
      // Blobs
      if (drawRects) {
        strokeWeight(1);
        noFill();
        stroke(255,0,0);
        rectMode(CORNER);
        // If Blobs Are Within Crop Area
        if(b.xMin * firstWindowWidth > LeftBorder && b.xMin * firstWindowWidth < RightBorder && b.yMin * windowHeight > TopBorder && b.yMin * windowHeight < BottomBorder) {
          // If The Blob Is Over A Certain Size
          if(b.w > blobMin && b.w < blobMax) {
            rect(b.xMin * firstWindowWidth, b.yMin * windowHeight, b.w * firstWindowWidth, b.h * windowHeight);
          }
        }    
      }
        
    } // null
  } // for
} 

//set the mapped x/y coordinates to blobX and blobY
void updateCurrentBlob() {
  //we have at least one blob  
  if(ct.getBlobDetection().getBlobNb() >= 1){

      blobX = map(ct.getBlobDetection().getBlob(0).xMin, 0.0, 1.0, RightBorder - LeftBorder, LeftBorder);
      blobY = map(ct.getBlobDetection().getBlob(0).yMin, 0.0, 1.0, TopBorder, BottomBorder - TopBorder);
      
      // Let's just average the two dimensions of the blob (we just need an order of magnitude).
      blobSize = ( ct.getBlobDetection().getBlob(0).w + ct.getBlobDetection().getBlob(0).h ) / 2.0;
      System.out.println( "blobSize = "+ blobSize );

      
      //println("blobX:" + blobX);
      //println("blobY:" + blobY);
      
  //we dont have a blob  
  } else {
      //println("No Blobs detected");
  }
}

// -------------------------------- //
