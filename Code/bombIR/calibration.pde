
//-----------------------------------------------------------------------------------------
// CAMERA + CALIBRATION

Corner corner;
boolean showCam = true;
boolean showBlob  = true;
float LeftBorder, RightBorder, TopBorder, BottomBorder;
float cropScale;
CameraThread ct;

PShader mirror;

void setupCamera() {
  
  ct = new CameraThread("Camera",blobThresh, this);
  ct.start();
  
  mirror = loadShader("mirror.glsl");
   
  // Calbration Points
  /* set top to 40 because the frame kills 30px */
  corner = new Corner(10, 40, firstWindowWidth - 10, 40, firstWindowWidth - 10, windowHeight - 10, 10, windowHeight - 10);

}

void runCameraCalibration() {
  background(0);
  
  // Corner Points
  corner.update();
  corner.display();
  
  // Read Cam
  if (ct.getCam().available() == true) {
    ct.getCam().read();
  }
  
  // Show Cam ?
  if(showCam == true) {
    //image(ct.getCam(), 0, 0, firstWindowWidth, windowHeight);
    float mult = firstWindowWidth / ct.getWidth();
    float w = ct.getWidth() * mult;
    float h = ct.getHeight() * mult;
    
    /*
    PGraphics capture = createGraphics(int(w), int(h));
    
    capture.beginDraw();
    capture.image(ct.getCam(), 0, 0, w, h);
    capture.filter(mirror);
    capture.endDraw();
    
    image(capture, 0, -(h-windowHeight)/2, w, h);
    */
    
    image(ct.getCam(), 0, -(h-windowHeight)/2, w, h);
    
  } 
  
  // Show Blob ?
  if(showBlob == true) {
    ct.setThreshold(blobThresh);
    drawBlobsAndEdges(true, false);
  }
  
}

class Corner {
  
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
 
 // Update Cropping Points
 void update() {
   LeftBorder = (tlX + blX) /2;
   RightBorder = (trX + brX) /2; 
   TopBorder = (tlY + trY) /2;
   BottomBorder = (blY + brY) /2;
 }

 // Show Cropping Polygon
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

//runs the camera and blob detection in a different thread
class CameraThread extends Thread {
  //is the thread running?
  boolean running;
  //thread id
  String id;
  //the camera
  GSCapture cam;
  //blob detection instance
  BlobDetection bd;
  //the applet
  PApplet applet;

  /**
   * Constructor
   */
  public CameraThread(String s, float blobThresh, PApplet applet){
    this.running = false;
    this.id = s;
    this.applet = applet;
  }
  
  /**
   * Starts the thread
   */
  public void start(){
    running = true;
    println("Starting Camera Thread...");
    
    //needed if there is more than on camera connected (at least for linux)
    //use data/settings.properties for setting the value (env.cam.device)
    if (!camDevice.equals("default")){
      this.cam = new GSCapture(applet, 640, 480, camDevice);
    } else {
      this.cam = new GSCapture(applet, 320, 240);
    }
    
    this.cam.start();
    
    this.bd = new BlobDetection(this.cam.width, this.cam.height);
    this.bd.setPosDiscrimination(true);
    this.bd.setThreshold(blobThresh);
    super.start();
  }
  
  public void run(){
    //nothing to be done here
  }
  
  /**
   * Return the cam object
   */
  public GSCapture getCam(){
    return cam;
  }
  
  public float getWidth() {
    return this.cam.width;
  }
  
  public float getHeight() {
    return this.cam.height;
  }
  
  /**
   * Return the blob detection object
   */
  public BlobDetection getBlobDetection(){
    return bd;
  }
  
  /**
   * Set the threshold of the blob detection
   */
  public void setThreshold(float threshold){
    this.bd.setThreshold(threshold);
    this.bd.computeBlobs(cam.pixels);
  }
  
  /**
   * Stop camera and blob detection
   */
  public void quit(){
    println("Quitting Camera Thread...");
    running = false;
    this.cam.stop();
    interrupt();
  }

}
