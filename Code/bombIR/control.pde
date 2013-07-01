
//-----------------------------------------------------------------------------------------
// MENU + GUI CONTROL

int saveCount = 0;

 void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    paintscreen.beginDraw();
    paintscreen.clear();
    paintscreen.endDraw();
    
    wallscreen.beginDraw();
    wallscreen.clear();
    wallscreen.endDraw();
  }
 }

 // SAVE
 void SAVE(boolean theFlag) {
  if(theFlag == true) {
     saveCount ++;
     // save image w/o gui
     wallscreen.save("exports/Save_" + saveCount + ".jpg");
  }
 } 

 //adjust brush size
 void WIDTH(int BrushSize) {
    weight = (BrushSize);
 } 
 
 // Crop Scale
 int lastCS = 0;
 void cropScale(int cs) {
   if(cs > lastCS) {
     corner.tlX += cs;
     corner.tlY += cs;
     corner.trX -= cs;
     corner.trY += cs;
     corner.brX -= cs;
     corner.brY -= cs;
     corner.blX += cs;
     corner.blY -= cs;
   }
   lastCS = cs;
 }
 
 // Save Calibration
 void saveCalib() {
   background(0);
   calibrateCamera = false; 
   paintbg.render(paintbackground);
   calibMenu.hide();
 }
 
 void keyPressed() {
    switch(key) {
      case 'c':
       // enter/leave calibration mode, where surfaces can be warped 
       // and moved
       ks.toggleCalibration();
       calibrateKeystone = !calibrateKeystone;       
       //redraw background once after calibration
       background(0);
       paintbg.render(paintbackground);
       break;
      case 'm':     
       toggleMenu();
       paintbg.render(paintbackground);
       break;
      }
 
   }
   
 //show or hide the menu
 void toggleMenu(){
   if(menu.isVisible()){
        menu.hide();
        background(0);
      }else{
        menu.show();
      }
 }
