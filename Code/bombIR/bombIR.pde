
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
- use opencv for capturing the wall
- get aspect ratio of wallscreen for match the painting area
- saving of keystone configurations not working (yet)
  
*/

// IMPORTS
//-----------------------------------------------------------------------------------------
import deadpixel.keystone.*;
import controlP5.*;
import io.thp.psmove.*;


  
// DECLARATIONS
//-----------------------------------------------------------------------------------------  
Keystone ks;
CornerPinSurface surface, paintbg;
PGraphics wallscreen, paintscreen, paintbackground;




// GLOBAL VARIABLES
//-----------------------------------------------------------------------------------------

int windowHeight = 384;
int windowWidth = 1024;
boolean clicked = false;
boolean calib=false;

  public void init() {
    
    // remove the window frame
    frame.removeNotify(); 
    frame.setUndecorated(true);
    frame.addNotify();
    super.init();
  }

//-----------------------------------------------------------------------------------------
  
  void setup() {
        //P3D or OPENGL seems to only work with one window (https://forum.processing.org/topic/opengl-rendering-multiple-windows-frames), 
        //so we make it big enough to span over all three output devices (Laptop, rp screen projector, wall projector)
  	size(windowWidth, windowHeight, P3D);
        
        //create painting screen
        paintscreen = createGraphics(windowWidth/2,windowHeight,P3D);
        paintscreen.background(255,255,255,0);
        
        //setup wall screen
	setupKeystone(); 
                
        //setup the spraypaint shader
        setupSpraypaint();
        
        //setup the control menu (colorpicker, clear screen, save, etc.)
        setupMenu();
        
        //Init the PSMove controller
        psmoveInit();
		
        //put the upper left corner of the frame to the upper left corner of the screen
        //needs to be the last call on setup to work
	frame.setLocation(0,0);
  } // end SETUP
  
  //-----------------------------------------------------------------------------------------
  
  void draw() {
   	PVector surfaceMouse = paintbg.getTransformedMouse();
        //draw background for painting screen on first frame
        if(frameCount == 1 ) {
          drawBackgroundImage();
          paintbg.render(paintbackground);
        }
        
       	
	//draw painting screen
        paintscreen.beginDraw();
        if(!menu.isVisible() && calib == false){
          spray();
        }
        paintscreen.endDraw();
        
	//draw wall screen
        wallscreen.beginDraw();
        //redraw the background of the wallscreen during calibration  
        //for the calibration view to work
        if(ks.isCalibrating()){
          wallscreen.background(0);
        }
        wallscreen.image(paintscreen,0,0); 
        
        wallscreen.endDraw();
        //redraw the main backgound for calibration and male sure
        //that the imagebackground is drawn as well
        if(ks.isCalibrating()){
          background(0);
          paintbg.render(paintbackground);
        }
      
        //draw painting area
        image(paintscreen,0,0);
            
        //render the wall screen
	surface.render(wallscreen);

        if(menu.isVisible()){
          cp.render();
          pickColor();
        }
        
         // Playstation Move udptate
        psmoveUpdate();
    
  } // end DRAW

  
  

  
  
//-----------------------------------------------------------------------------------------

