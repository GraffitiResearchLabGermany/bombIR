
 //-----------------------------------------------------------------------------------------
  
  void eraseAll() {
    pg.background(0); // reset background
    sendClearScreenMessage(); // Clear Remote Screen
    recorder.clear(); // clear gml 
    numDrips = 0; // delete drips
  }
  
  //-----------------------------------------------------------------------------------------

