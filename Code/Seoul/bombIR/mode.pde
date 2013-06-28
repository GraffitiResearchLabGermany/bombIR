
//-----------------------------------------------------------------------------------------
// MODES

// Mouse
void drawModeOne() {
  drawX = mouseX;
  drawY = mouseY;
}

// Camera Tracking
void drawModeTwo() {

  // Show Camera Image
  if (cam.available() == true) {
    cam.read();
  }
  //pg.image(cam, 0, 0, FirstScreenWidth, FirstScreenHeight);
 
  // Blob Detection 
  //pg.background(0); 
  bd.computeBlobs(cam.pixels);
  drawBlobsAndEdges(true, true);

  //println(blobX + "\t" + blobY);
  // Draw
  drawX = blobX;
  drawY = blobY + menuHeight; 
  //pg.text(drawX + " \t " + drawY, 50, 50);
  
  //pg.text("BLOB ? " + blobIO, 50, 100);
  
  // Touched
  if(blobIO == 1 && prevBlobFrame == 0) {
   // pg.text("ON", 50, 150);
    strokeOn();
  }
  
  if(blobIO == 1 && prevBlobFrame == 1) {
    //pg.text("--", 50, 150);
    strokeOnAndOn(); 
  }
  
  // Released
  if(blobIO == 0 && prevBlobFrame == 1) {
    //pg.text("OFF", 50, 150);
    strokeOff();
  }  

  // Update Frame
  prevBlobFrame = blobIO;

}

// Remote OSC
void drawModeThree() {
  

}

// GML Data
void drawModeFour() {

  
}

//-----------------------------------------------------------------------------------------

