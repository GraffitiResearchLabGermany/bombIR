
//-----------------------------------------------------------------------------------------
// CALIBRATION

void runCalibration() {
  background(0);
  textFont(calibFont);
  
  // Read Cam
  if (cam.available() == true) {
    cam.read();
  }
  
  // Show Cam ?
  if(calibShowCam == true) {
    image(cam, 0, 0, FirstScreenWidth, FirstScreenHeight);
  } 
  
  // Show Blob ?
  if(calibShowBlob == true) {
    bd.computeBlobs(cam.pixels);
    CalibdrawBlobsAndEdges(true, true);
  }  
  
  // Draw Text
  fill(255);
  instructions = "Ok... ";  
  //text(instructions, FirstScreenWidth/4, FirstScreenHeight /2); 
  
  // Draw Bounding Box
  stroke(0, 255, 0);
  strokeWeight(2);
  noFill();
  line(LeftBorder, TopBorder, LeftBorder, BottomBorder);
  line(RightBorder, TopBorder, RightBorder, BottomBorder);
  line(LeftBorder, TopBorder, RightBorder, TopBorder);
  line(LeftBorder, BottomBorder, RightBorder, BottomBorder);  

}

//-----------------------------------------------------------------------------------------

void saveCalibrationSettings() {
  
  try {
    println("Attempting To Save Crops To File...");
    
    // Existing Format
    String line1 = "# Camera Settings";
    String line2 = "cam.settings.cameraid=";      line2 += str(CameraID);
    String line3 = "cam.settings.camerawidth=";   line3 += str(CameraWidth);
    String line4 = "cam.settings.cameraheight=";  line4 += str(CameraHeight);
    
    String line5 = "";
    
    String line6 = "# Calibration Settings";      
    String line7 = "calib.settings.recalibrate=YES";
    String line8 = "calib.settings.left=";        line8 += str(LeftBorder/FirstScreenWidth);
    String line9 = "calib.settings.right=";       line9 += str(RightBorder/FirstScreenWidth);
    String line10 = "calib.settings.top=";        line10 += str(TopBorder/FirstScreenHeight);
    String line11 = "calib.settings.bottom=";     line11 += str(BottomBorder/FirstScreenHeight);

    String line12 = "";

    String line13 = "# Blob Settings";            
    String line14 = "track.blob.min=";            line14 += str(blobMin);
    String line15 = "track.blob.max=";            line15 += str(blobMax);
    String line16 = "track.blob.thresh=";         line16 += str(blobThresh);
    
    BufferedWriter writer = new BufferedWriter(new FileWriter(sketchPath("") + "settings.camera.properties", false));

    writer.write(line1);  writer.newLine();
    writer.write(line2);  writer.newLine();
    writer.write(line3);  writer.newLine();
    writer.write(line4);  writer.newLine();
    writer.write(line5);  writer.newLine();
    writer.write(line6);  writer.newLine();
    writer.write(line7);  writer.newLine();
    writer.write(line8);  writer.newLine();    
    writer.write(line9);  writer.newLine();
    writer.write(line10);  writer.newLine();
    writer.write(line11);  writer.newLine();
    writer.write(line12);  writer.newLine();
    writer.write(line13);  writer.newLine();
    writer.write(line14);  writer.newLine();
    writer.write(line15);  writer.newLine();
    writer.write(line16);  writer.newLine();

    writer.flush();
    writer.close();
    println("Saved Properties To File Successfully...");
    
    // Let's Draw !
    calibrate = false;
    
  } 
  catch (IOException e) {
    println("Couldnt Save Properties To File... ??");
    e.printStackTrace();
  }
  
}
