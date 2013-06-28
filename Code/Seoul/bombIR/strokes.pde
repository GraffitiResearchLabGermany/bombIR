
//-----------------------------------------------------------------------------------------
// STROKES

void strokeOn() {
  //println("STROKE ON");
  
  clicked = true;
  
  // Start Timer
  timer.start();
  
  // Frame Counter
  frameCount = 0;
  currFrame = frameCount;
  
  // Simulate Random
  if(brush.getStyleID().equals(GhettoPaint.ID)){
    randomSeed(1);
    brush.set("randomseed", "1");
  }
  
  // Start Recording GML
  recorder.beginStroke(0, saveCount, brush);
  
  // Start Recording for AMQ
  messagingRecorder.beginStroke(0,0, brush);
  
}

void strokeOnAndOn() {
  //println("STROKE ON + ON + ON");

  //clicked = false;
  // Set UI Safe Zone
  if(drawY < height - menuHeight) {  
    // Call Style
    style();
    
    // Frame Counter
    elapsedFrame = frameCount - currFrame;
    float eF = elapsedFrame / 100;
    String eff = nf(eF, 1, 2);

    // Add points to GML stroke
    Vec3D v = new Vec3D((float) drawX/FirstScreenWidth, (float) drawY/FirstScreenHeight, 0);
    recorder.addPoint(0, v, float(eff));

    // AMQ Messaging
    timer.tick();
    messagingRecorder.addPoint(0,v,timer.getTime());
  } 
  
}

void strokeOff() {
  //println("STROKE OFFFFFF");

  clicked = false;
  
  // End current GML stroke
  recorder.endStroke(0);

  // Sending Message 
  //TODO add test if stroke got points to not send empty stroke messages
  messagingRecorder.endStroke(0);
  String gmlxml = GmlSavingHelper.getGMLXML(messagingRecorder.getGml());
  sendStrokeMessage(gmlxml);
  messagingRecorder.clear();
  timer.reset();
  
  // Save
   saveScreen();
  
}

//-----------------------------------------------------------------------------------------

