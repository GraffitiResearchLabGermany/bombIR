/**
 * MENU + GUI CONTROL
 */

/**
 * TODO: Document this declaration
 */
int saveCount = 0;

/**
 * Clears the screens if theFlag is true
 * 
 * @param theFlag true if the screen should be cleared
 */
 void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    
    paintscreen.beginDraw();
    paintscreen.clear();
    paintscreen.image(paintbackground,0,0);
    paintscreen.endDraw();
    
    wallscreen.beginDraw();
    wallscreen.clear();
    wallscreen.endDraw();
  }
 }

/**
 * Saves an image of the wallscreen
 * Images are stored in the 'exports' folder. 
 *
 * @param theFlag true if the wallscreen image should be saved
 */
 void SAVE(boolean theFlag) {
  if(theFlag == true) {
     saveCount ++;
     // save image w/o gui
     wallscreen.save(
        "exports/" 
        + year() + "_ " 
        + month() + "_" 
        + day() + "_" 
        + hour() + "_" 
        + minute() + "_"
        + "screenshot.jpg");
  }
 } 

/**
 * Adjust brush size
 * 
 * @param brushSize the size of the brush to paint width
 */
 void WIDTH(int brushSize) {
    sprayManagerLeft.setWeight(brushSize);
    sprayManagerRight.setWeight(brushSize);
 } 
 
 
/**
 * Set the position of the cropping area corners
 * 
 * @param cs scale of the cropping area
 */
 void cropScale(float cs) {      
     // defined in settings.properties
     float w = firstWindowWidth; 
     // defined in settings.properties
     float h = windowHeight;
     corner.tlX = int( w / 2.0 * cs );
     corner.tlY = int( h / 2.0 * cs );
     corner.trX = int( w - ( w  / 2.0 * cs ) );
     corner.trY = int( h / 2.0 * cs );
     corner.brX = int( w - ( w  / 2.0 * cs ) );
     corner.brY = int( h - ( h  / 2.0 * cs ) );
     corner.blX = int( w / 2.0 * cs );
     corner.blY = int( h - ( h  / 2.0 * cs ) );
 }

/**
 * Show Blob
 */
 void showBlob() {
   if(calibrateCamera) {
     showBlob =! showBlob;
   }
   if(!calibrateCamera) {
     showBlob =! showBlob;
     background(0);
     drawPaintBg();
   }   
 }
 
 /**
  * Show Cam
  */
 void showCam() {
   if(calibrateCamera) {
     showCam =! showCam;
   }
   if(!calibrateCamera) {
     showCam =! showCam;
     background(0);
     drawPaintBg();
   }   
 }
 
 /** 
  * Save Calibration
  */
 void saveCalib() {
   if(calibrateCamera) {
     background(0);
     calibrateCamera = false; 
     showCam = false;
     showBlob = false;
     drawPaintBg();
     calibMenu.hide();
     //noCursor();
   }
 }
 

 /**
  * Method will be called when a key is pressed and fire 
  * an action if the key pressed matches 
  */
 void keyPressed() {
   
   // Quit BombIR gracefully
   if (key == 'q' || key == 'Q') 
     quit();
   
   //toggle MouseRobot
   else if (key == 's' || key == 'S') 
     suspendMouseRobot = !suspendMouseRobot;

   // Clear screen
   else if (key == 'r' || key == 'R') {
       // clear the paint screen (left)
       sprayManagerLeft.reset(paintscreen, bg); 
       // clear the wall screen (right)
       sprayManagerRight.reset(wallscreen, color(0));
   }
   
   // Show color spray menu
   else if (key == 'm' || key == 'M') {
     if(!calibrateCamera) {   
       toggleMenu();
       drawPaintBg();
     }
   }

   // Show calibration menu
   else if (key == 'b' || key == 'B') {
       toggleBlobControl();
       if(calibrateCamera) {   
         background(0);
       }
       else {
         drawPaintBg();
       }
    }
   
   // Adjust the position of the cursor 
   if (key == CODED) {
     if (keyCode == LEFT) {
       trackingOffsetX += 2;
     }
     else if(keyCode == RIGHT) {
       trackingOffsetX -= 2;
     }
     else if(keyCode == UP) {
       trackingOffsetY += 2;
     }
     else if(keyCode == DOWN) {
       trackingOffsetY -= 2;
     }
   }
   
 }
   
 /**
 * Show or hide the menu
 */
 void toggleMenu() {
   if(menu.isVisible()){
     //noCursor();
     menu.hide();
     background(0);
   }
   else {
     menu.show();
     cursor(CROSS);
   }
 }
 
 /**
  * Show or hide blob control
  */
 void toggleBlobControl(){
   if(calibMenu.isVisible()){
     capturePreview.hide();
     calibMenu.hide();
     background(0);
     //noCursor();
   }
   else {
     capturePreview.show();
     calibMenu.show();

     cursor(CROSS);
   }
 }
