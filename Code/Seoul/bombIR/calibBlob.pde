
//-----------------------------------------------------------------------------------------
// BLOB DETECTION

void CalibdrawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {	
  Blob b;
  EdgeVertex eA,eB;
  for (int n = 0 ; n < bd.getBlobNb() ; n++) {
    b = bd.getBlob(n);
    //println("There Are " + bd.getBlobNb() + " Blobs Detected...");

      if (b!= null) {
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
                  vertex(eA.x * FirstScreenWidth, eA.y * FirstScreenHeight);
                }
            }
          endShape(CLOSE);    
        }     
        
        // Blobs
        if (drawBlobs) {
          strokeWeight(1);
          noFill();
          stroke(255,0,0);
          rectMode(CORNER);

          // If Blobs Are Within Crop Area
          if(b.xMin * FirstScreenWidth > LeftBorder && b.xMin * FirstScreenWidth < RightBorder && b.yMin * FirstScreenHeight > TopBorder && b.yMin * FirstScreenHeight < BottomBorder) {
            
            // If The Blob Is Over A Certain Size
            if(b.w > blobMin && b.w < blobMax) {
              rect(b.xMin * FirstScreenWidth, b.yMin * FirstScreenHeight, b.w * FirstScreenWidth, b.h * FirstScreenHeight);
            
              // Find Center of Blob and Add It To Total
              float w = RightBorder - LeftBorder;
              float h = BottomBorder - TopBorder;
              
              float bx = b.xMin * w;
              float by = b.yMin * h; 
              
              
              sumBlobsX += bx + (b.w / 2);
              sumBlobsY += by + (b.h / 2);
              blobCount ++;
              
              println("\t X is " + blobX + "\t Y is " + blobY + "\t based off of a Count of " + blobCount);
             
              // Set XY to largest blob XY
              //blobX = ( (1.0 - bd.getBlob(s).xMin) * FirstScreenWidth);
              //blobY = (bd.getBlob(s).yMin * height);
              //blobY = (bd.getBlob(s).yMin * FirstScreenHeight);
              
              blobIO = 1;
            }
          }
          else {

          }      
        }
      }
  }
  if(bd.getBlobNb() == 0){
    //println("There Are " + bd.getBlobNb() + " Blobs Detected...");
    blobIO = 0;
  } 
} 

// -------------------------------- //

