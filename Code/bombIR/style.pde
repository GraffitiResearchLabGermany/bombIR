  //-----------------------------------------------------------------------------------------
  
  void style() {
    
    if(drawY < height - menuHeight) {
      // Call Current Brush
      brushModes();
      
      // If Slow, Add Drip
      if(drawX - pdrawX < 4 && drawX - pdrawX > -4) {
        if(dripsIO == true) {
          drip(); 
        }
      }
     
     // Set Previous Point
     pdrawX = drawX;
     pdrawY = drawY;
      
    }
    
  } 
  
 //-----------------------------------------------------------------------------------------
 
 
