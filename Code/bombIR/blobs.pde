
//-----------------------------------------------------------------------------------------
// BLOB DETECTION

float blobMin = 0.025;      
float blobMax = 0.15;
float blobThresh = 0.5;

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {  
  Blob b;
  EdgeVertex eA,eB;
  for (int n = 0 ; n < bd.getBlobNb() ; n++) {
    b = bd.getBlob(n);
    //println("There Are " + bd.getBlobNb() + " Blobs Detected...");
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
          }
        }   
      }     
      
      // Blobs
      if (drawBlobs) {
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

// -------------------------------- //

