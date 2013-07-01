
//-----------------------------------------------------------------------------------------
// CAMERA + CALIBRATION

Corner corner;
boolean calibCam = true;
boolean calibBlb  = true;
float LeftBorder, RightBorder, TopBorder, BottomBorder;
int cropScale;

void setupCamera() {
  
  // Capture 
  cam = new GSCapture(this, 320, 240);
  //cv = new OpenCV(this); 
  //cv.allocate(320, 240);
  cam.start();
  
  // Blob Detection
  bd = new BlobDetection(cam.width, cam.height);
  bd.setPosDiscrimination(true);
  bd.setThreshold(blobThresh);
  
  // Calbration Points
  corner = new Corner(50, 50, firstWindowWidth - 50, 50, firstWindowWidth - 50, windowHeight - 50, 50, windowHeight - 50);
  
}

void runCameraCalibration() {
  background(0);
  
  // Corner Points
  corner.update();
  corner.display();
  
  
  // Read Cam
  if (cam.available() == true) {
    cam.read();
  }
  
  // Show Cam ?
  if(calibCam == true) {
    image(cam, 0, 0, firstWindowWidth, windowHeight);
  } 
  
  // Show Blob ?
  if(calibBlb == true) {
    bd.setThreshold(blobThresh);
    bd.computeBlobs(cam.pixels);
    CalibdrawBlobsAndEdges(true, true);
  }
  
}


class Corner {
  
 int w, h;
 int tlX, tlY, trX, trY, brX, brY, blX, blY;
  
 Corner(int _tlX, int _tlY, int _trX, int _trY, int _brX, int _brY, int _blX, int _blY) {

   tlX = _tlX;
   tlY = _tlY;
   trX = _trX;
   trY = _trY;
   brX = _brX;
   brY = _brY;
   blX = _blX;
   blY = _blY;   
   
   
 } 
 
 void update() {


 }

 
 void display() {
   pushStyle();
     noFill();
     stroke(255, 0, 0);
     beginShape();
       vertex(tlX, tlY);
       vertex(trX, trY);
       vertex(brX, brY);
       vertex(blX, blY);
       vertex(tlX, tlY);
     endShape(); 
   popStyle(); 
 }
  
  
}
