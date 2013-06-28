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
 
 
 
 void keyPressed() {
    switch(key) {
      case 'c':
       // enter/leave calibration mode, where surfaces can be warped 
       // and moved
       ks.toggleCalibration();
       calib = !calib;       
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