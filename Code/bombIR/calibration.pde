/**
 * CAMERA + CALIBRATION
 */

/**
 * TODO: Document this declaration
 */
Corner corner;
/**
 * Should the camera image be shown on the paint screen
 */
boolean showCam = true;
/**
 * Should blobs be displayed on the paint screen
 */
boolean showBlob  = true;
/**
 * TODO: Document this declaration
 */
float LeftBorder;
/**
 * TODO: Document this declaration
 */
float RightBorder;
/**
 * TODO: Document this declaration
 */ 
float TopBorder;
/**
 * TODO: Document this declaration
 */ 
float BottomBorder;
/**
 * Thread of the tracking camera
 */
CameraThread ct;

/**
 * Setup the camera for tracking
 */
void setupCamera() {
  
  ct = new CameraThread("Camera", this);
  ct.start();
   
  // Calbration Points
  /* set top to 40 because the frame kills 30px */
  corner = new Corner(10, 40, firstWindowWidth - 10, 40, firstWindowWidth - 10, windowHeight - 10, 10, windowHeight - 10);

}

/**
 * Calibrate the camera
 * TODO: Document what's happening here
 */
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
    
    // Compute factors for 16:9
    float mult = firstWindowWidth / ct.getWidth();
    float w = ct.getWidth() * mult;
    float h = ct.getHeight() * mult;
    
    // Display the 4:3 capture so that it is centered 
    // vertically and cropped top and bottom in 16:9
    float xCapture = 0;
    float yCapture = -(h-windowHeight)/2; // centering [OPTIMIZE: use imageMode(CENTER)]
    image(ct.getCam(), xCapture, yCapture, w, h);
    
    // Draw smaller camera preview when necessary
    if ( capturePreview.isVisible() ) {
      pushMatrix();
      translate(350, 220); // Place the preview somewhere below the  (hardcoded for testing)
      capturePreview.setScreen(ct.getCam());
      capturePreview.draw();
      popMatrix();
    }
    
  } 
  
  // Show Blob ?
  if(showBlob == true) {
    ct.setThreshold(blobThresh);
    drawBlobsAndEdges(true, false);
  }
  
}

/**
 * TODO: Document this class
 */
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
 
 /**
  * Update Cropping Points
  */
 void update() {
   LeftBorder = (tlX + blX) /2;
   RightBorder = (trX + brX) /2; 
   TopBorder = (tlY + trY) /2;
   BottomBorder = (blY + brY) /2;
 }

 /**
  * Show Cropping Polygon
  */
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

/**
 * Runs the camera and blob detection in a different thread
 * in the hope to increase performance
 */
class CameraThread extends Thread {
  /**
   * is the thread running?
   */
  boolean running;
  /**
   * id of the thread
   */
  String id;
  /**
   * the camera
   */
  GSCapture cam;
  /**
   * blob detection instance
   */
  BlobDetection bd;
  /**
   * the applet
   */
  PApplet applet;

  /**
   * Constructor

   * @param id the ID of the thread
   * @param applet the applet to call back to
   */
  public CameraThread(String id, PApplet applet){
    this.running = false;
    this.id = id;
    this.applet = applet;
  }
  
  /**
   * Starts the thread
   */
  public void start(){
    running = true;
    logger.info("Starting Camera Thread...");
    
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
  
  /**
   * Thread needs to implement run
   */
  public void run(){
    //nothing to be done here
  }
  
  /**
   * Return the cam object
   */
  public GSCapture getCam(){
    return cam;
  }
  
  /**
   * Get the width of the camera image
   *
   * @return the width of the camera image
   */
  public float getWidth() {
    return this.cam.width;
  }

  /**
   * Get the height of the camera image
   *
   * @return the height of the camera image
   */
  public float getHeight() {
    return this.cam.height;
  }
  
  /**
   * Get the blob detection object
   * 
   * @return the blob detection object
   */
  public BlobDetection getBlobDetection(){
    return bd;
  }
  
  /**
   * Set the threshold of the blob detection
   * 
   * @param the threshold to be set
   */
  public void setThreshold(float threshold){
    this.bd.setThreshold(threshold);
    this.bd.computeBlobs(cam.pixels);
  }
  
  /**
   * Stop camera and blob detection
   */
  public void quit(){
    logger.info("Quitting Camera Thread...");
    running = false;
    this.cam.stop();
    interrupt();
  }

}
