 
//-----------------------------------------------------------------------------------------
// DRAW

void draw() {
  
  if(calibrate == true) {
    runCalibration();
    cp5.draw();
    //rb.draw();
    //println("CALIBRATING...");
  }
  if(calibrate == false) { 
    // Hide GUI
    cp5.hide();
    //rb.hide(); 
    
    // Buffer
    pg.beginDraw();
      pg.smooth();
      
      // Call Brushes If Drawing
      if(clicked == true) {
        //style();
      }
      
      // GUI
      if(mouseY > height - menuHeight) {
        gui();
        cursor();
        showCursor = true;
      }
      else if(mouseY < height - menuHeight) {
        background(0);
        noCursor();
        showCursor = false;
      }
      
      // Draw Mode
      if(DrawMode == 1) {
        // Mouse Control
        drawModeOne();
      }
      else if(DrawMode == 2) {
        // Camera Control
        drawModeTwo();    
      }
      else if(DrawMode == 3) {
        // Remote Control
        drawModeThree();
      }
      else if(DrawMode == 4) {
        // Data Control
        drawModeFour();    
      }
    
      // Draw Drips
      if(dripsIO == true) {
        for(int i = 0; i < numDrips; i++) {
          drips[i].drip();
          drips[i].show();
          drips[i].stopping();
        }
      }
      
    pg.endDraw();
    
    // Buffer Image
    image(pg, 0, 0);

    // FPS
    if(frameCount % 120 == 0) {
      int fps = round(frameRate); 
      //println("FPS " + fps);
    }
  
  }
} // end DRAW
  
//-----------------------------------------------------------------------------------------

