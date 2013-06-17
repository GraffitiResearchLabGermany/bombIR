
//-----------------------------------------------------------------------------------------
// KEY

void keyPressed() {
  // If In Calibration
  if(calibrate == true) {

    // Crop Left
    if(adjustBox == 1) {
      if(keyCode == LEFT) {
        LeftBorder -= 1;
        if(LeftBorder <= 0) LeftBorder = 0;
      }
      if(keyCode == RIGHT) {
        LeftBorder += 1;
        if(LeftBorder >= FirstScreenWidth) LeftBorder = FirstScreenWidth;
      }
    }
    
    // Crop Right
    if(adjustBox == 2) {
      if(keyCode == LEFT) {
        RightBorder -= 1;
        if(RightBorder <= 0) RightBorder = 0;
      }
      if(keyCode == RIGHT) {
        RightBorder += 1;
        if(RightBorder >= FirstScreenWidth) RightBorder = FirstScreenWidth;
      }
    }  
    
    // Crop Top
    if(adjustBox == 3) {
      if(keyCode == UP) {
        TopBorder -= 1;
        if(TopBorder <= 0) TopBorder = 0;
      }
      if(keyCode == DOWN) {
        TopBorder += 1;
        if(TopBorder >= FirstScreenHeight) TopBorder = FirstScreenHeight;
      }
    }  
    
    // Crop Bottom
    if(adjustBox == 4) {
      if(keyCode == UP) {
        BottomBorder -= 1;
        if(BottomBorder <= 0) BottomBorder = 0;
      }
      if(keyCode == DOWN) {
        BottomBorder += 1;
        if(BottomBorder >= FirstScreenHeight) BottomBorder = FirstScreenHeight;
      }
    }  
    
  }
  else {
    if(key == 'c') {
      eraseAll();
    } 
    if(key == '1') {
      DrawMode = 1;
    } 
    if(key == '2') {
      DrawMode = 2;
    } 
  }
  
}


//-----------------------------------------------------------------------------------------k
