/**
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

/**
 * IMPORTS
 */
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
import java.util.logging.Logger;
import java.util.logging.Level;

  
/**
 * DECLARATIONS
 */ 

/**
 * Screen that is projected to the big wall
 */
PGraphics wallscreen;
/**
 * Screen that is painted on aka the rear projection screen
 */
PGraphics paintscreen;
/**
 * Screen to display a background on the paintscreen (f.e. a graphic matching the wall to project on)
 */
PGraphics paintbackground;
/**
 * Image to display on the paintbackground screen
 */
PImage bg;
/**
 * TODO: Document this object declaration
 */
ScreenPreview capturePreview;
/**
 * Logger for bombIR to display logging messages
 */
private final static Logger logger = Logger.getLogger(bombIR.class.getName());
/**
 * Spray renderer for the paintscreen (left)
 */
SprayManager sprayManagerLeft;
/**
 * Spray renderer for the wallscreen (right)
 */
SprayManager sprayManagerRight;

// TODO: can we remove this?
// Robot mouse
//Robot robot;

/**
 * TODO: Document this declaration
 */
boolean clicked = false;
/**
 * TODO: Document this declaration
 */
boolean clickedEvent = false;
/**
 * TODO: Document this declaration
 */
boolean calibrateKeystone = false;


/**
 * Init the object to manipulate the window
 */
public void init() {
  // remove the window frame
  frame.removeNotify(); 
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}


/**
 * Setting up bombIR
 */  
void setup() {
  logger.setLevel(Level.INFO);
  cursor(CROSS);
    
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
  
/**
 * The main draw method
 */
void draw() {
    
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
      
    /*
    // Show Cam ?
    if(showCam == true) {
        
      println("test");
        
      //image(ct.getCam(), 0, 0, firstWindowWidth, windowHeight);
      float mult = width /  ct.getWidth();
      float w = ct.getWidth() * mult;
      float h = ct.getHeight() * mult;
      image(ct.getCam(), 0, -(h-height)/2, w, h);
        
    } 
    */
      
      
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
        if(clickedEvent) { 
          sprayManagerLeft.initSpray();
          sprayManagerLeft.limitStrokes(maxStrokes);
        }
        sprayManagerLeft.spray(paintscreen);
        //if(showSize) sprayManagerLeft.showSize(paintscreen);
      }
    paintscreen.endDraw();
      
    //draw wall screen
    wallscreen.beginDraw();
        if(!menu.isVisible() && !calibMenu.isVisible() && calibrateKeystone == false) {
          if(clickedEvent) {
            sprayManagerRight.initSpray();
            sprayManagerRight.limitStrokes(maxStrokes);
          }
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
    
  logger.finest("Framerate: " + int(frameRate));

    
} // end DRAW

/**
 * Draw the background of the paintscreen
 */
void drawPaintBg(){
        paintbackground.beginDraw();
        paintbackground.image(bg,0,0);
        paintbackground.endDraw();
}