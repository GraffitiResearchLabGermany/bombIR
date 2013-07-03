
//-----------------------------------------------------------------------------------------
// BLOB DETECTION

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {	
  Blob b;
  EdgeVertex eA,eB;
  for (int n = 0 ; n < bd.getBlobNb() ; n++) {
    b = bd.getBlob(n);
    //println("There Are " + bd.getBlobNb() + " Blobs Detected...");

      if (b!= null) {
        // Edges
        if (drawEdges) {
          pg.noFill();
          pg.strokeWeight(2);
          pg.stroke(0, 0, 255);
          pg.beginShape();
            for (int m = 0; m < b.getEdgeNb(); m++) {
              eA = b.getEdgeVertexA(m);
              eB = b.getEdgeVertexB(m);
                if (eA != null && eB != null) {
                  //pg.vertex(eA.x * FirstScreenWidth, eA.y * FirstScreenHeight);
                }
            }
          pg.endShape(CLOSE);    
        }     
        
        // Blobs
        if (drawBlobs) {
          pg.strokeWeight(1);
          pg.noFill();
          pg.stroke(255,0,0);
          pg.rectMode(CORNER);

          // If Blobs Are Within Crop Area
          if(b.xMin * FirstScreenWidth > LeftBorder && b.xMin * FirstScreenWidth < RightBorder && b.yMin * FirstScreenHeight > TopBorder && b.yMin * FirstScreenHeight< BottomBorder) {
            // If The Blob Is Over A Certain Size
            if(b.w > blobMin && b.w < blobMax) {
              //pg.rect(b.xMin * FirstScreenWidth, b.yMin * FirstScreenHeight, b.w * FirstScreenWidth, b.h * FirstScreenHeight);
            
              // Find Center of Blob and Add It To Total
              float w = RightBorder - LeftBorder;
              float h = BottomBorder - TopBorder;
              
              float bx = b.xMin * w;
              float by = b.yMin * h; 
              
              sumBlobsX += b.xMin + (b.w / 2);
              sumBlobsY += b.yMin + (b.h / 2);
              //sumBlobsX += bx + (b.w / 2);
              //sumBlobsY += by + (b.h / 2);
              blobCount ++;
              
              //blobX = (1.0 - (sumBlobsX / blobCount)) * FirstScreenWidth;
              //blobX = (sumBlobsX / blobCount) * FirstScreenWidth;
              //blobY = (sumBlobsY / blobCount) * FirstScreenHeight;
           
              //println("\t X is " + blobX + "\t Y is " + blobY + "\t based off of a Count of " + blobCount);
             
              // Set XY to largest blob XY
              int s = 0;
              if(b.w > s) {
                s = n;
              }
              blobX = ( (1.0 - bd.getBlob(s).xMin) * FirstScreenWidth);
              //blobY = (bd.getBlob(s).yMin * height);
              blobY = (bd.getBlob(s).yMin * FirstScreenHeight);
              
              blobIO = 1;
            }
            else {
              blobIO = 0; 
            }
          }
          else {
             if(bd.getBlobNb() == 0){
               println("There Are " + bd.getBlobNb() + " Blobs Detected...");
               blobIO = 0;
             } 
          }      
        }
      }
      
    
      
  }

} 

// -------------------------------- //

