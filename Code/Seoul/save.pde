
  //-----------------------------------------------------------------------------------------
  void saveScreen() {
    saveCount ++;
    // Save Image w/o gui
    pg.save("exports/Save_" + saveCount + ".jpg");
    // Save GML File
    saver.save(recorder.getGml(), sketchPath +"/exports/GML_" + saveCount + ".xml");
  }
      
  //-----------------------------------------------------------------------------------------

