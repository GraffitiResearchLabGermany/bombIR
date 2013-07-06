
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
 *  keystone
 * ----------------------------------------------------------------------------
 */
//-----------------------------------------------------------------------------------------

/*
TO DO 
- saving of keystone configurations not working (yet)
- IRCam calibration
- Menu positioning and sizing
  
*/

// IMPORTS
//-----------------------------------------------------------------------------------------
import deadpixel.keystone.*;
import controlP5.*;
import io.thp.psmove.*;
import java.util.Properties;
import codeanticode.gsvideo.*;
//import monclubelec.javacvPro.*; 
import blobDetection.*;


  
// DECLARATIONS
//-----------------------------------------------------------------------------------------  
Keystone ks;
CornerPinSurface surface, paintbg;
PGraphics wallscreen, paintscreen, paintbackground;
<<<<<<< HEAD

// Spray renderers
SprayManager sprayManagerLeft; // paint screen (left)
SprayManager sprayManagerRight;  // wall screen (right)
=======
>>>>>>> upstream/develop


// GLOBAL VARIABLES
//-----------------------------------------------------------------------------------------
boolean clicked = false;
boolean clickedEvent = false;
boolean calibrateKeystone = false;
boolean printDebug = true;

//-----------------------------------------------------------------------------------------

public void init() {
  // remove the window frame
  frame.removeNotify(); 
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

//-----------------------------------------------------------------------------------------
  
  void setup() {
    
        // Create the spray objects for both screens
        sprayManagerLeft   = new SprayManager();
        sprayManagerRight  = new SprayManager();
        
        //read the values from the configuration file
        readConfiguration();
        
        //P3D or OPENGL seems to only work with one window (https://forum.processing.org/topic/opengl-rendering-multiple-windows-frames), 
        //so we make it big enough to span over all three output devices (Laptop, rp screen projector, wall projector)
  	size(windowWidth, windowHeight, P3D);
        
        //create painting screen
        paintscreen = createGraphics(windowWidth/2, windowHeight, P3D);
        wallscreen = createGraphics(windowWidth/2, windowHeight, P3D);
        
        //setup wall screen
        setupKeystone(); 
        
        paintscreen.beginDraw();
        paintscreen.image(paintbackground,0,0); // loaded in setupKeystone
        paintscreen.strokeCap(SQUARE);
        paintscreen.endDraw();
        
        wallscreen.beginDraw();
        wallscreen.background(0);
        wallscreen.strokeCap(SQUARE);
        wallscreen.endDraw();
        
        //setup opencv & video capture
        setupCamera();
        
        //setup the spraypaint shader
        sprayManagerLeft.setup();
        sprayManagerRight.setup();
        
        //setup the control menu (colorpicker, clear screen, save, etc.)
        setupMenu();
        
        // setup the menu for the calibration screen
        setupCalibrationMenu();
        
        //Init the PSMove controller(s)
        psmoveInit();
		
        //put the upper left corner of the frame to the upper left corner of the screen
        //needs to be the last call on setup to work
	frame.setLocation(0,0);

  } // end SETUP
  
  //-----------------------------------------------------------------------------------------
  
  void draw() {
    
    // Calibration Stage
    if(calibrateCamera) {
      runCameraCalibration();
    }
    
    // Main Draw Loop
    else {
      
      //PVector surfaceMouse = paintbg.getTransformedMouse();
      
      //draw background for painting screen on first frame
      if(frameCount == 1 ) {
        paintbg.render(paintbackground);
      }
      
      // Read Cam
      if (ct.getCam().available() == true) {
        ct.getCam().read();
      }
      
      // Compute Blobs
      ct.setThreshold(blobThresh);
      
      // Show Cam ?
      if(showCam == true) {
        image(ct.getCam(), 0, 0, firstWindowWidth, windowHeight);
      } 
      
      // Show Blob ?
      if(showBlob == true) {
        if(!showCam) {
          background(0);
          paintbg.render(paintbackground);
        }
        drawBlobsAndEdges(true, false);
      }
     	
      getCurrentBlob();
      
      //draw painting screen
      paintscreen.beginDraw();
        if(!menu.isVisible() && !calibMenu.isVisible() && calibrateKeystone == false) {
          if(clickedEvent) sprayManagerLeft.initSpray();
          sprayManagerLeft.spray(paintscreen);
        }
      paintscreen.endDraw();
      
      //draw wall screen
      wallscreen.beginDraw();
          //redraw the background of the wallscreen during calibration  
          //for the calibration view to work
          //if(ks.isCalibrating()){
            //wallscreen.background(0);
          //}
          if(!menu.isVisible() && !calibMenu.isVisible() && calibrateKeystone == false) {
            if(clickedEvent) sprayManagerRight.initSpray();
            sprayManagerRight.spray(wallscreen);
          }
      wallscreen.endDraw();
      
      //redraw the main backgound for calibration and make sure
      //that the imagebackground is drawn as well
      if(ks.isCalibrating()){
        //background(0);
        //paintbg.render(paintbackground);
      }
    
      //draw painting area (left)
      image(paintscreen,0,0);
      
      //draw the projection area (right)
      image(wallscreen,width/2,0);
          
      //render the wall screen with keystone
      //surface.render(wallscreen);
  
      // GUI
      if(menu.isVisible()){
        cp.render();
        pickColor();
      }
    
    } 
    
    // Playstation Move update
    psmoveUpdate();
    
    if(debug) println("Framerate: " + int(frameRate));

    
  } // end DRAW

  
  
//-----------------------------------------------------------------------------------------
