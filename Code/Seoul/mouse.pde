
//-----------------------------------------------------------------------------------------
// MOUSE

void mousePressed() {
  // Set UI Safe Zone
  if(mouseY < height - menuHeight && calibrate == false && DrawMode == 1) {  
    strokeOn();
  }
}

void mouseDragged () {
  // Set UI Safe Zone
  if(mouseY < height - menuHeight && calibrate == false && DrawMode == 1) {  
    strokeOnAndOn();
  }
}

void mouseReleased() {
  // Set UI Safe Zone
  if(mouseY < height - menuHeight && calibrate == false && DrawMode == 1) {  
    strokeOff();
  }
}

//-----------------------------------------------------------------------------------------
