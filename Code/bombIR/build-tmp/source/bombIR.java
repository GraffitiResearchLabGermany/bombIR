import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import io.thp.psmove.*; 
import java.util.Properties; 
import codeanticode.gsvideo.*; 
import blobDetection.*; 
import java.awt.Robot; 
import java.awt.AWTException; 
import java.awt.event.InputEvent; 
import java.awt.GraphicsDevice; 
import java.awt.GraphicsEnvironment; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class bombIR extends PApplet {


//-----------------------------------------------------------------------------------------
/*
 * bombIR
 * ---------------------------------------------------------------------------
 * Graffiti Research Lab Germany
 * http://www.graffitiresearchlab.de
 * ----------------------------------------------------------------------------
 * License:
 * Licensed according to the 
 * Attribution-Non-Commercial-Repurcussions 3.0 Unported (CC BY-NC 3.0)
 * as per http://www.graffitiresearchlab.fr/?portfolio=attribution-noncommercial-repercussions-3-0-unported-cc-by-nc-3-0
 * 
 * ----------------------------------------------------------------------------
 * Credits
 * _______
 * 
 * Programming:  
 *   Jesse Scott
 *   Hauke Altmann
 *   Raphael de Courville
 * 
 * Libraries:
 *  controlP5
 *  psmove
 *  gsvideo
 *  blobdetection
 * ----------------------------------------------------------------------------
 */
//-----------------------------------------------------------------------------------------

// IMPORTS
//-----------------------------------------------------------------------------------------












  
// DECLARATIONS
//-----------------------------------------------------------------------------------------  
PGraphics wallscreen, paintscreen, paintbackground;
PImage bg;

ScreenPreview capturePreview;


// Spray renderers
SprayManager sprayManagerLeft; // paint screen (left)
SprayManager sprayManagerRight;  // wall screen (right)

// Robot mouse
//Robot robot;


// GLOBAL VARIABLES
//-----------------------------------------------------------------------------------------
boolean clicked = false;
boolean clickedEvent = false;
boolean calibrateKeystone = false;


//-----------------------------------------------------------------------------------------

public void init() {
  // remove the window frame
  frame.removeNotify(); 
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

//-----------------------------------------------------------------------------------------
  
  public void setup() {
    
        // Create the robot mouse
        //try                    { robot = new Robot(); } 
        //catch (AWTException e) { e.printStackTrace(); }
    
        // Create the spray objects for both screens
        sprayManagerLeft   = new SprayManager();
        sprayManagerRight  = new SprayManager();
        
        //read the values from the configuration file
        readConfiguration();
        
        //P3D or OPENGL seems to only work with one window (https://forum.processing.org/topic/opengl-rendering-multiple-windows-frames), 
        //so we make it big enough to span over two output devices (rp screen projector, wall projector) and position it to start at 
        //the first projector screen
  	    size(windowWidth, windowHeight, P3D);
        
        //create painting screen
        paintscreen = createGraphics(windowWidth/2, windowHeight, P3D);
        wallscreen = createGraphics(windowWidth/2, windowHeight, P3D);
        paintbackground = createGraphics(windowWidth/2,windowHeight,P3D);
        
        //paint the background of the paintscreen
        bg = loadImage(bgFile);
        bg.resize(windowWidth/2, windowHeight);
        drawPaintBg();

        //paint the screen to piant on
        paintscreen.beginDraw();
        paintscreen.image(paintbackground,0,0);
        paintscreen.strokeCap(SQUARE);
        paintscreen.endDraw();
        
        //paint the screen that is projected on the wall
        wallscreen.beginDraw();
        wallscreen.background(0);
        wallscreen.strokeCap(SQUARE);
        wallscreen.endDraw();
        
        //setup opencv & video capture
        setupCamera();

        // create the camera preview
        capturePreview = new ScreenPreview((int)ct.getWidth(), (int)ct.getHeight());

        
        //setup the spraypaint shader
        //spraymanager for the paintscreen
        sprayManagerLeft.setup();
        //spraymanager for the wallscreen
        sprayManagerRight.setup();
        
        //setup the control menu (colorpicker, clear screen, save, etc.)
        setupMenu();
        
        // setup the menu for the calibration screen
        setupCalibrationMenu();
        
        //Init the PSMove controller(s)
        psmoveInit();

        setupMouseRobot();
		
        //put the upper left corner of the frame to the upper left corner of the screen
        //needs to be the last call on setup to work
	frame.setLocation(frameXLocation,0);

  } // end SETUP
  
  //-----------------------------------------------------------------------------------------
  
  public void draw() {
    
    // Calibration Stage
    if(calibrateCamera) {
      runCameraCalibration();
    }
    
    // Main Draw Loop
    else {
      
      //let the blob control your mouse if move connected
      controlMouse();
      
      //draw background for painting screen on first frame
      if(frameCount == 1 ) {
        //noCursor();
        drawPaintBg();
      }
      
      // Read Cam
      if (ct.getCam().available() == true) {
        ct.getCam().read();
      }
      
      
      // Compute Blobs
      ct.setThreshold(blobThresh);
      
      
      // Show Cam ?
      if(showCam == true) {
        
        println("test");
        
        //image(ct.getCam(), 0, 0, firstWindowWidth, windowHeight);
        float mult = width /  ct.getWidth();
        float w = ct.getWidth() * mult;
        float h = ct.getHeight() * mult;
        image(ct.getCam(), 0, -(h-height)/2, w, h);

        // Draw smaller camera preview when necessary
        if ( capturePreview.isVisible() ) {
          println("preview activated");
          pushMatrix();
          translate(350, 190); // Place the preview somewhere between the  (hardcoded for testing)
          capturePreview.setScreen(ct.getCam());
          capturePreview.draw();
          popMatrix();
        }
        
      } 
      
      
      // Show Blob ?
      if(showBlob == true) {
        if(!showCam) {
          background(0);
          drawPaintBg();
        }
        drawBlobsAndEdges(true, false);
      }
     	
      //update the x/y coordinates of the current blob
      updateCurrentBlob();
      
      //draw painting screen
      paintscreen.beginDraw();
        if(!menu.isVisible() && !calibMenu.isVisible() && calibrateKeystone == false) {
          if(clickedEvent) sprayManagerLeft.initSpray();
          sprayManagerLeft.spray(paintscreen);
        }
      paintscreen.endDraw();
      
      //draw wall screen
      wallscreen.beginDraw();
          if(!menu.isVisible() && !calibMenu.isVisible() && calibrateKeystone == false) {
            if(clickedEvent) sprayManagerRight.initSpray();
            sprayManagerRight.spray(wallscreen);
          }
      wallscreen.endDraw();
      
   
      //draw painting area (left)
      image(paintscreen,0,0);
      
      //draw the projection area (right)
      image(wallscreen,width/2,0);
  
      // GUI
      if(menu.isVisible()){
        cp.render();
        pickColor();
      }
    
    } 
    
    // Playstation Move update
    psmoveUpdate();
    
    //if(debug) println("Framerate: " + int(frameRate));

    
  } // end DRAW

//draw the background of the paintscreen
public void drawPaintBg(){
        paintbackground.beginDraw();
        paintbackground.image(bg,0,0);
        paintbackground.endDraw();
}
  
  
//-----------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------
// BLOB DETECTION

float blobX, blobY;
float blobSize;

public void drawBlobsAndEdges(boolean drawEdges, boolean drawRects) {  
  Blob b;
  EdgeVertex eA,eB;


  for (int n = 0 ; n < ct.getBlobDetection().getBlobNb() ; n++) {
    b = ct.getBlobDetection().getBlob(n);
    //println("There Are " + ct.getBlobDetection().getBlobNb() + " Blobs Detected...");
    if (b!= null) {
        
      // Edges
      if (drawEdges) {
         // If Blobs Are Within Crop Area
        if(b.xMin * firstWindowWidth > LeftBorder && b.xMin * firstWindowWidth < RightBorder && b.yMin * windowHeight > TopBorder && b.yMin * windowHeight < BottomBorder) {    
          // If The Blob Is Over A Certain Size
          if(b.w > blobMin && b.w < blobMax) {
            
            noFill();
            strokeWeight(2);
            stroke(0, 0, 255);
            beginShape();
              for (int m = 0; m < b.getEdgeNb(); m++) {
                eA = b.getEdgeVertexA(m);
                eB = b.getEdgeVertexB(m);
                  if (eA != null && eB != null) {
                    vertex(eA.x * captureWidth, eA.y * captureHeight - captureOffsetY); // keep the 4:3 ratio and positionning of the capture image
                  }
              }
            endShape(CLOSE); 
            
            // Return Valid Blobs
            //blobX = (b.xMin * firstWindowWidth);
            
            //blobX = map(blobX, 0, firstWindowWidth, LeftBorder, RightBorder - LeftBorder);
            
            //float mult = firstWindowWidth / ct.getWidth(); // vertical stretch
            //blobY = (b.yMin * windowHeight * mult );
            
            //blobY = map(blobY, 0, windowHeight, TopBorder, BottomBorder - TopBorder);

            //println("BX: " + blobX + "  BY: " + blobY); 
            
          }
        }   
      }     
      
      // Blobs
      if (drawRects) {
        strokeWeight(1);
        noFill();
        stroke(255,0,0);
        rectMode(CORNER);
        // If Blobs Are Within Crop Area
        if(b.xMin * firstWindowWidth > LeftBorder && b.xMin * firstWindowWidth < RightBorder && b.yMin * windowHeight > TopBorder && b.yMin * windowHeight < BottomBorder) {
          // If The Blob Is Over A Certain Size
          if(b.w > blobMin && b.w < blobMax) {
            rect(b.xMin * firstWindowWidth, b.yMin * windowHeight, b.w * firstWindowWidth, b.h * windowHeight);
          }
        }    
      }
        
    } // null
  } // for
} 

//set the mapped x/y coordinates to blobX and blobY
public void updateCurrentBlob() {
  //we have at least one blob  
  if(ct.getBlobDetection().getBlobNb() >= 1){
    
      float xBlobUnit = ct.getBlobDetection().getBlob(0).xMin;
      float yBlobUnit = ct.getBlobDetection().getBlob(0).yMin;
      
      println("");
      println("ct.getBlobDetection().getBlob(0).xMin = " + ct.getBlobDetection().getBlob(0).xMin);
      println("ct.getBlobDetection().getBlob(0).yMin = " + ct.getBlobDetection().getBlob(0).yMin);
      
      // Flip the X axis (when not using the rear projection screen)
      if( mirrorX == true ) xBlobUnit = 1.0f - xBlobUnit;

      // Map the blob coordinates from unit square to the cropping area
      blobX = map( xBlobUnit, 0.0f, 1.0f, RightBorder - LeftBorder, LeftBorder);
      blobY = map( yBlobUnit, 0.0f, 1.0f, TopBorder, BottomBorder - TopBorder);
      
      // Let's just average the two dimensions of the blob (we just need an order of magnitude).
      blobSize = ( ct.getBlobDetection().getBlob(0).w + ct.getBlobDetection().getBlob(0).h ) / 2.0f;
      //System.out.println( "blobSize = "+ blobSize );

      
      //println("blobX:" + blobX);
      //println("blobY:" + blobY);
      
  //we dont have a blob  
  } else {
      //println("No Blobs detected");
  }
}

// -------------------------------- //

//-----------------------------------------------------------------------------------------
// CAMERA + CALIBRATION

Corner corner;
boolean showCam = true;
boolean showBlob  = true;
float LeftBorder, RightBorder, TopBorder, BottomBorder;
CameraThread ct;

public void setupCamera() {
  
  ct = new CameraThread("Camera", blobThresh, this);
  ct.start();
   
  // Calbration Points
  /* set top to 40 because the frame kills 30px */
  corner = new Corner(10, 40, firstWindowWidth - 10, 40, firstWindowWidth - 10, windowHeight - 10, 10, windowHeight - 10);

}

public void runCameraCalibration() {
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
 public void update() {
   LeftBorder = (tlX + blX) /2;
   RightBorder = (trX + brX) /2; 
   TopBorder = (tlY + trY) /2;
   BottomBorder = (blY + brY) /2;
 }

 // Show Cropping Polygon
 public void display() {
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

//-----------------------------------------------------------------------------------------
// CONFIGURATION - configuration values are stored in data/settings.properties
//add all variables that are set with the settings.properties here
 
//Access to the properties file
P5Properties props;

// debugging mode, log messages are shown on the console
// and the two "windows" appear smaller & on the main screen
boolean debug = false;

// If false, skip camera calibration and use default values (set in settings.properties)
boolean calibrateCamera = true;

//height of the application window
int windowHeight;
//width of the application window
int windowWidth;
//width of the paintscreen
int firstWindowWidth;
//x location of the window
int frameXLocation;
//file for the backgroudn image
String bgFile;
//device of the camera (only set when needed)
String camDevice;

// BLOB & CALIBRATION variables
float cropScale  = 0.0f;
float blobMin    = 0.03f;      
float blobMax    = 0.70f;
float blobThresh = 0.98f;

// SHADER variables
float brushSize;
float brushSoften;
String brushMap;

// 
boolean mirrorX;

boolean alwaysUseMouse;

int ratio;

float captureWidth, captureHeight, captureOffsetY;

//size of the colorpicker
int cpsize;

//index of the paintscreen
int paintscreenIndex;
 

public void readConfiguration() {
  try {
    
    props = new P5Properties();
    
    // load a configuration from a file inside the data folder
    props.load(createInput("settings.properties"));
    
    // In debug mode, we print debug messages and the two "windows" 
    // appear smaller in the main screen
    debug           = props.getBooleanProperty ( "env.mode.debug",          false             );
    alwaysUseMouse  = props.getBooleanProperty ( "env.mode.alwaysUseMouse", false             );
    calibrateCamera = props.getBooleanProperty ( "env.mode.calib",          false             );
    cpsize          = props.getIntProperty     ( "env.colorpicker.size",    400               );
    
    // What image file should be used as a background for the paintscreen?
    bgFile          = props.getProperty        ( "env.bg.file",             "background.jpg"  );
    
    // Which camera device are we using?
    camDevice       = props.getProperty        ( "env.camera.device",       "default"         );
    
    // SHADER vars
    brushSize       = props.getIntProperty     ( "env.shader.brushSize",    100               );
    brushSoften     = props.getFloatProperty   ( "env.shader.brushSoften",  0.5f               );
    brushMap        = props.getProperty        ( "env.shader.brushMap",     "sprayMap_01.png" );
    
    
    // Proportions of the screen ( 0 = 4:3 and 1 = 16:9 )
    ratio           = props.getIntProperty     ( "env.viewport.ratio",      0                 ); 
    
    
    // Moving the windows around and scaling 
    // depending on debug status and ratio
    
    if(debug) { // if we're using the main screen (debug mode)
      frameXLocation = props.getIntProperty("env.viewport.frame.xlocation_debug",0);
      if(ratio == 0) { // 4:3
        windowWidth = props.getIntProperty("env.viewport.width_4_3", 1600); 
        windowHeight = props.getIntProperty("env.viewport.height_4_3", 600);
      }
      else if(ratio == 1) { // 16:9
        windowWidth = props.getIntProperty("env.viewport.width_16_9", 1600); 
        windowHeight = props.getIntProperty("env.viewport.height_16_9", 450);
      }
      frameXLocation = props.getIntProperty("env.viewport.frame.xlocation_debug",0);
    }
    else { // if we're using the secondary screens (performance mode)
      windowWidth    = props.getIntProperty("env.viewport.width", 1024); 
      windowHeight   = props.getIntProperty("env.viewport.height", 384);
      frameXLocation = props.getIntProperty("env.viewport.frame.xlocation",0);
    }
    
    firstWindowWidth = windowWidth/2;
    
    
    // Used to keep the aspect ratio of the camera capture image
    // and center it vertically. Also to display the blobs properly.
    
    captureWidth   = firstWindowWidth;
    captureHeight  = firstWindowWidth/4*3; // Keep cropping in 4:3 even in 16:9 mode
    captureOffsetY = - (windowHeight - captureHeight) / 2; // Should equal 0 when in 4:3

    paintscreenIndex = props.getIntProperty    ( "env.viewport.paintscreen.index", 1 );

    // BLOB vars
    blobMin         = props.getFloatProperty   ( "env.mode.blobMin",    0.03f  );
    blobMax         = props.getFloatProperty   ( "env.mode.blobMax",    0.70f  );
    blobThresh      = props.getFloatProperty   ( "env.mode.blobThresh", 0.98f  );
    
    // Flip the x axis of the tracking?
    mirrorX         = props.getBooleanProperty ("env.mode.mirrorX",     false );
    

  }
  catch(IOException e) {
    println("couldn't read config file...");
  }
}
 
/**
 * simple convenience wrapper object for the standard
 * Properties class to return pre-typed numerals
 */
class P5Properties extends Properties {
 
  public boolean getBooleanProperty(String id, boolean defState) {
    return PApplet.parseBoolean(getProperty(id,""+defState));
  }
 
  public int getIntProperty(String id, int defVal) {
    return PApplet.parseInt(getProperty(id,""+defVal));
  }
 
  public float getFloatProperty(String id, float defVal) {
    return PApplet.parseFloat(getProperty(id,""+defVal)); 
  }  
}

//-----------------------------------------------------------------------------------------
// MENU + GUI CONTROL

int saveCount = 0;

 public void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    
    paintscreen.beginDraw();
    paintscreen.clear();
    paintscreen.image(paintbackground,0,0);
    paintscreen.endDraw();
    
    wallscreen.beginDraw();
    wallscreen.clear();
    wallscreen.endDraw();
  }
 }

 // SAVE
 public void SAVE(boolean theFlag) {
  if(theFlag == true) {
     saveCount ++;
     // save image w/o gui
     wallscreen.save("exports/Save_" + saveCount + ".jpg");
  }
 } 

 //adjust brush size
 public void WIDTH(int brushSize) {
    sprayManagerLeft.setWeight(brushSize);
    sprayManagerRight.setWeight(brushSize);
 } 
 
 
 // Set the position of the cropping area corners
 
 public void cropScale(float cs) {      // defined in settings.properties
     float w = firstWindowWidth; // defined in settings.properties
     float h = windowHeight;
     corner.tlX = PApplet.parseInt( w / 2.0f * cs );
     corner.tlY = PApplet.parseInt( h / 2.0f * cs );
     corner.trX = PApplet.parseInt( w - ( w  / 2.0f * cs ) );
     corner.trY = PApplet.parseInt( h / 2.0f * cs );
     corner.brX = PApplet.parseInt( w - ( w  / 2.0f * cs ) );
     corner.brY = PApplet.parseInt( h - ( h  / 2.0f * cs ) );
     corner.blX = PApplet.parseInt( w / 2.0f * cs );
     corner.blY = PApplet.parseInt( h - ( h  / 2.0f * cs ) );
 }

 // Show Blob
 public void showBlob() {
   if(calibrateCamera) {
     showBlob =! showBlob;
   }
   if(!calibrateCamera) {
     showBlob =! showBlob;
     background(0);
     drawPaintBg();
   }   
 }
 
 // Show Cam
 public void showCam() {
   if(calibrateCamera) {
     showCam =! showCam;
   }
   if(!calibrateCamera) {
     showCam =! showCam;
     background(0);
     drawPaintBg();
   }   
 }
 
 // Save Calibration
 public void saveCalib() {
   if(calibrateCamera) {
     background(0);
     calibrateCamera = false; 
     showCam = false;
     showBlob = false;
     drawPaintBg();
     calibMenu.hide();
     noCursor();
   }
 }
 
 public void keyPressed() {
   switch(key) {
     case 'r': 
       // clear the paint screen (left)
       sprayManagerLeft.reset(paintscreen, bg); 
       // clear the wall screen (right)
       sprayManagerRight.reset(wallscreen, color(0));
     break;
     case 'm': 
       if(!calibrateCamera) {   
         toggleMenu();
         drawPaintBg();
       }
     break;
     case 'b':
       toggleBlobControl();
       if(calibrateCamera) {   
         background(0);
       }
       else {
         drawPaintBg();
       }
     break;     
   }
 }
   
 //show or hide the menu
 public void toggleMenu(){
   if(menu.isVisible()){
     noCursor();
     menu.hide();
     background(0);
   }
   else {
     menu.show();
     cursor(CROSS);
   }
 }
 
 //show or hide blob control
 public void toggleBlobControl(){
   if(calibMenu.isVisible()){
     capturePreview.hide();
     calibMenu.hide();
     background(0);
     noCursor();
   }
   else {
     capturePreview.show();
     calibMenu.show();

     cursor(CROSS);
   }
 }

//-----------------------------------------------------------------------------------------
// GUI

// colorpicker menu
ControlP5 menu;
// separate menu for calibration
ControlP5 calibMenu;
//color of the picker
int picker;
//red, green and blue color values for the brush
float brushR, brushG, brushB;
//number of the active colorslot
int activeColorSlot = 0;
//Canvas to display the colorslots
ColorSlotCanvas cs;
//radio button to select a colorslot
RadioButton rb;
//the colorpicker
ColorPicker cp;


//setup the control menu
public void setupMenu(){
    menu = new ControlP5(this);
    
    cp = new ColorPicker(50, 100, cpsize, cpsize, 45);
    
    cs = (ColorSlotCanvas)menu.addGroup("cs")
                .setPosition(cpsize + 50, 110)
                .setBackgroundHeight(cpsize + 1)
                .setWidth(100)
                .setBackgroundColor(color(50))
                .hideBar()
                .addCanvas(new ColorSlotCanvas())
                ;       
    
    menu.addGroup("misc")
                .setPosition(50, cpsize + 100)
                .setBackgroundHeight(80)
                .setWidth(cpsize + 90)
                .setBackgroundColor(color(50))
                .hideBar()
                ;
    menu.addGroup("width")
                  .setPosition(50, 51)
                  .setBackgroundHeight(60)
                  .setWidth(cpsize + 90)
                  .setBackgroundColor(color(50))
                  .hideBar()
                  ;
    menu.addGroup("logo")
                  .setPosition(cpsize + 90,51)
                  .setBackgroundHeight(cpsize+129)
                  .setWidth(200)
                  .setBackgroundColor(color(50))
                  .hideBar()
                  .addCanvas(new LogoCanvas());
     
    menu.addSlider("WIDTH", 1, 200, brushSize, 5, 5, cpsize, 50).setGroup("width");
    menu.addBang("CLEAR", 10, 10, 50, 50).setGroup("misc");
    menu.addBang("SAVE",  80, 10, 50, 50).setGroup("misc");
    
    rb = menu.addRadioButton("radioButton")
         .setPosition(cpsize + 90,110)
         .setSize(30,30)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(1)
         .setSpacingColumn(50)
         .addItem("Color1",0)
         .addItem("Color2",1)
         .addItem("Color3",2)
         .addItem("Color4",3)
         .addItem("Color5",4)
         ;
     rb.activate(0);

    menu.hide();
}



public void setupCalibrationMenu() {
  // Init
  calibMenu = new ControlP5(this);
  // Scale
  calibMenu.addSlider("cropScale").setPosition(350, 51).setSize(200, 20).setRange(0, 1);
  // Blob Threshold
  calibMenu.addSlider("blobThresh").setPosition(350, 76).setSize(200, 20).setRange(0, 1);
  // Blob Min
  calibMenu.addSlider("blobMin").setPosition(350, 101).setSize(200, 20).setRange(0, 1);
  // Blob Max
  calibMenu.addSlider("blobMax").setPosition(350, 126).setSize(200, 20).setRange(0, 1);
  // Show Cam
  calibMenu.addToggle("showCam").setPosition(350, 151).setSize(40, 40);
  // Show Blobs
  calibMenu.addToggle("showBlob").setPosition(400, 151).setSize(40, 40);
  // Save Calibration
  calibMenu.addBang("saveCalib").setPosition(450, 151).setSize(40, 40);
  
  calibMenu.hide();
}


//pick color with the mouse
public void pickColor(){ 
    if(mouseX > 50 && mouseY < cpsize + 100 && mouseY > 100 && mouseX < cpsize + 50) {
          if(mousePressed) {
            picker = get(mouseX, mouseY);
            brushR = red(picker);
            brushG = green(picker);
            brushB = blue(picker);
            cs.setColorSlot(activeColorSlot,brushR,brushG,brushB);
          }
     }
}

//is called when a radio button is pressed
public void radioButton(int a) {
  //a is -1 if an activated button is pressed again
  if(a == -1){
    //keep the button activated
    rb.activate(activeColorSlot);
  } else {
    activeColorSlot = a;  
  } 
  
}

//change colorslot, picks always the next colorslot
public void switchColorSlot(){
  activeColorSlot = cs.getNextColorSlot(activeColorSlot);
  rb.activate(activeColorSlot);
}

/**
 * Displays the CA and DE logo on the menu
 */
class LogoCanvas extends Canvas {
  protected PImage deLogo;
  protected PImage caLogo;

  public void setup(PApplet p) {
    deLogo = p.loadImage("Logo_de.png");
    caLogo = p.loadImage("Logo_ca.png");
  }
  
  public void draw(PApplet p) {
      p.image(deLogo, 0, 200, 200, 180);
      p.image(caLogo, 0, 400, 200, 120);
  }
}

/**
 * Slot to save picked colors for later use
 */
class ColorSlot{
  
  protected float red = 255.0f;
  protected float green = 255.0f;
  protected float blue = 255.0f;
  
  protected int positionX;
  protected int positionY;
 
  public ColorSlot(int positionX, int positionY) {
    this.positionX = positionX;
    this.positionY = positionY;
  }
  
  public void draw(PApplet applet){
    applet.fill(red, green, blue);
    applet.rect(this.positionX, this.positionY, 30, 30);
  }
  
  public float getRed() {
    return red;
  }
  
  public float getGreen() {
    return green;
  }
  
  public float getBlue() {
    return blue;
  }
  
  public void setRed(float red) {
    this.red = red;
  }
  
  public void setGreen(float green) {
   this.green = green; 
  }
  
  public void setBlue(float blue) {
    this.blue = blue;
  }
}

/**
 * Class for displaying Colorslots to preselect colors for 
 * later use.
 */
class ColorSlotCanvas extends Canvas {
  ColorSlot[] colorSlots = new ColorSlot[5];
  
  public void setup(PApplet p) {
    colorSlots[0] = new ColorSlot(5,0);
    colorSlots[1] = new ColorSlot(5,31);
    colorSlots[2] = new ColorSlot(5,62);
    colorSlots[3] = new ColorSlot(5,93);
    colorSlots[4] = new ColorSlot(5,124);
  }
  
   public void draw(PApplet p) {
    for(int i=0;i<=4;i++){
        this.colorSlots[i].draw(p);
    }
  }
  
  //update the color of the color slot
  public void setColorSlot(int activeSlot, float red, float green, float blue) {
    this.colorSlots[activeSlot].setRed(red);
    this.colorSlots[activeSlot].setGreen(green);
    this.colorSlots[activeSlot].setBlue(blue); 
  }
  
  public int getNextColorSlot(int activeSlot) {
    if(activeSlot < this.colorSlots.length-1) {
      return activeSlot+1;
    } 
    return 0;
  }
  
  public ColorSlot getColorSlot(int id){
    return this.colorSlots[id];
  }

  public int getNumberOfSlots(){
    return this.colorSlots.length;
  }

}

/**
 * Colorpicker from http://www.julapy.com/processing/ColorPicker.pde
 * with little adjustments
 */
 
public class ColorPicker {
  int x, y, w, h, c;
  PImage cpImage;
  
  public ColorPicker ( int x, int y, int w, int h, int c ) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    
    cpImage = new PImage( w, h );
    
    init();
  }
  
  private void init () {
    // draw color.
    int cw = w - 60;
    for( int i=0; i<cw; i++ ) {
      float nColorPercent = i / (float)cw;
      float rad = (-360 * nColorPercent) * (PI / 180);
      int nR = (int)(cos(rad) * 127 + 128) << 16;
      int nG = (int)(cos(rad + 2 * PI / 3) * 127 + 128) << 8;
      int nB = (int)(Math.cos(rad + 4 * PI / 3) * 127 + 128);
      int nColor = nR | nG | nB;
      
      setGradient( i, 0, 1, h/2, 0xFFFFFF, nColor );
      setGradient( i, (h/2), 1, h/2, nColor, 0x000000 );
    }
    
    // draw black/white.
    drawRect( cw, 0,   30, h/2, 0xFFFFFF );
    drawRect( cw, h/2, 30, h/2, 0 );
    
    // draw grey scale.
    for( int j=0; j<h; j++ ) {
      int g = 255 - (int)(j/(float)(h-1) * 255 );
      drawRect( w-30, j, 30, 1, color( g, g, g ) );
    }
  }

  private void setGradient(int x, int y, float w, float h, int c1, int c2 ) {
    float deltaR = red(c2) - red(c1);
    float deltaG = green(c2) - green(c1);
    float deltaB = blue(c2) - blue(c1);

    for (int j = y; j<(y+h); j++) {
      int c = color( red(c1)+(j-y)*(deltaR/h), green(c1)+(j-y)*(deltaG/h), blue(c1)+(j-y)*(deltaB/h) );
      cpImage.set( x, j, c );
    }
  }
  
  private void drawRect( int rx, int ry, int rw, int rh, int rc ) {
    for(int i=rx; i<rx+rw; i++) {
      for(int j=ry; j<ry+rh; j++)  {
        cpImage.set( i, j, rc );
      }
    }
  }
  
  public void render () {
    image( cpImage, x, y );
  }
} 

//-----------------------------------------------------------------------------------------
// MOUSE CONTROL

public void mousePressed() {
  
 if( moveConnected == false || alwaysUseMouse == true )  clickedEvent = true; 
 
}

public void mouseDragged() {

 if( moveConnected == false || alwaysUseMouse == true ) {
   clicked = true;
 }

}

public void mouseReleased() {
 
 if( moveConnected == false || alwaysUseMouse == true ) {
   clicked = false;
 }
 
}
//moves the mouse when according to the blob
Robot mouseRobot;


//setup the mouse robot
public void setupMouseRobot(){
	try {

		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice[] gs = ge.getScreenDevices();
        if (paintscreenIndex >= gs.length){
        	println("No screen with index " + paintscreenIndex + " available. Falling back to primary screen");
        	paintscreenIndex = 0;
        } 
    	mouseRobot = new Robot(gs[paintscreenIndex]);
           	
  	} catch (AWTException e) {
    	println("Robot class not supported by your system!");
 		exit();
  	}
}


public void controlMouse(){
	//let the blob control the mouse when the menu is visible and 
	//the move is connected
	if(moveConnected && menu.isVisible()) {
		mouseRobot.mouseMove((int)blobX+frameXLocation, (int)blobY);
	}

	if(clicked){
		mouseRobot.mousePress(InputEvent.BUTTON1_MASK);
	}
	if(!clicked) {
		mouseRobot.mouseRelease(InputEvent.BUTTON1_MASK);
	}
}


//-----------------------------------------------------------------------------------------
// CONTROLLER

//MoveController move;
MoveController [] controllers; // Define an array of controllers

int rumbleLevel;
int sphereColor;

boolean moveConnected = true;

// Button enum
final int TRIGGER_BTN  = 0;
final int MOVE_BTN     = 1;
final int SQUARE_BTN   = 2;
final int TRIANGLE_BTN = 3;
final int CROSS_BTN    = 4;
final int CIRCLE_BTN   = 5;
final int START_BTN    = 6;
final int SELECT_BTN   = 7;
final int PS_BTN       = 8;
  

// Setup of the move -------------------------------------------------------------

public void psmoveInit() {
  int connected = psmoveapi.count_connected();

  // This is only fun if we actually have controllers
  if (connected == 0) {
    println("WARNING: No controllers connected.");
    moveConnected = false;
  }
  else if (debug) { 
    String plural = (connected > 1) ? "s":"";
    println("Found "+ connected + " connected controller" + plural);
  }

  controllers = new MoveController[connected];

  // Fill the array with controllers and light them up
  for (int i = 0; i<controllers.length; i++) {
    controllers[i] = new MoveController(i);       
    controllers[i].update(color(255, 0, 0), 0);
  }
} 
// END OF INIT


// Update of the move controller(s) ---------------------------------------------------------

public void psmoveUpdate() {  
  
  for (int i = 0; i<controllers.length; i++) {
    
    rumbleLevel = 0;


    sphereColor = color(
      (int)cs.getColorSlot(activeColorSlot).getRed(), 
      (int)cs.getColorSlot(activeColorSlot).getGreen(), 
      (int)cs.getColorSlot(activeColorSlot).getBlue()
    );
 
    
    // Detect presses on the cap
    if( alwaysUseMouse == false ) {
      clicked = controllers[i].isTriggerPressed();
      clickedEvent = controllers[i].isTriggerPressedEvent();
    }
    
    //if(printDebug) println("clicked = "+clicked);
      
    // Switch through color slots for color selection
    if ( controllers[i].isSquarePressedEvent() ) {
       switchColorSlot();
    }
    
    // Show/hide menub
    if ( controllers[i].isTrianglePressedEvent() ) {
       toggleMenu();
       drawPaintBg();
    }
     
    //sphereColor = color(controllers[i].getTriggerValue());
    
    // Poll controller and update actuators
    controllers[i].update( rumbleLevel, sphereColor );
  }

}


// Controller class -------------------------------------------------------------

// HIC SVNT LEONES!

class MoveController extends PSMove {
  

  int triggerValue, previousTriggerValue;
  
  long [] pressed = {0};                         // Button press events
  long [] released = {0};                        // Button release events 
  
  MoveButton[] buttonList = new MoveButton[9];  // The move controller has 9 buttons
  
  boolean isTriggerPressed, isMovePressed, isSquarePressed, isTrianglePressed, isCrossPressed, isCirclePressed, isStartPressed, isSelectPressed, isPsPressed; 

  
  MoveController(int i) {
    super(i);
    init();
  }
  
  public void init() {
    createButtons();
    movePoll();
  }
  
  //Populate the moveButton[] array of the controller with MoveButton objects.
  public void createButtons() {
    for (int i=0; i<buttonList.length; i++) {
      buttonList[i] = new MoveButton();
    }
  }

  
  
  // Trigger value --------------------------------------------------------
  
  public int getTriggerValue() {
    return buttonList[TRIGGER_BTN].getValue();
  }

  // Button presses --------------------------------------------------------
  
  public boolean isTriggerPressed() {
    return buttonList[TRIGGER_BTN].isPressed();
  }

  public boolean isMovePressed() {
    return buttonList[MOVE_BTN].isPressed();
  }

  public boolean isSquarePressed() {
    return buttonList[SQUARE_BTN].isPressed();
  }

  public boolean isTrianglePressed() {
    return buttonList[TRIANGLE_BTN].isPressed();
  }

  public boolean isCrossPressed() {
    return buttonList[CROSS_BTN].isPressed();
  }

  public boolean isCirclePressed() {
    return buttonList[CIRCLE_BTN].isPressed();
  }

  public boolean isSelectPressed() {
    return buttonList[SELECT_BTN].isPressed();
  }

  public boolean isStartPressed() {
    return buttonList[START_BTN].isPressed();
  }

  public boolean isPsPressed() {
    return buttonList[PS_BTN].isPressed();
  }    

  // --------------------------------------------------------
  // Button events 
  
  // Tells if a given button was pressed/released
  // since the last call to the event function

  // --------------------------------------------------------
  // Pressed

  public boolean isTriggerPressedEvent() {
    boolean event = buttonList[TRIGGER_BTN].isPressedEvent();
    return event;
  }

  public boolean isMovePressedEvent() {
    boolean event = buttonList[MOVE_BTN].isPressedEvent();
    return event;
  }

  public boolean isSquarePressedEvent() {
    boolean event = buttonList[SQUARE_BTN].isPressedEvent();
    return event;
  }

  public boolean isTrianglePressedEvent() {
    boolean event = buttonList[TRIANGLE_BTN].isPressedEvent();
    return event;
  }

  public boolean isCrossPressedEvent() {
    boolean event = buttonList[CROSS_BTN].isPressedEvent();
    return event;
  }

  public boolean isCirclePressedEvent() {
    boolean event = buttonList[CIRCLE_BTN].isPressedEvent();
    return event;
  }

  public boolean isSelectPressedEvent() {
    boolean event = buttonList[SELECT_BTN].isPressedEvent();
    return event;
  }

  public boolean isStartPressedEvent() {
    boolean event = buttonList[START_BTN].isPressedEvent();
    return event;
  }

  public boolean isPsPressedEvent() {
    boolean event = buttonList[PS_BTN].isPressedEvent();
    return event;
  }   

  // Released --------------------------------------------------------

  public boolean isTriggerReleasedEvent() {
    boolean event = buttonList[TRIGGER_BTN].isReleasedEvent();
    return event;
  }

  public boolean isMoveReleasedEvent() {
    boolean event = buttonList[MOVE_BTN].isReleasedEvent();
    return event;
  }

  public boolean isSquareReleasedEvent() {
    boolean event = buttonList[SQUARE_BTN].isReleasedEvent();
    return event;
  }

  public boolean isTriangleReleasedEvent() {
    boolean event = buttonList[TRIANGLE_BTN].isReleasedEvent();
    return event;
  }

  public boolean isCrossReleasedEvent() {
    boolean event = buttonList[CROSS_BTN].isReleasedEvent();
    return event;
  }

  public boolean isCircleReleasedEvent() {
    boolean event = buttonList[CIRCLE_BTN].isReleasedEvent();
    return event;
  }

  public boolean isSelectReleasedEvent() {
    boolean event = buttonList[SELECT_BTN].isReleasedEvent();
    return event;
  }

  public boolean isStartReleasedEvent() {
    boolean event = buttonList[START_BTN].isReleasedEvent();
    return event;
  }

  public boolean isPsReleasedEvent() {
    boolean event = buttonList[PS_BTN].isReleasedEvent();
    return event;
  }
  

  
  // Update --------------------------------------------------------

  public void update(int _rumbleLevel, int _sphereColor) {
    
    movePoll();
    
    int r, g, b;
    
    r = (int)red(_sphereColor);
    g = (int)green(_sphereColor);
    b = (int)blue(_sphereColor);
    
    super.set_leds(r, g, b);
    
    super.set_rumble(_rumbleLevel);
    
    super.update_leds(); // actually, it also updates the rumble... don't ask
    
  } // END OF UPDATE
  
  
  
  // updatePoll --------------------------------------------------------
  // Read inputs from the Move controller (buttons and sensors)


  private void movePoll() { 
      
    // Update all readings in the PSMove object
          
    while ( super.poll() != 0 ) {} 
    
    // Start by reading all the buttons from the controller
    
    int buttons = super.get_buttons();      
        
    // Then update individual MoveButton objects in the buttonList array
    
    
    if ((buttons & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      buttonList[MOVE_BTN].press();
    }
    // ERROR: this causes nullPointerException
    else if (buttonList[MOVE_BTN].isPressed()) {
      buttonList[MOVE_BTN].release();
    }
    
    if ((buttons & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      buttonList[SQUARE_BTN].press();
    } 
    else if (buttonList[SQUARE_BTN].isPressed()) {
      buttonList[SQUARE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      buttonList[TRIANGLE_BTN].press();
    } 
    else if (buttonList[TRIANGLE_BTN].isPressed()) {
      buttonList[TRIANGLE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      buttonList[CROSS_BTN].press();
    } 
    else if (buttonList[CROSS_BTN].isPressed()) {
      buttonList[CROSS_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      buttonList[CIRCLE_BTN].press();
    } 
    else if (buttonList[CIRCLE_BTN].isPressed()) {
      buttonList[CIRCLE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      buttonList[START_BTN].press();
    } 
    else if (buttonList[START_BTN].isPressed()) {
      buttonList[START_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      buttonList[SELECT_BTN].press();
    } 
    else if (buttonList[SELECT_BTN].isPressed()) {
      buttonList[SELECT_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      buttonList[PS_BTN].press();
    } 
    else if (buttonList[PS_BTN].isPressed()) {
      buttonList[PS_BTN].release();
    }

    // Now the same for the events
    
    // Start by reading all events from the controller
    
    super.get_button_events(pressed, released);
    // Then register the current individual events to the corresponding MoveButton objects in the buttonList array
    if ((pressed[0] & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      if (debug) println("The Move button was just pressed.");
      buttonList[MOVE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      if (debug) println("The Move button was just released.");
      buttonList[MOVE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      if (debug) println("The Square button was just pressed.");
      buttonList[SQUARE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      if (debug) println("The Square button was just released.");
      buttonList[SQUARE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      if (debug) println("The Triangle button was just pressed.");
      buttonList[TRIANGLE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      if (debug) println("The Triangle button was just released.");
      buttonList[TRIANGLE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      if (debug) println("The Cross button was just pressed.");
      buttonList[CROSS_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      if (debug) println("The Cross button was just released.");
      buttonList[CROSS_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      if (debug) println("The Circle button was just pressed.");
      buttonList[CIRCLE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      if (debug) println("The Circle button was just released.");
      buttonList[CIRCLE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      if (debug) println("The Start button was just pressed.");
      buttonList[START_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      if (debug) println("The Start button was just released.");
      buttonList[START_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      if (debug) println("The Select button was just pressed.");
      buttonList[SELECT_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      if (debug) println("The Select button was just released.");
      buttonList[SELECT_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      if (debug) println("The PS button was just pressed.");
      buttonList[PS_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      if (debug) println("The PS button was just released.");
      buttonList[PS_BTN].eventRelease();
    }

    
    // Read the trigger information from the controller
    
    previousTriggerValue = triggerValue;             // Store the previous value
    triggerValue = super.get_trigger();              // Get the new value
    buttonList[TRIGGER_BTN].setValue(triggerValue); // Send the value to the button object

    
    // press/release behaviour for the trigger
    
    if (triggerValue>0) {
      buttonList[TRIGGER_BTN].press();
      if (previousTriggerValue == 0) { // Catch trigger presses
        if (debug) println("The Trigger button was just pressed.");
        buttonList[TRIGGER_BTN].eventPress();
      }
    }
    else if (previousTriggerValue>0) { // Catch trigger releases
      if (debug) println("The Trigger button was just released.");
      buttonList[TRIGGER_BTN].eventRelease();
      buttonList[TRIGGER_BTN].release();
    }
    else buttonList[TRIGGER_BTN].release();
    
  }
  // END OF UPDATE POLL
  
  public void shutdown() {
      super.set_rumble(0);
      super.set_leds(0, 0, 0);
      super.update_leds();
  }
  

}

// END OF MOVE CONTROLLER



// Button class -------------------------------------------------------------

class MoveButton {

  
  boolean isPressed;
  //boolean isPressedEvent, isReleasedEvent;
  int value, previousValue; // For analog buttons only (triggers)
  
  
  // We store multiple catchers for the event in case we need to make 
  // several queries; the event catcher is set to false after the query 
  // so we can only use each event catcher once. To do so, we can use 
  // isPressedEvent(i) where i is the id of the catcher.
  boolean[] pressedEvents;
  boolean[] releasedEvents;

  
  MoveButton() {
    isPressed = false;
    pressedEvents = new boolean[64];
    releasedEvents = new boolean[64];
    value = 0;
  }
  

  public void press() {
    isPressed = true;
  }

  
  public void release() { 
    isPressed = false;
  }
  
  
  public void eventPress() {
    for(int i=0; i < pressedEvents.length; i++) {
      pressedEvents[i] = true; // update all the event catchers
    }
  }
  
  
  public void eventRelease() {
    for(int i=0; i < releasedEvents.length; i++) {
      releasedEvents[i] = true; // update all the event catchers
    }
  }
  
  
  public boolean isPressedEvent() {
    if(pressedEvents[0]) {
      pressedEvents[0] = false; // Reset the main event catcher
      return true;
    }
    return false;
  }
  
  
  public boolean isReleasedEvent() {
    if(releasedEvents[0]) {
      releasedEvents[0] = false; // Reset the main event catcher
      return true;
    }
    return false;
  }
  
  
  public boolean isPressedEvent(int i) {
    if(pressedEvents[i]) {
      pressedEvents[i] = false; // Reset the selected event catcher
      return true;
    }
    return false;
  }
  
  
  public boolean isReleasedEvent(int i) {
    if(releasedEvents[i]) {
      releasedEvents[i] = false; // Reset the selected event catcher
      return true;
    }
    return false;
  }
  
  
  public boolean isPressed() {
    return isPressed;
  }

  
  public void setValue(int _val) { 
    previousValue = value;
    value = _val;
  }
  
  
  public int getValue() {    
    return value;
  }
   
}
class ScreenPreview {
	
	boolean isVisible = false;
	GSCapture screenImage;

	int width;
	int height;

	ScreenPreview( int w, int h ) {
		this.width  = w;
		this.height = h;
	}

	public void setScreen(GSCapture scrImg) {
		screenImage = scrImg;
	}

	public boolean isVisible() {
		return isVisible;
	}

	public void show() {
		println("SHOW the preview!");
		if(this.isVisible == false){
			isVisible = true;
		}
		else {
			println("ScreenPreview.show() error: screen is already visible");
		}
	}

	public void hide() {
		println("HIDE the preview!");
		if(this.isVisible == true){
			isVisible = false;
		}
		else {
			println("ScreenPreview.show() error: screen is already hidden");
		}
	}

	public void draw() {
		if(null != screenImage) {
			image(screenImage, 0,0, this.width, this.height);
		}
		else {
			println("ERROR: ScreenPreview.draw() doesn't have an image to display");
		}
	}

}


//-----------------------------------------------------------------------------------------
// SHADER / PAINT


//-----------------------------------------------------------------------------------------
// The Spray Manager creates, updates, draws and deletes strokes


class SprayManager { 
 
  ArrayList<Path> strokeList;
   
  PShader pointShader;
  Path s;
  
  float depthOffset;
  float offsetVel;
  
  // Spray density distribution expressed in grayscale gradient
  PImage sprayMap;
 
 int col;
 float weight = brushSize;
 
 //boolean clickEv;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
   col = color(0);
 }
 
 public void setup() {
    
    depthOffset = 0.0f;
    offsetVel = 0.0005f;
    
    // brushMap is set in settings.properties
    sprayMap = loadImage(brushMap);
    
    pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");
    pointShader.set( "sprayMap", sprayMap );
    
  }

  public void initSpray() {
  //if(printDebug) println("void initSpray() {");
  
      Path newStroke = new Path();
      //if(printDebug) println("Path newStroke = new Path();");
      
      //if(printDebug) println("strokeList.size()"+strokeList.size());
      
      strokeList.add(newStroke);
      //if(printDebug) println("strokeList.add(newStroke);");
      
      //if(printDebug) println("strokeList.size()"+strokeList.size());
  }
  
  public void spray(PGraphics targetBuffer) {

    
    
    depthOffset += offsetVel;
    
    
    // OPTIMIZE: move outside of the class. This should be passed to the object.
    ColorSlot activeCS = cs.getColorSlot(activeColorSlot);
    int selectedColor = color(activeCS.getRed(), activeCS.getGreen(), activeCS.getBlue());
    
    //this.setWeight(weight);
    this.setColor(selectedColor);
  
    // spray when controller trigger is pressed
    if ( moveConnected == true && clicked == true && alwaysUseMouse == false ) {
        
        Knot k = new Knot(blobX, blobY, weight, col);        
        getActiveStroke().add(k);
        
    }
    
    // if no controller present or we chose to use mouse by default, spray on mouse click
    else if ( clicked == true ) {
      
        Knot k = new Knot(mouseX, mouseY, weight, col);
        getActiveStroke().add(k);
        
    }
    
    this.draw(targetBuffer);
    
  }
 
 
 // Draw newly added points 
 // NOTE: points are only drawn once so you should not redraw the background
 public void draw(PGraphics buffer) {
   for(Path p: strokeList) {
     p.draw(buffer, pointShader);
   }
 }
 
 
 // Clear the screen with a solid color
 
 public void reset( PGraphics targetBuffer, int background ) {
   
   targetBuffer.beginDraw();
   targetBuffer.background(background);
   targetBuffer.endDraw();
   clearAll();
   
 }
 
 
 // Clear the screen with a frame buffer (PGraphics)
 
 public void reset( PGraphics targetBuffer, PGraphics background ) {
   targetBuffer.beginDraw();
   targetBuffer.image(background,0,0);
   targetBuffer.endDraw();
   clearAll();
 }
 
 
 // Clear the screen with an image
 
 public void reset( PGraphics targetBuffer, PImage background ) {
   targetBuffer.beginDraw();
   targetBuffer.image(background,0,0);
   targetBuffer.endDraw();
   clearAll();
 }
 
 // Delete all the strokes
 public void clearAll() {
   
   for(Path p: strokeList) {
     p.clear();
   }
   
   strokeList.clear();
 }
 
 /*
 void newStroke(float x, float y, float weight) {
 if(printDebug) println("void newStroke(float x, float y, float weight) {");
   
     Knot startingKnot = new Knot(x, y, weight, col);
     if(printDebug) println("Knot startingKnot = new Knot(x, y, weight, col);");
     
     Path stroke = new Path();
     if(printDebug) println("Path stroke = new Path();");
     
     stroke.add(startingKnot);
     if(printDebug) println("stroke.add(startingKnot);");
     
     strokeList.add(stroke);
     if(printDebug) println("strokeList.add(stroke);");
   
 }
 */
 
 /*
 // Add a point the the current path
 void newKnot(float x, float y, float weight) { 
 if(printDebug) println("void newKnot(float x, float y, float weight) {");
 
   Knot newKnot = new Knot(x, y, weight, col);
   if(printDebug) println("Knot newKnot = new Knot(x, y, weight, col);");
   
   //activeStroke.add(newKnot);
   //if(printDebug) println("activeStroke.add(newKnot);");
   
 }
 */
 
 // Return the path beeing drawn at the moment
 public Path getActiveStroke() {
   //if(printDebug) println("Path getActiveStroke() {");
   
   //if(printDebug) println("(strokeList.size() - 1) = "+(strokeList.size() - 1)); 
   
   Path activeStroke = strokeList.get( strokeList.size() - 1 );
   //if(printDebug) println("Path p = strokeList.get( strokeList.size() - 1 ); ["+ (strokeList.size() - 1) +"]");
   
   return activeStroke;
 }
 
 // Set the size of the spray (overwrite the value from setting.properties)
 public void setWeight(float size) {
   weight = size;
   brushSize = size; // 
 }
 
 // Set the color of the spray
 public void setColor(int tint) {
   col = tint;
 }
 
 public int getColor() {
   return col;
 }

}


//-----------------------------------------------------------------------------------------
// The Path object contains a list of knots (points)



// The Path object contains a list of points

class Path {
  
  ArrayList<Knot> pointList;       // raw point list
  
  Knot previousKnot;
  Knot currentKnot;
  
  float mag;
  float numSteps;
  float distMin = 0;
  float stepSize = 1;
  
  Path() {
    pointList = new ArrayList<Knot>();
  }
  
  /*
  // When the first knot is added, we want to create the list
  void createList(Knot k) {
    
    previousKnot = k;
    currentKnot  = k;
    
    if( null == pointList ) pointList = new ArrayList<Knot>();
    
    pointList.add(previousKnot);
    pointList.add(currentKnot);
  }
  */
  
  // Add a new knot and all knots between it and 
  // the previous knot, based on the defined step size
  public void add(Knot k) {
    
    currentKnot = k;
    //if(printDebug) println("currentKnot = k;");
    
    int size = pointList.size();
    //if(printDebug) println("int size = pointList.size();");
    
    if(size == 0) { 
    //if(printDebug) println("if(size == 0) { ");
    
      pointList.add(currentKnot); 
      //if(printDebug) println("pointList.add(currentKnot);");
      
    } else if( size > 0 ) {
      
      /*
      int prev = ( size-1 < 0 ) ? 0 : size-1; // filter negative values
      if(printDebug) println("int prev = ( size-1 < 0 ) ? 0 : size-1; ["+prev+"]");
      */
      
      previousKnot = pointList.get( size-1 );
      //if(printDebug) println("previousKnot = pointList.get( prev );");
      
      // Compute the vector from previous to current knot
      PVector prevPos  = previousKnot.getPos();
      PVector newPos   = currentKnot.getPos();
      PVector velocity = PVector.sub(newPos, prevPos);
   
      // How many points can we fit between the two last knots?
      float mag = velocity.mag();
      
      // Create intermediate knots and pass them interpolated parameters
      if( mag > stepSize ) {
        
        numSteps = mag/stepSize;
        for(int i=1; i<numSteps; i++ ) {
          
          float interpolatedX = lerp ( previousKnot.x,  currentKnot.x,  i/numSteps );
          float interpolatedY = lerp ( previousKnot.y,  currentKnot.y,  i/numSteps );
          
          float interpolatedSize  = lerp      ( previousKnot.getSize(),  currentKnot.getSize(),  i/numSteps );
          int interpolatedColor = lerpColor ( previousKnot.getColor(), currentKnot.getColor(), i/numSteps );
          
          Knot stepKnot = new Knot(interpolatedX, interpolatedY, interpolatedSize, interpolatedColor);
          
          //if(previousKnot.getBuffer() == paintscreen) println("paintScreen");
          //if(previousKnot.getBuffer() == wallscreen) println("wallScreen");
          
          pointList.add(stepKnot);
          
        }
      }
      else {
        pointList.add(currentKnot);
      }
      
    }
    
  }
  
  
  public void draw(PGraphics targetBuffer, PShader pointShader) {
    for(Knot p: pointList) {
      p.draw(targetBuffer, pointShader);
    }
  }
  
  
  public void clear() {
    pointList.clear();
  }
  
}


//-----------------------------------------------------------------------------------------
// Each point in the path object is a knot with it's own properties (color, size, angle, etc)

class Knot extends PVector {
  
  float size;
  int col;
  float angle;
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay

  boolean isDrawn = false;
  
  Knot(float x, float y, float s, int tint) {
    super(x, y);
    size  = s;
    col   = tint;
    angle = 0.0f;
    noiseDepth = random(1.0f);
    timestamp  = millis();
  }
  
  /*
  Knot(float x, float y, float size, float angle, float noiseDepth, float timeStamp) {
    super(x, y);
    size = size;
    angle = angle;
    noiseDepth = noiseDepth;
    timestamp = timeStamp;
  }
  */
  
  public PVector getPos() {
    return new PVector(x,y);
  }
  
  public float getSize() {
    return size;
  }
  
  public int getColor() {
    return col; 
  }
  
  public void draw(PGraphics targetBuffer, PShader pointShader) {
    
    float x = this.x;
    float y = this.y;
    
    PVector dir = new PVector(x, y);
    dir.normalize();

    if(!isDrawn) {
      
      pointShader.set( "weight", brushSize ); // set in settings.properties
      pointShader.set( "direction", dir.x, dir.y );
      pointShader.set( "rotation", random(0.0f,1.0f), random(0.0f,1.0f) );
      pointShader.set( "scale", 0.3f );
      pointShader.set( "soften", brushSoften ); // set in settings.properties
      pointShader.set( "depthOffset", noiseDepth );
      
      // Draw in the buffer (if one was defined) or directly on the viewport
      if (null!=targetBuffer)  {
        targetBuffer.pushStyle();
        targetBuffer.shader(pointShader, POINTS);
        targetBuffer.strokeWeight(brushSize); // set in settings.properties
        targetBuffer.stroke(col);
        targetBuffer.point(x,y);
        targetBuffer.popStyle();
        
        targetBuffer.resetShader();
        
        /*
        if(printDebug) {
          targetBuffer.pushStyle();
          targetBuffer.noStroke();
          targetBuffer.fill(255,0,0);
          targetBuffer.ellipse(x,y,3,3);
          targetBuffer.popStyle();
        }
        */
      }
      //else                      point(x,y);
      
      //targetBuffer.resetShader();
      
      isDrawn = true;
    }
    
  }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "bombIR" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
