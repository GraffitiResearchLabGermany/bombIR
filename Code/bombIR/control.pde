
int saveCount = 0;


 void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    //TODO: Spraypaint doesn't get cleared yet
    paintscreen.background(0);
    wallscreen.background(0);
    drawBackgroundImage();
    drawColorPicker();
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
                    //redraw background once after calibration
                    background(0);
                    drawBackgroundImage();
                    break;

      case 'l':
        // loads the saved layout
        ks.load();
        break;

    case 's':
              // saves the layout
        ks.save();
        break;

                case 'm':
                   //show or hide the menu
                   if(menu.isVisible()){
                     menu.hide();
                     background(0);
                     drawBackgroundImage();
                   }else{
                     menu.show();
                     //paint the colorpicker
                     drawColorPicker();
                   }
                   break;
         }
 
   }
